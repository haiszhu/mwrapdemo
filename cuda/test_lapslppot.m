function test_lapslppot()
%TEST_LAPSLLPPOT Regression + timing for lapslppot GPU MEX (baseline + unroll).
%
% Assumes utils_cu.mexa64 is on the MATLAB path.

THRESH = 1e-15;

% Larger problem to make timing meaningful (still fits in GPU mem).
N = 40000;
M = 20000;

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
gy_reduce = lapslppot_reduce_wrap(gsrc, gtarg, gx);
y_gpu_reduce = gather(gy_reduce);

% CPU reference
tic;
src_exp  = reshape(src, 3, N, 1);
targ_exp = reshape(targ, 3, 1, M);
diff     = src_exp - targ_exp;               % 3 x N x M
dd       = squeeze(sum(diff.^2, 1));         % N x M
mask     = dd > THRESH^2;
dd_sqrt  = sqrt(dd);
dd_sqrt(~mask) = inf;                        % avoid divide-by-zero
y_cpu = sum((x ./ dd_sqrt) .* mask, 1).';    % M x 1
cpu_time = toc;

err = norm(y_cpu - y_gpu) / max(1, norm(y_cpu));

fprintf('Relative error: %.3e (tol=1e-10)\n', err);
if err < 1e-10
    disp('PASS: lapslppot_wrap matches CPU reference.');
else
    error('FAIL: lapslppot_wrap mismatch.');
end

err_reduce = norm(y_cpu - y_gpu_reduce) / max(1, norm(y_cpu));
fprintf('Reduce relative error: %.3e (tol=1e-10)\n', err_reduce);
if err_reduce < 1e-10
    disp('PASS: lapslppot_reduce_wrap matches CPU reference.');
else
    error('FAIL: lapslppot_reduce_wrap mismatch.');
end

% Timing (gputimeit includes only GPU time)
f_base   = @() lapslppot_wrap(gsrc, gtarg, gx);
f_reduce = @() lapslppot_reduce_wrap(gsrc, gtarg, gx);
% Warm up once to JIT kernels
f_base(); f_reduce();
t_base   = gputimeit(f_base);
t_reduce = gputimeit(f_reduce);
fprintf('Timing (N=%d, M=%d): cpu=%.4f s, base=%.4f s, reduce=%.4f s\n', N, M, cpu_time, t_base, t_reduce);
end
