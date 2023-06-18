#ifdef __cplusplus
extern "C" {
    void testret_c_( double *mat);
    }
#endif

void testret_c_( double *mat ) 
{
    *mat = *mat + 1;
}

