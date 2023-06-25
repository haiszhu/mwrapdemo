function pot=h3ddirectcpnew(nd, zk, sources, charge, ns, ztarg, nt, thresh)

pot = complex(zeros(nd,nt));
mex_id_ = 'h3ddirectcpnew(i int[x], i dcomplex[x], i double[xx], i dcomplex[xx], i int[x], i double[xx], i int[x], io dcomplex[xx], i double[x])';
[pot] = gateway(mex_id_, nd, zk, sources, charge, ns, ztarg, nt, pot, thresh, 1, 1, 3, ns, nd, ns, 1, 3, nt, 1, nd, nt, 1);
