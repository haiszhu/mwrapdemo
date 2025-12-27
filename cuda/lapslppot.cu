#include <cuda_runtime.h>
#include <cstdio>
#include <math.h>

#define THRESH 1e-15

// block-reduced kernel: one block per target, threads stride over sources
__global__ void culapslppot_kernel_block(const double* __restrict__ src,
                                         const double* __restrict__ targ,
                                         const double* __restrict__ x,
                                         double* __restrict__ y,
                                         int N)
{
  extern __shared__ double sh[];

  const int i  = blockIdx.x;      // target index
  const int tid = threadIdx.x;

  const double tx = targ[0 + 3*i];
  const double ty = targ[1 + 3*i];
  const double tz = targ[2 + 3*i];
  const double threshsq = THRESH * THRESH;

  double acc = 0.0;
  for (int j = tid; j < N; j += blockDim.x) {
    double dx = src[0 + 3*j] - tx;
    double dy = src[1 + 3*j] - ty;
    double dz = src[2 + 3*j] - tz;
    double dd = dx*dx + dy*dy + dz*dz;
    if (dd > threshsq) acc += x[j] * rsqrt(dd);
  }

  // reduce within block
  sh[tid] = acc;
  __syncthreads();
  for (int offset = blockDim.x / 2; offset > 0; offset >>= 1) {
    if (tid < offset) sh[tid] += sh[tid + offset];
    __syncthreads();
  }
  if (tid == 0) y[i] = sh[0];
}

// src: 3xN (column-major MATLAB), targ: 3xM, x: N, y: M
__global__ void culapslppot_kernel(const double* src,
                                  const double* targ,
                                  const double* x,
                                  double* y,
                                  int N,
                                  int M)
{
  int i = blockDim.x * blockIdx.x + threadIdx.x;
  double threshsq = THRESH * THRESH;

  if (i < M) {
    double tx = targ[0 + 3*i];
    double ty = targ[1 + 3*i];
    double tz = targ[2 + 3*i];

    double acc = 0.0;
    for (int j = 0; j < N; ++j) {
      double dx = src[0 + 3*j] - tx;
      double dy = src[1 + 3*j] - ty;
      double dz = src[2 + 3*j] - tz;
      double dd = dx*dx + dy*dy + dz*dz;
      if (dd > threshsq) acc += x[j] * rsqrt(dd);
    }
    y[i] = acc;
  }
}


// C ABI entry called by mwrap-generated gateway.
// IMPORTANT: pointers are DEVICE pointers because of "gpu double[]" in .mw
extern "C" int lapslppot(const double* src,
                         const double* targ,
                         const double* x,
                         double* y,
                         int N,
                         int M)
{
  int threads = 256;
  int blocks  = (M + threads - 1) / threads;

  culapslppot_kernel<<<blocks, threads>>>(src, targ, x, y, N, M);

  cudaError_t err = cudaGetLastError();
  if (err != cudaSuccess) {
    std::fprintf(stderr, "CUDA launch error: %s\n", cudaGetErrorString(err));
    return 1;
  }
  err = cudaDeviceSynchronize();
  if (err != cudaSuccess) {
    std::fprintf(stderr, "CUDA sync error: %s\n", cudaGetErrorString(err));
    return 2;
  }
  return 0;
}

// Block-reduced variant: one block per target, parallel over sources
extern "C" int lapslppot_reduce(const double* src,
                                const double* targ,
                                const double* x,
                                double* y,
                                int N,
                                int M)
{
  int threads = 256;
  dim3 grid(M);
  size_t shmem = threads * sizeof(double);

  culapslppot_kernel_block<<<grid, threads, shmem>>>(src, targ, x, y, N);

  cudaError_t err = cudaGetLastError();
  if (err != cudaSuccess) {
    std::fprintf(stderr, "CUDA launch error (reduce): %s\n", cudaGetErrorString(err));
    return 1;
  }
  err = cudaDeviceSynchronize();
  if (err != cudaSuccess) {
    std::fprintf(stderr, "CUDA sync error (reduce): %s\n", cudaGetErrorString(err));
    return 2;
  }
  return 0;
}
