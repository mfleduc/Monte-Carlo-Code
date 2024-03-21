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
%       function input, or the name of a distribution natively available in MATLAB.
%       Default is 'cdf'.
%       If you name a distribution, the next arguments to varargin must be
%       the necessary parameters to simulate the random variable. See the
%       MATLAB documentation for details. To use this, pass in
%       struct.empty() for distFn, or whatever you want, it'll get ignored
%       anyway
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
        cdf(end)=1; 
        newDist = makedist('PieceWiselinear','x',distFn.x, 'Fx', cdf); 
        out.result = random(newDist, 1, N);

        out.errCode = 0';
    case 'cdf'
        cdf = distFn.y/distFn.y(end);
        newDist = makedist('PieceWiselinear','x',distFn.x, 'Fx', cdf); 
        out.result = random(newDist, 1, N);

        out.errCode = 0';
    otherwise %Let the user pass in MATLAB specific stuff if they want to
        evalStr = 'random(varargin{1}';
        for kk = 2:length(varargin)
            evalStr = [evalStr,sprintf(',varargin{%d}',kk)] ;
        end
        evalStr = [evalStr,',[1,N]);'];
        out.result = eval(evalStr);
       
end


end

