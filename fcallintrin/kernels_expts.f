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

      subroutine cavx2lap3ddlpmat(n,r0,m,r,A)
      implicit none
      integer *8, intent(in) :: n, m
      real    *8, intent(in) :: r0(*), r(*)
      real    *8, intent(inout) :: A(*)
      call cavx2lap3ddlpmat_c(n,r0,m,r,A)  
      end subroutine cavx2lap3ddlpmat