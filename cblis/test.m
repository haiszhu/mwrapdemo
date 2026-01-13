% Test script for BLIS dgemm MWrap demo in cblis.
% Before using, from this directory run:
%   make -f makefile.nomex

A = rand(100,200);
B = rand(200,300);

% Call the MWrap-generated MATLAB wrapper which uses BLIS dgemm underneath.
C = cblis_dgemm(A,B);

% Check correctness vs MATLAB's built-in matrix multiply
err = max(max(abs(C - A*B)));
fprintf('cblis dgemm max abs error: %.3g\n', err);
