function mydgesvtest()
% 
A = [3, 1, 3;...
     1, 5, 9;...
     2, 6, 5]; % inout
B = [-1 1; 3 -3; -3 3];  % inout as rhs and unknown x, size(B) = LDB,NRHS
sol = A\B; % to verify soln
[sol2,dcond,info]=dgausselimvec_mex(A,B);
err = max(abs(sol2 - sol))
end

