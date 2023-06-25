# the style of this makefile is not consistent with makefiles in other subfolders
#

all : libkernels.a kernels_fast.o int2-test gateway.c

libkernels.a : makefile
	g++ -fPIC -Ofast -fopenmp -march=native -Wall -std=c++11  -DSCTL_PROFILE=-1  -I./SCTL/include -I./ -c ./libkernels.cpp -o ./SCTL/obj/libkernels.o
	ar cru ./libkernels.a ./SCTL/obj/libkernels.o
	ranlib ./libkernels.a 

kernels_fast.o: makefile
	gfortran -fPIC -Ofast -fopenmp -march=native -Wall -c kernels_fast.f

int2-test: makefile
	gfortran -fPIC -fopenmp -Ofast -march=native -Wall -I./SCTL/include test-fortran.f90 kernels_fast.o libkernels.a -L./ -lkernels -lstdc++ -o ./int2-test

gateway.c: makefile
	~/mwrap/mwrap -c99complex -mex gateway -mb -list demo.mw
	~/mwrap/mwrap -c99complex -mex gateway -c gateway.c demo.mw

