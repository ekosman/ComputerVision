% Loading  and preparing the train-set
trainingPath = [pwd '\leaf-data\training\'];

%sizeVec = size(testImgGray);
Threshold = 200/255;
for i=1:5
    tmp_img = imread([trainingPath 'leaf' num2str(i) '.png']);
    tmp_img = rgb2gray(tmp_img);
    tmp_img = double(imbinarize(tmp_img, Threshold));
    %tmp_img = tmp_img / norm(tmp_img, 'fro');
    train_set{i} = ~tmp_img;
    %figure(i)
    %imshow(train_set{i})
end

% Loading and preparing the test image
testImg = imread([pwd '\leaf-data\test\leaf6.png']);
testImgGray = rgb2gray(testImg); % convert target image to gray
testImg = ~imbinarize(testImgGray, Threshold);
testImg = double(imclose(testImg, strel('disk', 30)));
testImg = double(testImg);

%testImg = testImg / norm(testImg, 'fro');

scores = [];
for i=1:5
    cur_img = train_set{i};
    tmp_test = testImg;
    [train_h, train_w] = size(cur_img);
    [test_h, test_w] = size(testImg);
    if train_w > test_w
        % pad the test image in the horizontal axis
        pad = train_w - test_w;
        pad_left = ceil(pad/2);
        pad_right = floor(pad/2);
        tmp_test = [zeros(test_h, pad_left) ,tmp_test , zeros(test_h, pad_right)];
     
    elseif train_w < test_w
        % pad the test image in the horizontal axis
        pad = test_w - train_w;
        pad_left = ceil(pad/2);
        pad_right = floor(pad/2);
        cur_img = [zeros(train_h, pad_left) ,cur_img , zeros(train_h, pad_right)];
    end
    
    % Update the sizes for further calculations
    [train_h, train_w] = size(cur_img);
    [test_h, test_w] = size(tmp_test);
    
    if train_h > test_h
        % pad the test image in the vertical axis
        pad = train_h - test_h;
        pad_up = ceil(pad/2);
        pad_down = floor(pad/2);
        tmp_test = [zeros(pad_up, test_w); tmp_test; zeros(pad_down, test_w)];
     
    elseif train_h < test_h
        % pad the test image in the vertical axis
        pad = test_h - train_h;
        pad_up = ceil(pad/2);
        pad_down = floor(pad/2);
        cur_img = [zeros(pad_up, train_w); cur_img; zeros(pad_down, train_w)];
    end
    
    cur_img = double(cur_img);
    tmp_test = double(tmp_test);
    
    cur_img = cur_img / norm(cur_img, 'fro');
    tmp_test = tmp_test / norm(tmp_test, 'fro');
    
    scores = [scores, sum(cur_img .* tmp_test, 'all')];

end

[val,idxMatching] = max(scores);
fprintf("The matching test leaf is: leaf%d \nWith score of %f\n", idxMatching, val);