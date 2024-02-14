function out = MonteCarloSim(distFn,N,varargin)
% out = MonteCarloSim(distFn, N, varargin)
% Function for generating **IID** realizations of a random variable with
% density function specified by distFn. This function is **not** capable of
% generating correlated random variables. Done this way to demonstrate
% knowledge of method. Faster, similar implementation that uses the 
% statistics/ML toolbox is done in sim.iid.MonteCarloFast()
% 
% Inputs:
%       distFn: A structure with fields
%               fn: Function handle: The distribution function from which to sample. Can be
%               either a PDF (default) or a CDF. Should take in a value of
%               x and return the value of the distribution function at x.
%               xlims: The smallest interval outside which the PDF is
%               identically zero, the bounds of the random variable.
%       N: The number of random variables to simulate
%       varargin{1}: flag 'pdf' or 'cdf' for the type of distribution
%       function input. 
% Outputs:
%       out: Struct with fields
%           result: 1xN vector containing simulated RVs with the desired
%           distribution function
%       
% SEE ALSO:
%   sim.iid.MonteCarloFast()
xiUnif = rand(1, N);% Uniformly distributed random variables

out.result = zeros( 1, N );
if isempty(varargin{1})
    distFlag = 'cdf';
else
    distFlag = varargin{1};
end
switch distFlag
    case 'pdf'
        denom = integral( distFn.fn, distFn.xlims(1),distFn.xlims(2) );
        cdf = @(x)(integral(distFn.fn, distFn.xlims(1), x)/denom);
    case 'cdf'
        cdf = distFn.fn;
end
for ii=1:N
    out.result(ii) = fzero( @(x)cdf(x)-xiUnif(ii),0.5 );
end


out.errCode = 0';
end

