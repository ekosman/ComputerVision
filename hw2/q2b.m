f = double(imread('building.jpg'));

[BW, t] = edge(f,'Canny', [0.01 0.12]);
figure(1)
imshow(BW, [])
[H,T,R] = hough(BW);
%imshow(H,[]);
hold on;
P  = houghpeaks(H,200, 'Threshold', 0.05*max(H(:)));
x = P(:,2); 
y = P(:,1);
%plot(x,y,'s','color','white', 'MarkerFaceColor', 'b');

lines = houghlines(BW,T,R,P,'FillGap',4.5,'MinLength',1);
bl = zeros(size(f));
figure(2)
imshow(bl), hold on
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','white'); hold on;

end