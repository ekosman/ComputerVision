clearvars;
close all

img1 = im2double(imread('../building/building2.JPG'));
img1_gray = rgb2gray(img1);
img2 = im2double(imread('../building/building3.JPG'));
img2_gray = rgb2gray(img2);
[frame1, descr1] = sift(img1_gray);
[frame2, descr2] = sift(img2_gray);
match = siftmatch(descr1, descr2);
figure, plotmatches(img1, img2, frame1, frame2, match);
[H, inliers, ransacMatch] = ransac(frame1, frame2, match);
figure, plotmatches(img1, img2, frame1, frame2, ransacMatch);

%% section 5 - image warping, and section 6 - image stitching
[warp, sx, sy] = myWarp(img1, H);
figure, imshow(warp);
stiched = myStich(warp, img2, sx, sy);
figure, imshow(stiched);