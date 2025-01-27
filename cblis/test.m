% /Applications/MATLAB_R2023b.app/bin/mex -v CFLAGS="\$CFLAGS -std=c99" demo.c -L/opt/homebrew/Cellar/blis/1.1/lib/ -lblis -I/opt/homebrew/Cellar/blis/1.1/include/ 
%

A = rand(10,20);
B = rand(20,30);
C = zeros(10,30); 
C = demo(A, B, C);
max(max(abs(C - A*B)))