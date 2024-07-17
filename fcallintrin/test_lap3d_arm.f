! rm -f *.o
! gcc-14 -O3 -Wall -march=armv8-a -DARCH_ARM -c ckernels_expts_arm.c 
! gfortran -O3 -c kernels_expts_arm.o kernels_expts_arm.f 
! gfortran -c -o test_lap3d_arm.o test_lap3d_arm.f
! gfortran -o test_lap3d_arm test_lap3d_arm.o kernels_expts_arm.o ckernels_expts_arm.o -lm
! ./test_lap3d_arm
      
      program test_lap3d_arm
      implicit none
      integer *8 :: m, n, nd
      ! real *8, allocatable :: r0(:,:), r(:,:), A(:,:)
      real *8, allocatable :: r0(:), r(:), A(:), A2(:), A3(:)
      real *8, allocatable :: r0l(:), rl(:), Al(:), A2l(:), A3l(:)
      real *8 :: start, finish
    
      ! Initialize dimensions
      m = 3
      m = 8
      ! m = 4
      ! n = 5
      n = 4
      nd = 3
    
      ! Allocate arrays
      allocate(r0(3*m), r(3*n), A(m*n), A2(m*n), A3(m*n))
    
      ! Initialize input data
      r0 = [1.1, 2.2, 3.3, 4.4, 5.5, 6.6, 7.7, 8.8, 9.9, 
     1      10.1, 11.1, 12.2, 13.3, 14.4, 15.5,
     2      16.6, 17.7, 18.8, 19.9, 20.0, 21.1]
    !   r0 = [1.1, 2.2, 3.3, 4.4, 5.5, 6.6, 7.7, 8.8, 9.9, 
    !  1      10.1, 11.1, 12.2]
      ! r0 = [1.1, 2.2, 3.3, 4.4, 5.5, 6.6, 7.7, 8.8, 9.9]
    !   r = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 
    !  1      10.0, 11.0, 12.0, 13.0, 14.0, 15.0]
      r = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 
     1      10.0, 11.0, 12.0]
    
      ! Call the original C function
      A = 1.0d0
      call clap3ddlpmat(m, r0, n, r, A)
      print *, "Results from clap3ddlpmat:"
      call print_matrix(m*n, A)
    
      ! Call the SIMD C function
      A2 = 2.0d0
      call caneonlap3ddlpmat(m, r0, n, r, A2)
      print *, "Results from caneonlap3ddlpmat:"
      call print_matrix(m*n, A2)

      ! A3 = A2 - A
      ! call print_matrix(m*n, A3)

      ! ! Call the SIMD C function
      ! call cavx512lap3ddlpmat(m, r0, n, r, A3)
      ! print *, "Results from cavx512lap3ddlpmat:"
      ! call print_matrix(m*n, A3)
    
      ! Deallocate arrays
      deallocate(r0, r, A, A2, A3)

      ! Initialize dimensions
      m = 8001
      n = 10000
      nd = 3
    
      ! Allocate arrays
      allocate(r0l(3*m), rl(3*n), Al(m*n), A2l(m*n), A3l(m*n))
      r0l = 1.0d0
      rl = 2.0d0

      ! Call the pure C function
      call cpu_time(start)
      call clap3ddlpmat(m, r0l, n, rl, Al)
      call cpu_time(finish)
      print '("Time for clap3ddlpmat = ",f6.3," seconds.")',
     1        finish-start

      ! Call the SIMD C function
      call cpu_time(start)
      call caneonlap3ddlpmat(m, r0l, n, rl, A2l)
      call cpu_time(finish)
      print '("Time for caneonlap3ddlpmat = ",f6.3," seconds.")',
     1        finish-start

    !   ! Call the SIMD C function
    !   call cpu_time(start)
    !   call cavx512lap3ddlpmat(m, r0l, n, rl, A3l)
    !   call cpu_time(finish)
    !   print '("Time for cavx512lap3ddlpmat = ",f6.3," seconds.")',
    !  1        finish-start

      deallocate(r0l,rl,Al,A2l,A3l)
      
      contains
    
      subroutine print_matrix(mn, A)
        integer *8, intent(in) :: mn
        real *8, intent(in) :: A(mn)
        integer *8 :: i, j
        do i = 1, mn
          print *, "A(", i, ") = ", A(i)
        end do
      end subroutine print_matrix
    
      end program test_lap3d_arm
    