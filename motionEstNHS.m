function  [motionVect, NHScomputations] = motionEstNHS(imgP, imgI, mbSize, p)
[row col] = size(imgI);
vectors = zeros(2,row*col/mbSize^2);
costs = ones(1, 5) * 65537; 
% Small Cross Shaped pattern
SCSP(1,:) = [ 0 -1];
SCSP(2,:) = [-1 0];
SCSP(3,:) = [ 0 0];
SCSP(4,:) = [ 1 0];
SCSP(5,:) = [ 0 1];

checkMatrix = zeros(2*p+1,2*p+1);
computations = 0;
mbCount = 1;
for i = 1 : mbSize : row-mbSize+1
for j = 1 : mbSize : col-mbSize+1
x = j;
y = i;
xStart = j; 
yStart = i; 

costs(3) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
imgI(i:i+mbSize-1,j:j+mbSize-1),mbSize);
checkMatrix(p+1,p+1) = 1;
computations = computations + 1;
MVfoundFlag = 0; 
SDSPFlag = 0; 
step = 1; 
% ***********Step(s) 1/2 Uses a SCSP to find a min BDM from 5 points***********
while (MVfoundFlag == 0 && step <= 2)
for k = 1:5
refBlkVer = y + SCSP(k,2);
refBlkHor = x + SCSP(k,1);
if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
|| refBlkHor < 1 || refBlkHor+mbSize-1 > col)
continue; 
end
if (k == 3)
continue; 
elseif (checkMatrix(y-i+SCSP(k,2)+p+1 , x-j+SCSP(k,1)+p+1) == 1)
continue; 
else
costs(k) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);

computations=computations+1;
checkMatrix(y-i+SCSP(k,2) + p+1,x-j+SCSP(k,1) + p+1) = 1; 
end
end 
[cost, point] = min(costs);
if (point == 3)
MVfoundFlag = 1; % first/second step stop
else
x = x + SCSP(point, 1); % shift centre to min BDM location for next step
y = y + SCSP(point, 2);
costs = ones(1,5) * 65537;
costs(3) = cost; % retain the cost so as not to calculate it again
end
step = step + 1;
end 
% ***********Step 3 Uses a LCSP to guide the centre for the following LDSP step***********
% find the minimum BDM between the 3 outer points of the LCSP and the mincost in step 2
if (MVfoundFlag == 0)
% The index points for the Large Cross Shape pattern
LCSP(1,:) = [ 0 -2];
LCSP(2,:) = [-2 0];
LCSP(3,:) = [ 0 0];
LCSP(4,:) = [ 2 0];
LCSP(5,:) = [ 0 2];
OuterCosts = ones(1,5) * 65537;
for k = 1:5
refBlkVer = yStart + LCSP(k,2);
refBlkHor = xStart + LCSP(k,1);
if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
|| refBlkHor < 1 || refBlkHor+mbSize-1 > col)
continue; 
end
if (k == 3)
continue; 
elseif (checkMatrix(LCSP(k,2)+p+1,LCSP(k,1)+p+1) == 1)
continue;
else
OuterCosts(k) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
computations = computations + 1;
checkMatrix(LCSP(k,2)+ p+1,LCSP(k,1)+p+1) = 1; 
end
end 
[Outercost, Outerpoint] = min(OuterCosts);
if (Outercost < cost) 
x = xStart + LCSP(Outerpoint, 1); 
y = yStart + LCSP(Outerpoint, 2); 
mincost = Outercost;
else
mincost = cost;
end
costs = ones(1,9) * 65537; 
costs(5) = mincost; 
end % end if from start of step 3
%****** Step 4 Hexagon Search Pattern*********
while (MVfoundFlag == 0 && SDSPFlag == 0)

% LDSP(1,:) = [-2 -1];
% LDSP(2,:) = [0 -2];
% LDSP(3,:) = [1 -1];
% LDSP(4,:) = [-2 0]; 
% LDSP(5,:) = [0  0];
% LDSP(6,:) = [2  0];
% LDSP(7,:) = [-2  1];
% LDSP(8,:) = [2 1];
% LDSP(9,:) = [0  2];


LDSP(1,:) = [-1 -1];
LDSP(2,:) = [0 -2];
LDSP(3,:) = [1 -1];
LDSP(4,:) = [-1 0]; 
LDSP(5,:) = [0  0];
LDSP(6,:) = [1  0];
LDSP(7,:) = [-1  1];
LDSP(8,:) = [1 1];
LDSP(9,:) = [0  2];


for k = 1:9
refBlkVer = y + LDSP(k,2);
refBlkHor = x + LDSP(k,1); 
if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
|| refBlkHor < 1 || refBlkHor+mbSize-1 > col)
continue; 
end
if (k == 5)
continue; 
elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p ...
|| refBlkVer > i+p)
continue; 
elseif (checkMatrix(y-i+LDSP(k,2)+p+1 , x-j+LDSP(k,1)+p+1) == 1)
continue;
else
costs(k) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
computations = computations + 1;
checkMatrix(y-i+LDSP(k,2)+p+1,x-j+LDSP(k,1)+p+1) = 1;
end
end
[cost, point] = min(costs);
if (point == 5) 
SDSPFlag = 1; 
else
x = x + LDSP(point, 1); 
y = y + LDSP(point, 2);
costs = ones(1,9) * 65537; 
costs(5) = cost; 
end
end 
% ****** Step 5 Last Step*********
if (SDSPFlag == 1)
SDSP(1,:) = [ 0 -1];
SDSP(2,:) = [-1 0];
SDSP(3,:) = [ 0 0];
SDSP(4,:) = [ 1 0];
SDSP(5,:) = [ 0 1];
costs = ones(1,5) * 65537;
costs(3) = cost; 
for k = 1:5
refBlkVer = y + SDSP(k,2);
refBlkHor = x + SDSP(k,1);
if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
|| refBlkHor < 1 || refBlkHor+mbSize-1 > col)
continue;
elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p ...
|| refBlkVer > i+p)
continue;
end
if (k == 3)
continue; 
elseif (checkMatrix(y-i+SDSP(k,2)+p+1 , x-j+SDSP(k,1)+p+1) == 1)
continue;
else
costs(k) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
computations = computations + 1;
checkMatrix(y-i+SDSP(k,2)+ p+1,x-j+SDSP(k,1)+ p+1) = 1; 
end
end 
[cost, point] = min(costs);
x = x + SDSP(point, 1);
y = y + SDSP(point, 2);
end 
vectors(1,mbCount) = y - i; 
vectors(2,mbCount) = x - j; 
mbCount = mbCount + 1;
costs = ones(1, 5) * 65537; 
checkMatrix = zeros(2*p+1,2*p+1); 
end
end
motionVect = vectors;
NHScomputations = computations/(mbCount - 1);