function [Ip, sx, sy] = myWarp(I, H)
    [row, col, ~] = size(I);

    [x, y] = meshgrid(1:col, 1:row);
    origCoordinates = [ x(:) y(:) ones(length(x(:)),1)]';

    % find warped image size
    prjCorners = H*origCoordinates;
    max_x = ceil(max(prjCorners(1,:)));
    min_x = floor(min(prjCorners(1,:)));
    max_y = ceil(max(prjCorners(2,:)));
    min_y = floor(min(prjCorners(2,:)));

    % create warped image coordinates
    [x1, y1] = meshgrid(min_x+1:max_x, min_y+1:max_y);
    prjCoordinates = [ x1(:) y1(:) ones(length(x1(:)),1)]';

    % inverse transform
    invCoordinates = H\prjCoordinates;
    xq = reshape(invCoordinates(1,:), max_y-min_y, max_x-min_x);
    yq = reshape(invCoordinates(2,:), max_y-min_y, max_x-min_x);

    % interpolate pixel values
    Ip = zeros(max_y-min_y, max_x-min_x, 3);
    Ip(:,:,1) = interp2(x, y, I(:,:,1), xq, yq, 'bilinear', 0);
    Ip(:,:,2) = interp2(x, y, I(:,:,2), xq, yq, 'bilinear', 0);
    Ip(:,:,3) = interp2(x, y, I(:,:,3), xq, yq, 'bilinear', 0);
    sx = -min_x;
    sy = -min_y;
end
