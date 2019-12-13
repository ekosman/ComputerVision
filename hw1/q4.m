close all; 
%   calculate image points pts3d & pts2d
inl1;
%   remove NaN
noNaNPoints = ~isnan(pts2d(1,:));
pts2d = pts2d(:,noNaNPoints);
pts3d = pts3d(:,noNaNPoints);
%   build A mat (A*Pcs=0)
A = zeros(length(noNaNPoints));
for j = 1:sum(noNaNPoints)
    X = pts3d(:,j);
    u = pts2d(1,j);
    v = pts2d(2,j);    
    A(2*j-1,:) = [X' zeros(1,4) -X'*u];
    A(2*j,:)   = [zeros(1,4) X' -X'*v];
end

[U,D,V] = svd(A);
P = reshape(V(:,size(D,2)), [4 3])';
Pnorm = P/norm(P); % constraint for optimization problem
% section b
pts2dEst = Pnorm*pts3d;
pts2dEst = pts2dEst./repmat(pts2dEst(3,:), 3, 1); % normalize w curl
figure(3);
imshow(im); hold on;
plot(pts2dEst(1,:),pts2dEst(2,:), 'O', 'MarkerSize', 10, 'MarkerFaceColor', 'b'); % plot projected points using matrix P
for i = 1:size(pts2d,2)
    error(i) = (norm(pts2d(:,i) - pts2dEst(:,i))) / (norm(pts2d(:,i)));
end
E = sum(error) % error units are pixels

% section c
[K, R] = rq(Pnorm(1:3,1:3));
scaling = K(3,3);
K = K/scaling; % K(3,3) = 1
R = scaling*R;

% section f
t = K\P(1:3,4);
c = -inv(R)*t;

% section g
figure(2);
plot3(c(1),c(2),c(3),'rO', 'MarkerSize', 10, 'MarkerFaceColor', 'b'); % plot camera location in 3D