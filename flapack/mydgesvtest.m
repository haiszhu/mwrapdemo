function mydgesvtest()
% 
A = [3, 1, 3;...
     1, 5, 9;...
     2, 6, 5]; % inout
B = [-1; 3; -3]; % inout as rhs and unknown x, size(B) = LDB,NRHS
soln = A\B; % to verify soln
soln2 = dgesv_mex(A,B); 
err = max(abs(soln2 - soln))
end

