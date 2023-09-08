subroutine dgausselimvec(n, a, k, rhs, info, sol, dcond)
  implicit double precision (a-h,o-z)
  double precision :: a(n,n), rhs(n,k), sol(n,k)
  
  integer *8, allocatable :: ipiv(:), iwork(:)
  double precision, allocatable :: af(:,:), rscales(:), cscales(:), work(:)
  integer *8 n1,lda,ldaf,nrhs,ldb,ldx,info1
  character *1 :: fact, trans, equed
  !
  ! This a wrapper for double precision Gaussian elimination in
  ! LAPACK for multipole right hand sides
  ! 
  !
  
  allocate(ipiv(n))
  allocate(af(n,n))
  allocate(rscales(n))
  allocate(cscales(n))
  allocate(work(5*n))
  allocate(iwork(n))
  
  fact = 'N'
  trans = 'N'
  nrhs = k
  lda = n
  ldaf = n
  equed = 'N'
  ldb = n
  ldx = n
  n1 = n
  
  
  call dgesvx( fact, trans, n1, nrhs, a, lda, af, ldaf, ipiv, &
      equed, rscales, cscales, rhs, ldb, sol, ldx, dcond, ferr, berr, &
      work, iwork, info1 )

  dcond = 1.0d0/dcond
  info = info1
  
  return
end subroutine dgausselimvec