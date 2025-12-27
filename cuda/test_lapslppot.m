function test_lapslppot()
%TEST_LAPSLLPPOT Basic regression test for lapslppot_wrap GPU MEX.
%
% Assumes lapslppot_wrap.mexa64 is on the MATLAB path.

THRESH = 1e-15;

% Small problem so the CPU reference is quick.
N = 6400;
M = 3200;

src  = rand(3, N);
targ = rand(3, M);
x    = rand(N, 1);

% GPU inputs
gsrc  = gpuArray(src);
gtarg = gpuArray(targ);
gx    = gpuArray(x);

% Call GPU MEX (via MATLAB wrapper)
gy = lapslppot_wrap(gsrc, gtarg, gx);
y_gpu = gather(gy);

% CPU reference
src_exp  = reshape(src, 3, N, 1);
targ_exp = reshape(targ, 3, 1, M);
diff     = src_exp - targ_exp;               % 3 x N x M
dd       = squeeze(sum(diff.^2, 1));         % N x M
mask     = dd > THRESH^2;
dd_sqrt  = sqrt(dd);
dd_sqrt(~mask) = inf;                        % avoid divide-by-zero
y_cpu = sum((x ./ dd_sqrt) .* mask, 1).';    % M x 1

err = norm(y_cpu - y_gpu) / max(1, norm(y_cpu));

fprintf('Relative error: %.3e (tol=1e-10)\n', err);
if err < 1e-10
    disp('PASS: lapslppot_wrap matches CPU reference.');
else
    error('FAIL: lapslppot_wrap mismatch.');
end
end
