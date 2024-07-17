// gcc -mavx512f -mfma -c -o ckernels_expts.o ckernels_expts.c
#ifdef __cplusplus
extern "C" {
    void clap3ddlpmat_c_( int64_t *M, double *r0, int64_t *N, double *r, double *A);
    void csimd128lap3ddlpmat_c_(int64_t *M, double *r0, int64_t *N, double *r, double *A);
    void csimd256lap3ddlpmat_c_(int64_t *M, double *r0, int64_t *N, double *r, double *A);
    void csimd512lap3ddlpmat_c_(int64_t *M, double *r0, int64_t *N, double *r, double *A);
    }
#endif

// detect platform
#if defined(__arm__) || defined(__aarch64__)
  #define ARCH_ARM
#elif defined(__x86_64__) || defined(_M_X64)
  #if defined(__AVX2__)
    #define ARCH_AVX2
  #endif
  #define ARCH_X86
  #if defined(__AVX512F__)
    #define ARCH_AVX512
  #endif
#endif

#include <stdio.h>
#include <math.h>
#include <stdint.h>
#include <stdlib.h>

// not actual dlp... just using the name... 
void clap3ddlpmat_c_(  int64_t *M, double *r0, int64_t *N, double *r, double *A )
{
  int64_t m,n,i,j,k;
  double dx, dy, dz, rr;
  m = *M;
  n = *N;
  // 
  double *r0x = (double*)aligned_alloc(8, m * sizeof(double));
  double *r0y = (double*)aligned_alloc(8, m * sizeof(double));
  double *r0z = (double*)aligned_alloc(8, m * sizeof(double));
  // 
  for (i = 0; i < m; ++i) {
    r0x[i] = r0[3*i];
    r0y[i] = r0[3*i+1];
    r0z[i] = r0[3*i+2];
  }
  // 
  for (j=0; j<n; j++){
    for (i=0; i<m; i++){
      dx = r0x[i] - r[3*j];
      dy = r0y[i] - r[3*j+1];
      dz = r0z[i] - r[3*j+2];
      rr = dx*dx + dy*dy + dz*dz;
      A[m*j+i] = 1.0/sqrt(rr);
    }
  }
  // Free allocated memory
  free(r0x);
  free(r0y);
  free(r0z);
}

#ifdef ARCH_X86
#include <immintrin.h>

void csimd128lap3ddlpmat_c_(int64_t *M, double *r0, int64_t *N, double *r, double *A) {}

#if defined(ARCH_AVX2)
void csimd256lap3ddlpmat_c_(int64_t *M, double *r0, int64_t *N, double *r, double *A) 
{
  int64_t m, n, i, j, m4;
  m = *M;
  n = *N;
  m4 = (m/4)*4;
  // 
  double *r0x = (double*)aligned_alloc(32, m4 * sizeof(double));
  double *r0y = (double*)aligned_alloc(32, m4 * sizeof(double));
  double *r0z = (double*)aligned_alloc(32, m4 * sizeof(double));
  // 
  for (i = 0; i < m4; ++i) {
    r0x[i] = r0[3*i];
    r0y[i] = r0[3*i+1];
    r0z[i] = r0[3*i+2];
  }
  //   
  for (j = 0; j < n; ++j) {
    __m256d rx_v = _mm256_set1_pd(r[3*j]);
    __m256d ry_v = _mm256_set1_pd(r[3*j+1]);
    __m256d rz_v = _mm256_set1_pd(r[3*j+2]);
    __m256d ones_v = _mm256_set1_pd(1.0);
    for (i = 0; i <= m4 - 4; i += 4) {
      __m256d r0x_v = _mm256_load_pd(&r0x[i]);
      __m256d r0y_v = _mm256_load_pd(&r0y[i]);
      __m256d r0z_v = _mm256_load_pd(&r0z[i]);
      __m256d dx_v = _mm256_sub_pd(r0x_v, rx_v);
      __m256d dy_v = _mm256_sub_pd(r0y_v, ry_v);
      __m256d dz_v = _mm256_sub_pd(r0z_v, rz_v);
      __m256d rr_v = _mm256_add_pd(_mm256_add_pd(_mm256_mul_pd(dx_v, dx_v), _mm256_mul_pd(dy_v, dy_v)), _mm256_mul_pd(dz_v, dz_v));
      __m256d inv_sqrt_rr_v = _mm256_div_pd(ones_v, _mm256_sqrt_pd(rr_v));
      // _mm256_store_pd(&A[i+j*m], inv_sqrt_rr_v); // this one crashes
      _mm256_storeu_pd(&A[i+j*m], inv_sqrt_rr_v); // Moves to unaligned memory location

    }
    // compute the rest, simd over source? or not worth it
    for (i=m4; i<m; i++){
      double dx = r0[3*i]   - r[3*j];
      double dy = r0[3*i+1] - r[3*j+1];
      double dz = r0[3*i+2] - r[3*j+2];
      double rr = dx*dx + dy*dy + dz*dz;
      A[m*j+i]  = 1.0/sqrt(rr);
    }
  }
  free(r0x);
  free(r0y);
  free(r0z);
}
#else
void csimd256lap3ddlpmat_c_(int64_t *M, double *r0, int64_t *N, double *r, double *A) {}
#endif

