CC = gcc 
FC = gfortran 
# Make sure the CC and FC compilers were built with the same glibc library
# g77 will work fine on most systems
CFLAGS = -Wall 

OBJS = testdot.o testret.o testmat.o 

all: lib int2-test
# all: test lib 

int2-test : test.o testall.o $(OBJS) 
	$(FC) -o int2-test test.o testall.o $(OBJS) libtest.a -L./ -ltest -lstdc++

testret.o : testret.c   
	$(CC) $(CFLAGS) -c testret.c  

testdot.o : testdot.c   
	$(CC) $(CFLAGS) -c testdot.c  

testmat.o : testmat.c   
	$(CC) $(CFLAGS) -c testmat.c  

testall.o : testall.f 
	$(FC) -c testall.f 

test.o : test.f   
	$(FC) -c test.f  

# Default Targets for Cleaning up the Environment
clean :
	rm int2*  
	rm *.o
	rm *.a

pristine :
	rm *.o
	rm *.a
	touch *.cc 

ctags :
	ctags *.cc

# Target for making the library

lib: $(OBJS)
	ar -rc libtest.a $(OBJS) 
	ranlib libtest.a
