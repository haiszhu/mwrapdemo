#ifdef __cplusplus
extern "C" {
    void clap3ddlpmat_c_( int64_t *M, double *r0, int64_t *N, double *r, double *A);
    void cavx2lap3ddlpmat_c_(int64_t *M, double *r0, int64_t *N, double *r, double *A);
    }
#endif

#include <immintrin.h>
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
  double *r0x = (double*)aligned_alloc(32, m * sizeof(double));
  double *r0y = (double*)aligned_alloc(32, m * sizeof(double));
  double *r0z = (double*)aligned_alloc(32, m * sizeof(double));
  // 
  for (int64_t i = 0; i < m; ++i) {
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
}

void cavx2lap3ddlpmat_c_(int64_t *M, double *r0, int64_t *N, double *r, double *A) 
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
    for (i = 0; i <= m4 - 4; i += 4) {
      __m256d r0x_v = _mm256_load_pd(&r0x[i]);
      __m256d r0y_v = _mm256_load_pd(&r0y[i]);
      __m256d r0z_v = _mm256_load_pd(&r0z[i]);
      __m256d dx_v = _mm256_sub_pd(r0x_v, rx_v);
      __m256d dy_v = _mm256_sub_pd(r0y_v, ry_v);
      __m256d dz_v = _mm256_sub_pd(r0z_v, rz_v);
      __m256d rr_v = _mm256_add_pd(_mm256_add_pd(_mm256_mul_pd(dx_v, dx_v), _mm256_mul_pd(dy_v, dy_v)), _mm256_mul_pd(dz_v, dz_v));
      __m256d inv_sqrt_rr_v = _mm256_div_pd(_mm256_set1_pd(1.0), _mm256_sqrt_pd(rr_v));
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