#ifdef ARCH_AVX512
void csimd512lap3ddlpmat_c_(int64_t *M, double *r0, int64_t *N, double *r, double *A) 
{
  int64_t m, n, i, j, m8;
  m = *M;
  n = *N;
  m8 = (m/8)*8;
  // 
  double *r0x = (double*)aligned_alloc(64, m8 * sizeof(double));
  double *r0y = (double*)aligned_alloc(64, m8 * sizeof(double));
  double *r0z = (double*)aligned_alloc(64, m8 * sizeof(double));
  // 
  for (i = 0; i < m8; ++i) {
    r0x[i] = r0[3*i];
    r0y[i] = r0[3*i+1];
    r0z[i] = r0[3*i+2];
  }
  //   
  for (j = 0; j < n; ++j) {
    __m512d rx_v = _mm512_set1_pd(r[3*j]);
    __m512d ry_v = _mm512_set1_pd(r[3*j+1]);
    __m512d rz_v = _mm512_set1_pd(r[3*j+2]);
    __m512d ones_v = _mm512_set1_pd(1.0);
    for (i = 0; i <= m8 - 8; i += 8) {
      __m512d r0x_v = _mm512_load_pd(&r0x[i]);
      __m512d r0y_v = _mm512_load_pd(&r0y[i]);
      __m512d r0z_v = _mm512_load_pd(&r0z[i]);
      __m512d dx_v = _mm512_sub_pd(r0x_v, rx_v);
      __m512d dy_v = _mm512_sub_pd(r0y_v, ry_v);
      __m512d dz_v = _mm512_sub_pd(r0z_v, rz_v);
      __m512d rr_v = _mm512_add_pd(_mm512_add_pd(_mm512_mul_pd(dx_v, dx_v), _mm512_mul_pd(dy_v, dy_v)), _mm512_mul_pd(dz_v, dz_v));
      __m512d inv_sqrt_rr_v = _mm512_div_pd(ones_v, _mm512_sqrt_pd(rr_v));
      // _mm512_store_pd(&A[i+j*m], inv_sqrt_rr_v); // this one crashes
      _mm512_storeu_pd(&A[i+j*m], inv_sqrt_rr_v); // Moves to unaligned memory location

    }
    // compute the rest, simd over source? or not worth it
    for (i=m8; i<m; i++){
      double dx = r0[3*i]   - r[3*j];
      double dy = r0[3*i+1] - r[3*j+1];
      double dz = r0[3*i+2] - r[3*j+2];
      double rr = dx*dx + dy*dy + dz*dz;
      A[m*j+i]  = 1.0/sqrt(rr);
    }
  }
  free(r0x);
  free(r0y);
  free(r0z);
}
#else
void csimd512lap3ddlpmat_c_(int64_t *M, double *r0, int64_t *N, double *r, double *A) {}
#endif

#endif

#ifdef ARCH_ARM
#include <arm_neon.h>
void csimd128lap3ddlpmat_c_(int64_t *M, double *r0, int64_t *N, double *r, double *A) 
{
  int64_t m, n, i, j, m2;
  m = *M;
  n = *N;
  m2 = (m/2)*2;

  double *r0x = (double*)aligned_alloc(16, m2 * sizeof(double));
  double *r0y = (double*)aligned_alloc(16, m2 * sizeof(double));
  double *r0z = (double*)aligned_alloc(16, m2 * sizeof(double));

  for (i = 0; i < m2; ++i) {
    r0x[i] = r0[3*i];
    r0y[i] = r0[3*i+1];
    r0z[i] = r0[3*i+2];
  }

  for (j = 0; j < n; ++j) {
    float64x2_t rx_v = vdupq_n_f64(r[3*j]);
    float64x2_t ry_v = vdupq_n_f64(r[3*j+1]);
    float64x2_t rz_v = vdupq_n_f64(r[3*j+2]);
    float64x2_t ones_v = vdupq_n_f64(1.0);
    for (i = 0; i <= m2 - 2; i += 2) {
      float64x2_t r0x_v = vld1q_f64(&r0x[i]);
      float64x2_t r0y_v = vld1q_f64(&r0y[i]);
      float64x2_t r0z_v = vld1q_f64(&r0z[i]);
      float64x2_t dx_v = vsubq_f64(r0x_v, rx_v);
      float64x2_t dy_v = vsubq_f64(r0y_v, ry_v);
      float64x2_t dz_v = vsubq_f64(r0z_v, rz_v);
      float64x2_t rr_v = vaddq_f64(vaddq_f64(vmulq_f64(dx_v, dx_v), vmulq_f64(dy_v, dy_v)), vmulq_f64(dz_v, dz_v));
      float64x2_t inv_sqrt_rr_v = vdivq_f64(ones_v, vsqrtq_f64(rr_v));
      vst1q_f64(&A[i+j*m], inv_sqrt_rr_v);
    }
    for (i = m2; i < m; i++) {
      double dx = r0[3*i]   - r[3*j];
      double dy = r0[3*i+1] - r[3*j+1];
      double dz = r0[3*i+2] - r[3*j+2];
      double rr = dx*dx + dy*dy + dz*dz;
      A[m*j+i]  = 1.0/sqrt(rr);
    }
  }
  free(r0x);
  free(r0y);
  free(r0z);
}
void csimd256lap3ddlpmat_c_(int64_t *M, double *r0, int64_t *N, double *r, double *A) {}
void csimd512lap3ddlpmat_c_(int64_t *M, double *r0, int64_t *N, double *r, double *A) {}
#endif
