      program test_lap3d
      implicit none
      integer *8 :: m, n, nd
      ! real *8, allocatable :: r0(:,:), r(:,:), A(:,:)
      real *8, allocatable :: r0(:), r(:), A(:), A2(:), A3(:)
    
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
      call clap3ddlpmat(m, r0, n, r, A)
      print *, "Results from clap3ddlpmat:"
      call print_matrix(m*n, A)
    
      ! Call the SIMD C function
      call cavx2lap3ddlpmat(m, r0, n, r, A2)
      print *, "Results from cavx2lap3ddlpmat:"
      call print_matrix(m*n, A2)

      ! Call the SIMD C function
      call cavx512lap3ddlpmat(m, r0, n, r, A3)
      print *, "Results from cavx512lap3ddlpmat:"
      call print_matrix(m*n, A3)
    
      ! Deallocate arrays
      deallocate(r0, r, A, A2, A3)
      
      contains
    
      subroutine print_matrix(mn, A)
        integer *8, intent(in) :: mn
        real *8, intent(in) :: A(mn)
        integer *8 :: i, j
        do i = 1, mn
          print *, "A(", i, ") = ", A(i)
        end do
      end subroutine print_matrix
    
      end program test_lap3d
    