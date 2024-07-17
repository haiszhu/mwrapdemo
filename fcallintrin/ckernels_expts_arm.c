#ifdef __cplusplus
extern "C" {
  void clap3ddlpmat_c_( int64_t *M, double *r0, int64_t *N, double *r, double *A);
  void caneonlap3ddlpmat_c_(int64_t *M, double *r0, int64_t *N, double *r, double *A);
}
#endif

#include <arm_neon.h>
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

void caneonlap3ddlpmat_c_(int64_t *M, double *r0, int64_t *N, double *r, double *A) 
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
