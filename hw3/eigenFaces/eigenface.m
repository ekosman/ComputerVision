% load train set (1.a)
readYaleFaces;

% A - is the training set matrix where each column is a face image
% train_face_id - an array with the id of the faces of the training set.
% image1--image20 are the test set.
% is_face - is an array with 1 for test images that contain a face
% faec_id - is an array with the id of the face in the test set, 
%           0 if no face and -1 if a face not from the train-set.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Your Code Here  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Subtract mean image (1.b)
mean_face = mean(A, 2);
A_mean = A - mean_face;
display_vec(mean_face, m, n);


% Compute eigenvectors and report first 5 eigen-faces (2)
first_five = get_r_vectors(A_mean, 5);
for i = 1:5
    out = display_vec(first_five(:, i), m, n);
end

% Display and compute the representation error for the training images (3)
U_25 = get_r_vectors(A_mean, 25);

errors_train = zeros(1, size(A, 2));
rep_train = zeros(size(A, 2), 25);
for i = 1:size(A,2)
    [err, img] = reconstruct(A(:, i), mean_face, U_25);
    errors_train(i) = err;
    rep_train(i, :) = representation(A(:, i), mean_face, U_25);
end

mean(errors_train)

% Compute the representation error for the test images. Classify the test images and report error rate (4)
test_set = [flatten(image1)
            flatten(image2)
            flatten(image3)
            flatten(image4)
            flatten(image5)
            flatten(image6)
            flatten(image7)
            flatten(image8)
            flatten(image9)
            flatten(image10)
            flatten(image11)
            flatten(image12)
            flatten(image13)
            flatten(image14)
            flatten(image15)
            flatten(image16)
            flatten(image17)
            flatten(image18)
            flatten(image19)
            flatten(image20)];
test_set = reshape(test_set, m * n, 20);
errors_test = zeros(1, size(test_set, 2));
rep_test = zeros(size(test_set, 2), 25);
for i = 1:size(test_set,2)
    [err, img] = reconstruct(test_set(:, i), mean_face, U_25);
    errors_test(i) = err;
    display_vec(img, m, n);
    rep_test(i, :) = representation(test_set(:, i), mean_face, U_25);
end
mean(errors_test)

model = fitcknn(rep_train, train_face_id);
relevant_indexes = face_id > 0;
relevant_test_images = test_set(:, relevant_indexes);
rep_test = rep_test(relevant_indexes, :);
test_preds = predict(model, rep_test);
tags = reshape(face_id, 1, []);
tags = tags(relevant_indexes);
accuracy = sum(reshape(test_preds, 1, []) == tags) / length(tags)

error_indexes = reshape(test_preds, 1, []) ~= tags;
error_images = relevant_test_images(:, error_indexes);
for i = 1:size(error_images, 2)
    display_vec(error_images(:, i), m, n);
end

% second classification algorithm
W = LDA(rep_train, train_face_id);
L = [ones(size(rep_test,1),1) rep_test] * W';
mone = exp(L);
mechane = sum(exp(L),2);
P = mone ./ mechane;
[argval, test_preds] = max(P, [], 2);
accuracy = sum(reshape(test_preds, 1, []) == tags) / length(tags)
%{
gm = MyCluster(rep_train);
mapping = {};
for i = 0:14
    data = rep_train(i*10 + 1:i*10 + 10, :);
    p = posterior(gm, data);
    p = sum(p, 1);
   [argvalue, label] = max(p);
   mapping{label} = i+1;
end

p = posterior(gm,rep_test);
[argvalue, argmax] = max(p, [], 2);
test_preds = {};
for i = 1:length(argmax)
    test_preds{i} = mapping{argmax(i)};
end
test_preds = cell2mat(test_preds);
accuracy = sum(reshape(test_preds, 1, []) == tags) / length(tags)
%}
function out = flatten(x)
    [m, n] = size(x);
    out = reshape(x, m * n, 1);
end

function out = representation(x, b, U)
    out = U.' * (double(x) - b);
end

function [err, rec] = reconstruct(x, b, U)
    rep = representation(x, b, U);
    rec = U * rep + b;
    err = rmse(x, rec);
end

function res = rmse(x, y)
    diff = abs(double(x) - double(y));
    sum_diff = sum(diff);
    res = sum_diff / length(x);
    res = res / 255;
    res = res * 100;
end

function img = display_vec(vec, m, n)
    img = reshape(vec, [m, n]);
    %figure;
    %imshow(img, []);
end

function res = get_r_vectors(a, r)
    [U, S, V] = svd(a, 'econ');
    res = U(:, 1:r);
end

function model = MyCluster(X)
    k = 10:20;
    nK = numel(k);
    Sigma = {'diagonal','full'};
    nSigma = numel(Sigma);
    SharedCovariance = {true,false};
    SCtext = {'true','false'};
    nSC = numel(SharedCovariance);
    RegularizationValue = 0.01;
    options = statset('MaxIter',10000);
    % Preallocation
    gm = cell(nK,nSigma,nSC);
    aic = zeros(nK,nSigma,nSC);
    bic = zeros(nK,nSigma,nSC);
    converged = false(nK,nSigma,nSC);

    % Fit all models
    for m = 1:nSC;
        for j = 1:nSigma;
            for i = 1:nK;
                gm{i,j,m} = fitgmdist(X,k(i),...
                    'CovarianceType',Sigma{j},...
                    'SharedCovariance',SharedCovariance{m},...
                    'RegularizationValue',RegularizationValue,...
                    'Options',options);
                aic(i,j,m) = gm{i,j,m}.AIC;
                bic(i,j,m) = gm{i,j,m}.BIC;
                converged(i,j,m) = gm{i,j,m}.Converged;
            end
        end
    end

    allConverge = (sum(converged(:)) == nK*nSigma*nSC)
    
    figure;
    bar(reshape(aic,nK,nSigma*nSC));
    title('AIC For Various $k$ and $\Sigma$ Choices','Interpreter','latex');
    xlabel('$k$','Interpreter','Latex');
    ylabel('AIC');
    xticklabels(k);
    legend({'Diagonal-shared','Full-shared','Diagonal-unshared',...
        'Full-unshared'});

    figure;
    bar(reshape(bic,nK,nSigma*nSC));
    title('BIC For Various $k$ and $\Sigma$ Choices','Interpreter','latex');
    xlabel('$k$','Interpreter','Latex');
    ylabel('BIC');
    xticklabels(k);
    legend({'Diagonal-shared','Full-shared','Diagonal-unshared',...
        'Full-unshared'});
    
    model = fitgmdist(X,17,...
                    'CovarianceType','full',...
                    'SharedCovariance',false,...
                    'RegularizationValue',RegularizationValue,...
                    'Options',options);
end