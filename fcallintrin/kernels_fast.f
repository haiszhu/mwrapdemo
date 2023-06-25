c     fortran call Dhairya's SCTL c++ intrinsics: https://github.com/dmalhotra/SCTL
c     06/24/23 Hai
c
c     for some reason, intent(out) only randomly returns correct value?
c     use intent(inout) for pot instead to get consistent answer... makefile issue?
c     double check...
c
c     avoid underscore in fortran fun name... see mwrap, mwrap-cgen.cc, mex_define_f2c_fname
c
c     see https://www.intel.com/content/www/us/en/docs/intrinsics-guide/index.html for descriptions of these intrinsics
c
c     matlab crashes on both linux and mac due to jvm (java virtual machine) issue?
c     on mac: /Applications/MATLAB_R2021b.app/bin/matlab -nodesktop -nosplash -nojvm; test
c     on linux: 			
c
      subroutine h3ddirectcpnew(nd, zk, sources, charge, ns, ztarg, 
     1           nt, pot, thresh)
c
*/
      implicit none
      integer *4, intent(in)    :: nd
      complex*16, intent(in)    :: zk
      real    *8, intent(in)    :: sources(*)
      complex*16, intent(in)    :: charge(*)
      integer *4, intent(in)    :: ns
      real    *8, intent(in)    :: ztarg(*)
      integer *4, intent(in)    :: nt
      complex*16, intent(inout) :: pot(*)
      real    *8, intent(in)    :: thresh
      
      call h3ddirectcp_new_cpp(nd, zk, sources, charge, ns, ztarg, nt, 
     1           pot, thresh)
      
      end subroutine h3ddirectcpnew
