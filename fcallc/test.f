      program test

      integer veclen 
      real*8 mat, dot
      real*8 vec1(2), vec2(2)
      real*8 matrix3(3,2)
      real*8 :: matrix1(3,3) = reshape((/1,2,3,4,5,6,7,8,9/), (/3,3/))
      real*8 :: matrix2(3,2) = reshape((/1,2,3,4,5,6/),(/3,2/))

      veclen = 2
      matdim1 = 3
      matdim2 = 2
 
      vec1(1) = 1.0
      vec1(2) = 2.0
      vec2(1) = 3.0
      vec2(2) = 4.0 


      mat = 0.0
      dot = 0.0

* mat should get incremented by 1 in testret 
      do 10 i = 1, 10
         call testret(mat)
10    continue

* testdot should return the dot product of vec1 and vec2 as a real
      call testdot(veclen, vec1, vec2, dot)

* testmat uses matrix1 and matrix2 to calculate matrix3
      call testmat(matdim1, matdim2, matrix1, matrix2, matrix3)

      print *, mat, '  ', dot
      do 20 i = 1, matdim1
        write (6,*) (matrix3(i,j), j=1,matdim2)
20    continue


      end
