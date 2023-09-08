# mwrapdemo makefile for interfacing to a Fortran library
# Barnett 7/30/15
include ../make.inc

# This is the task run if "make" is done with no arguments ("mexfile" is not
# a file, just a name for a compilation task given below):
default: lapack_wrap_64.o mexfile

# How to compile your library function: (-fPIC is needed for linking to MEX)
dgesv.o: dgesv.f makefile
	$(FC) -fPIC $(FFLAGS) -c dgesv.f -L. -llapack
lapack_wrap_64.o: lapack_wrap_64.f90 makefile
	$(FC) -fPIC $(FFLAGS) -c lapack_wrap_64.f90 -L. -llapack

# Tell mwrap to make the interface and the name of the final MEX file:
# Note: -c99complex assumes usual Fortran complex numbers (see MWrap docs)
gateway.c: demo.mw makefile
	$(MWRAP) -c99complex -mex gateway -mb -list demo.mw
	$(MWRAP) -c99complex -mex gateway -c gateway.c demo.mw

# How to make MATLAB/MEX compile the interface (whatever libs needed):
mexfile: gateway.c lapack_wrap_64.o makefile
	$(MEX) gateway.c lapack_wrap_64.o -largeArrayDims $(MFLAGS) -lgfortran -lm -llapack

# Remove the MEX interface, MATLAB caller, and MEX file:
clean:
	rm -f myfunc.m gateway.c *.o *.mex* *~
