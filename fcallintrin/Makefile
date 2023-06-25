# the style of this makefile is not consistent with makefiles in other subfolders
#

include ../make.inc

all : libkernels.a kernels_fast.o int2-test gateway.c mexfile

libkernels.a : 
	g++ -fPIC -Ofast -fopenmp -march=native -Wall -std=c++11  -DSCTL_PROFILE=-1  -I./SCTL/include -I./ -c ./libkernels.cpp -o ./libkernels.o
	ar cru ./libkernels.a ./libkernels.o
	ranlib ./libkernels.a 

kernels_fast.o: 
	gfortran -fPIC -Ofast -fopenmp -march=native -Wall -c kernels_fast.f

int2-test: 
	gfortran -fPIC -fopenmp -Ofast -march=native -Wall -I./SCTL/include test-fortran.f90 kernels_fast.o libkernels.a -L./ -lkernels -lstdc++ -o ./int2-test

gateway.c: 
	~/mwrap/mwrap -c99complex -mex gateway -mb -list demo.mw
	~/mwrap/mwrap -c99complex -mex gateway -c gateway.c demo.mw

mexfile: 
	$(MEX) gateway.c kernels_fast.o ./libkernels.a -largeArrayDims $(MFLAGS) -lgfortran -lm -lstdc++ -lgomp

