function B = dgesv_mex(A,B)

[LDA,N] = size(A);
[LDB,NRHS] = size(B);
mex_id_ = 'DGESV(i int[x], i int[x], io double[xx], i int[x], o int[x], io double[xx], i int[x], o int[x])';
[A, IPIV, B, INFO] = gateway(mex_id_, N, NRHS, A, LDA, B, LDB, 1, 1, LDA, N, 1, N, LDB, NRHS, 1, 1);

end