#include "mex.h"
#include "cblas.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    
    double *A = mxGetPr(prhs[0]); 
    double *B = mxGetPr(prhs[1]); 
    double *C = mxGetPr(prhs[2]); 
    
    mwSize m = mxGetM(prhs[0]); 
    mwSize k = mxGetN(prhs[0]);
    mwSize n = mxGetN(prhs[1]);

    double alpha = 1.0, beta = 1.0;

    cblas_dgemm(CblasColMajor, CblasNoTrans, CblasNoTrans, 
                m, n, k, alpha, A, m, B, k, beta, C, m);

    plhs[0] = mxDuplicateArray(prhs[2]);
}
