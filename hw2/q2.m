f=zeros(101,101);
f(1,1)=1;
H=hough(f);
imshow(H,[])
f(101,1)=1;
H=hough(f);
imshow(H,[])
f(1,101)=1;
H=hough(f);
imshow(H,[])
f(101,101)=1;
H=hough(f);
imshow(H,[])
f(51,51)=1;

f = zeros(101, 101);
f(40:80, 20:75)=1;
f = imrotate(f,25,'bilinear','crop');
imshow(f, [])

BW = edge(f,'Canny');
imshow(BW, [])
[H,T,R] = hough(BW);
imshow(H,[]);
hold on;
P  = houghpeaks(H,4);
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
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end