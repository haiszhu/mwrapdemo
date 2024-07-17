
      subroutine clap3ddlpmat(n,r0,m,r,A)
      implicit none
      integer *8, intent(in) :: n, m
      real    *8, intent(in) :: r0(*), r(*)
      real    *8, intent(inout) :: A(*)
      call clap3ddlpmat_c(n,r0,m,r,A)  
      end subroutine clap3ddlpmat

      subroutine caneonlap3ddlpmat(n,r0,m,r,A)
      implicit none
      integer *8, intent(in) :: n, m
      real    *8, intent(in) :: r0(*), r(*)
      real    *8, intent(inout) :: A(*)
      call caneonlap3ddlpmat_c(n,r0,m,r,A)  
      end subroutine caneonlap3ddlpmat