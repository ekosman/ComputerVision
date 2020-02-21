% section 4 q1- Find al inliers
function [bestH, maxInliers, ransacMatch] = ransac(P1, P2, match)
iterations = 1000;
bestH = [];
maxInliers = 0;
matchP1 = P1(1:2,match(1,:));
matchP2 = P2(1:2,match(2,:));
for iteration = 1:iterations
    % randomly choose 4 key points
    rnd = randi([1 size(match,2)],1,4);
    keyIndex = match(:,rnd);
    p1Index = keyIndex(1,:);
    p2Index = keyIndex(2,:);
    % take only XY data from P1, P2
    p1 = P1(1:2,p1Index);
    p2 = P2(1:2,p2Index);
    % calculate affine transform for iteration
    H = getProjectiveTransform(p1, p2);
    % map points from first image to second using the projective transformation  
    P2CurlH = H*[matchP1;ones(1,length(matchP1))];
    P2Curl = P2CurlH(1:2,:) ./ P2CurlH(3,:);
    % calculate fitting error - L2 norm
    err = sqrt(sum((matchP2-P2Curl).^2,1)); 
    % give score to current fitting
    iterInliers = sum(err < 5);
    if iterInliers > maxInliers
        bestH = H;
        maxInliers = iterInliers;
    end
end

matchPointsNum = size(match,2);
if maxInliers == matchPointsNum
    bestH = getProjectiveTransform(matchP1, matchP2);
end
% matching inlier key-points after ransac
P2CurlH = bestH*[matchP1;ones(1,length(matchP1))];
P2Curl = P2CurlH(1:2,:) ./ P2CurlH(3,:);
err = sqrt(sum((matchP2-P2Curl).^2,1));
ransacMatch = match(:,err<5);
