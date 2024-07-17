      ! fortran call c... 
      ! to vectorize kernel, compute fsqrt?
      ! 07/15/24 Hai
      subroutine clap3ddlpmat(n,r0,m,r,A)
      implicit none
      integer *8, intent(in) :: n, m
      real    *8, intent(in) :: r0(*), r(*)
      real    *8, intent(inout) :: A(*)
      call clap3ddlpmat_c(n,r0,m,r,A)  
      end subroutine clap3ddlpmat

      subroutine csimd128lap3ddlpmat(n,r0,m,r,A)
      implicit none
      integer *8, intent(in) :: n, m
      real    *8, intent(in) :: r0(*), r(*)
      real    *8, intent(inout) :: A(*)
      call csimd128lap3ddlpmat_c(n,r0,m,r,A)  
      end subroutine csimd128lap3ddlpmat

      subroutine csimd256lap3ddlpmat(n,r0,m,r,A)
      implicit none
      integer *8, intent(in) :: n, m
      real    *8, intent(in) :: r0(*), r(*)
      real    *8, intent(inout) :: A(*)
      call csimd256lap3ddlpmat_c(n,r0,m,r,A)  
      end subroutine csimd256lap3ddlpmat

      subroutine csimd512lap3ddlpmat(n,r0,m,r,A)
      implicit none
      integer *8, intent(in) :: n, m
      real    *8, intent(in) :: r0(*), r(*)
      real    *8, intent(inout) :: A(*)
      call csimd512lap3ddlpmat_c(n,r0,m,r,A)  
      end subroutine csimd512lap3ddlpmat

      ! subroutine lap3ddlpmat(n,r0,m,r,A)
      ! implicit none
      ! integer *8, intent(in) :: n, m
      ! real    *8, intent(in) :: r0(3,n), r(3,m)
      ! real    *8, intent(inout) :: A(n,m)
      ! A(1,1) = 0.0d0
      ! end subroutine lap3ddlpmat