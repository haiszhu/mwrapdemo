#ifdef __cplusplus
extern "C" {
    void testdot_c_( int *N, double *vec1, double *vec2, double *dot);
    }
#endif

void testdot_c_(  int *N, double *vec1, double *vec2, double *dot) 
{
    int i;

    for (i=0; i<*N; i++) { 
      *dot = *dot + *(vec1+i) * *(vec2+i);
    }
}

