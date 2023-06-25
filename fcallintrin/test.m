clear srcinfo

ns = 4000;
rng(2)
srcinfo.sources = rand(3,ns);
srcinfo.charges = rand(1,ns)+1i*rand(1,ns);

nt = 3999;
rng(3)
targ = rand(3,nt);  

eps = 1e-5;
ntests = 36;
ipass = zeros(ntests,1);
errs = zeros(ntests,1);
zk = complex(1.1);
ntest = 10;

stmp = srcinfo.sources(:,1:ntest);
ttmp = targ(:,1:ntest);

%
nd = 1;
zk;
sources = srcinfo.sources;
charge = srcinfo.charges;
ns;
ztarg = ttmp;
nt = numel(ztarg(1,:));
thresh = 1e-12;

pot=h3ddirectcpnew(nd, zk, sources, charge, ns, ztarg, nt, thresh);
