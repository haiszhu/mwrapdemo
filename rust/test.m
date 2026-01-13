% minimal test for rust_sin
%
% run `make -f makefile.nomex` first

x = linspace(0, 2*pi, 10).';
y = rust_sin(x);

fprintf('max error: %g\n', max(abs(y - sin(x))));
