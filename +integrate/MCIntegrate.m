function out = MCIntegrate( fx, xbds, ybds , nPts)
% out = MCIntegrate(fx, xbds, ybds )
% Function for integrating arbitrary functions given by the function handle
% fx. The code will draw a rectangle with size given by xbds and ybds, then
% uniformly sample points in that rectangle. The integral is approximated
% by the ratio of points under the curve to over. Currently only
% implemented for nonnegative functions.
% 
% Inputs:
%       fx: Function handle for the function to integrate
%       xbds: The bounds on x over which to integrate. Must be finite.
%       ybds: The y bounds on the rectangle to simulate random points
%       within. For now the lower limit ought to be zero.
%       varargin{1}: flag 'pdf' or 'cdf' for the type of distribution
%       function input. Default is 'cdf'
% Outputs:
%       out: Struct with fields
%           result: Approximate value of the integral
%       
% SEE ALSO:
xbds=sort(xbds);ybds=sort(ybds); %Checking bounds are in the correct order
if any(isnan(xbds))||any(isnan(ybds))
   error('region must be finite!') 
end
if any(ybds<0)
    error('Only positive y values are allowed at this time')
end

area = diff(xbds)*diff(ybds);%Are of entire rectangle to simulate over

pts = rand(2,nPts); %Random numbers on [0,1]^2
xVals = pts(1,:)*diff(xbds)+xbds(1);%Moving to the rectangle of interest
yVals = pts(2,:)*diff(ybds)+ybds(1);

fXvals = fx(xVals);

ratio = nnz(fXvals>=yVals)/nPts;

out.result = ratio*area;
end