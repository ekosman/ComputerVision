%%
%Load the data for the problem eigen faces into the memory. 
clc; clear all;
extensions = {'centerlight', 'glasses', 'happy', 'leftlight', 'noglasses', 'normal', 'rightlight', 'sad', 'sleepy', 'surprised', 'wink' };

num_extensions=length(extensions); % total 11 extensions

num_subjects=15; %the number of distinct people

m=243; % the height of each image
n=320; % the width of each image
A = [];  % zeros(m*n,num_extensions*num_subjects-15); % A is a matrix of size 243*320 by 165, thus each column of A corresponds to a distinct image.

for i=1:num_subjects    
    basename = 'yalefaces/subject';
    if( i < 10 )
        basename = [basename, '0', num2str(i)];
    else
        basename = [basename, num2str(i)];
    end;
    
    for j = 1:num_extensions,
        fullname = [basename, '.', extensions{j}];
        try
            temp = double(imread(fullname));
            a=1;
        catch
            %disp( 'does not exist')
            a = 0;
        end
        if(a)        
            A = [A reshape(temp,m*n,1)];
        end
    end
end
disp('The matrix A is loaded in memory. Its size is:')
disp(size(A));
train_face_id = reshape(repmat([1:15]',1,10)',1,150);


% load test images 
for i = 1:20
    testFileName = ['image' num2str(i)];
    load(testFileName);
end

% ground-truth
num_gnd_truth = 20;
is_face = ones(num_gnd_truth,1);
is_face(1) = 0;
is_face(3) = 0;
is_face(6) = 0;
is_face(12) = 0;
is_face(14) = 0;


face_id = [0,1,0,2,-1,0,4,-1,6,7,8,0,9,0,10,-1,12,13,-1,15];






