function res = myStich(I1, I2, sx, sy)
% padd warped image with zeros to make images in the same size
[h1, w1, ~] = size(I1);
[h2, w2, ~] = size(I2);

res = zeros(max(h1,h2)*2, w1+w2, 3);
c_res = floor(size(res, 1) / 2);
c_1 = (size(I1, 1) / 2);
d = floor(c_res - c_1);

res(d+1 : d + h1, 1:w1, :) = I1;
figure, imshow(res);
sy = sy + d;

res(sy+1:sy+h2, sx+1:sx+w2,:) = I2;
end
