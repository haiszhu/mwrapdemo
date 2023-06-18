c     fortran call c... 06/18/23 Hai
c
      subroutine testdot(n,vec1,vec2,dot)
c
*/
        implicit none
        integer *4, intent(in) :: n
        real    *8, intent(in) :: vec1(*), vec2(*)
        real    *8, intent(inout) :: dot
      
        call testdot_c(n,vec1,vec2,dot)

      end subroutine testdot

c
      subroutine testret(mat)
c
*/    
        implicit none
        real    *8, intent(in) :: mat

        call testret_c(mat)

			end subroutine testret

c
      subroutine testmat(n,m,mat1,mat2,mat3)
c
*/    
        implicit none
        integer *4, intent(in) :: n, m
        real    *8, intent(in) :: mat1, mat2, mat3

        call testmat_c(n,m,mat1,mat2,mat3)
				
			end subroutine testmat