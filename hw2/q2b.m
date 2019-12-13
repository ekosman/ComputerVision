f = imread('building.jpg');

[BW, t] = edge(f,'Canny', [0.02 0.04]);
imshow(BW, [])
[H,T,R] = hough(BW);
imshow(H,[]);
hold on;
P  = houghpeaks(H,100);
x = P(:,2); 
y = P(:,1);
plot(x,y,'s','color','white', 'MarkerFaceColor', 'b');

lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
figure, imshow(f), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   %plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   %plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end