function [sol,dcond,info]=dgausselimvec_mex(a,rhs)

n = size(a,1);
k = size(rhs,2);
mex_id_ = 'dgausselimvec(i int[x], io double[xx], i int[x], io double[xx], o int[x], o double[xx], o double[x])';
[a, rhs, info, sol, dcond] = gateway(mex_id_, n, a, k, rhs, 1, n, n, 1, n, k, 1, n, k, 1);

end