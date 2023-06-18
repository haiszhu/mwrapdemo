#ifdef __cplusplus
extern "C" {
    void testmat_c_( int *N, int *M, double *mat1, double *mat2, double *mat3);
    }
#endif

#include <stdio.h>
void testmat_c_(  int *N, int *M, double *mat1, double *mat2, double *mat3 )
{
    int i,j,k;
    double dot;

    // Assign stuff to mat3 from mat1 and mat2
    for (i=0; i<*N; i++) { 
      for (j=0; j<*M; j++) {
         dot = 0.0;
         for (k=0; k<*N; k++ ) {
           dot = dot + *(mat1+(*N*k+i)) * *(mat2+(*N*j+k));
           printf("%f\n", *(mat2+(*N*j+k)));
         }
         *(mat3+(*N*j+i)) = dot;
       }
    }

}

