function out = MonteCarloFast(distFn,N,varargin)
% out = MonteCarloFast(distFn, N, varargin)
% Function for generating **IID** realizations of a random variable with
% density function specified by distFn. This function is **not** capable of
% generating correlated random variables. Faster, similar implementation  
% of sim.iid.MonteCarloSim(), which was done to demonstrate knowledge of
% the method for ATOC 5235.
% 
% Inputs:
%       distFn: A structure with fields
%               x: x coordinates of the distribution function.
%               y: y coordinates of the distribution function.
%       N: The number of random variables to simulate
%       varargin{1}: flag 'pdf' or 'cdf' for the type of distribution
%       function input. Default is 'cdf'
% Outputs:
%       out: Struct with fields
%           result: 1xN vector containing simulated RVs with the desired
%           distribution function
%       
% SEE ALSO:
%   sim.iid.MonteCarloSim()

out.result = zeros( 1, N );
if isempty(varargin{1})
    distFlag = 'cdf';
else
    distFlag = varargin{1};
end
switch distFlag %Making sure we have a CDF
    case 'pdf'
        denom = trapz( distFn.x, distFn.y ) ;
        cdf = cumtrapz(distFn.x,distFn.y)/denom;
    case 'cdf'
        cdf = distFn.y/distFn.y(end);
end

newDist = makedist('PieceWiselinear','x',distFn.x, 'Fx', cdf); 
out.result = random(newDist, 1, N);

out.errCode = 0;
end

