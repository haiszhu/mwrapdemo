% start kernel experiments 101
% make -f makefile_expts
% 07/15/24 Hai

% rm -f *.o
% gcc -mavx2 -c -o ckernels_expts.o ckernels_expts.c
% gfortran -c -o kernels_expts.o kernels_expts.f
% gfortran -c -o test_lap3d.o test_lap3d.f
% gfortran -o test_lap3d test_lap3d.o kernels_expts.o ckernels_expts.o -lm
% ./test_lap3d
% 
% rm -f *.o
% gcc -mavx512f -c -o ckernels_expts.o ckernels_expts.c
% gfortran -c -o kernels_expts.o kernels_expts.f
% gfortran -c -o test_lap3d.o test_lap3d.f
% gfortran -o test_lap3d test_lap3d.o kernels_expts.o ckernels_expts.o -lm
% ./test_lap3d

m = 5;
r0 = reshape([1.1, 2.2, 3.3, 4.4, 5.5, 6.6, 7.7, 8.8, 9.9, ...
              10.1, 11.1, 12.2, 13.3, 14.4, 15.5], 3,m);
r0x = r0(1,:);
r0y = r0(2,:);
r0z = r0(3,:);

n = 7;
r = reshape([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0,...
            9.0, 10.0, 11.0, 12.0, 13.0 14.0 15.0, ...
            16.0 17.0 18.0 19.0 20.0 21.0], 3,n);
rx = r(1,:);
ry = r(2,:);
rz = r(3,:);

A = zeros(m,n);
for k = 1:n
  for j = 1:m
      dx = r0x(j) - rx(k);
      dy = r0y(j) - ry(k);
      dz = r0z(j) - rz(k);
      rr = dx*dx + dy*dy + dz*dz;
      A(j,k) = 1.0/sqrt(rr);
  end
end

% c
A2 = zeros(m,n);
A2=clap3ddlpmat_mex(m,r0,n,r,A2);

% c avx2
A3 = zeros(m,n);
A3=cavx2lap3ddlpmat_mex(m,r0,n,r,A3);

% diff = abs(A - A2)
diff2 = abs(A - A3)

m = 8001;
r0 = rand(3,m);
n = 10000;
r = rand(3,n);
A2 = zeros(m,n);
tic
A2=clap3ddlpmat_mex(m,r0,n,r,A2);
toc
A3 = zeros(m,n);
tic
A3=cavx2lap3ddlpmat_mex(m,r0,n,r,A3);
toc

keyboard