#include <cuda_runtime.h>
#include <cstdio>

#define THRESH 1e-15

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
