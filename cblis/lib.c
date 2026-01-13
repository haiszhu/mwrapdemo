#include "cblas.h"

void mydgemm(int m, int n, int k,
             const double *A,
             const double *B,
             double *C)
{
    const double alpha = 1.0;
    const double beta  = 0.0;

    /* Column-major dgemm: C = alpha*A*B + beta*C */
    cblas_dgemm(CblasColMajor, CblasNoTrans, CblasNoTrans,
                m, n, k,
                alpha,
                A, m,
                B, k,
                beta,
                C, m);
}

