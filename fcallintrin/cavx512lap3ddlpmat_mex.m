function A=cavx512lap3ddlpmat_mex(n,r0,m,r,A)
n3 = n*3;
m3 = m*3;
nm = n*m;
r0 = r0(:); r = r(:); A = A(:);
mex_id_ = 'cavx512lap3ddlpmat(i int64_t[x], i double[x], i int64_t[x], i double[x], io double[x])';
[A] = gateway_expts(mex_id_, n, r0, m, r, A, 1, n3, 1, m3, nm);
A = reshape(A,n,m);
end
