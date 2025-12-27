function y = lapslppot_wrap(src, targ, x)

  % Basic size checks in MATLAB (mwrap does type checking, not shape logic)
  if size(src,1) ~= 3
    error('src must be 3xN (gpuArray double).');
  end
  if size(targ,1) ~= 3
    error('targ must be 3xM (gpuArray double).');
  end
  if numel(x) ~= size(src,2)
    error('x must have length N matching src.');
  end

  N = double(size(src,2));
  M = double(size(targ,2));

  % Allocate output on GPU (length M)
  y = gpuArray.zeros(M,1,'double');

  % Call the CUDA entry point in lapslppot.cu
  mex_id_ = 'c o int = lapslppot(g i double[], g i double[], g i double[], g io double[], c i int, c i int)';
[ier, y] = utils_cu(mex_id_, src, targ, x, y, N, M);

  if ier ~= 0
    error('lapslppot failed: ier=%d', ier);
  end

end
