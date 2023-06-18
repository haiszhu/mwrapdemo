% test fortran call c

matrix1 = [[1,2,3]'  [4,5,6]'  [7,8,9]'];
matrix2 = [[1,2,3]'  [4,5,6]'];

veclen = 2;
matdim1 = 3;
matdim2 = 2;
 
vec1 = [1.0, 2.0];
vec2 = [3.0, 4.0];

mat = 0.0;
dot = 0.0;

for i = 1:10
   mat = testret(mat)
end

testdot(veclen, vec1, vec2, dot)

matrix3 = zeros(matdim1,matdim2);
testmat(matdim1, matdim2, matrix1, matrix2, matrix3)