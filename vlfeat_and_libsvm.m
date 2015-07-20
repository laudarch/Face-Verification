clear all;

% Before calling any vlfeat functions, initialize the library with vl_setup().
vl_setup()

% Here, we extract a SIFT descriptor at point (x, y), using a SIFT window that is 32 pixels on
% each side.
x = 148;
y = 113;
siftsize = 32;
im = single(imread('lfw2/Abel_Pacheco/Abel_Pacheco_0001.jpg')) ./ 255;
% Each column of the 'frames' parameter indicates a point at which to extract a descriptor.  The
% third row holds the 'scale' of the SIFT descriptor, which for reasons not relevant to our
% usage is one-twelfth of the side length of the SIFT window.
frames = [x; y; siftsize/12; 0];
[f1, d1] = vl_sift(im, 'frames', frames);

% We can also use vl_phow to extract SIFT descriptors at points densely sampled from the image.
[f2, d2] = vl_phow(im, 'sizes', siftsize/4, 'step', 1);

% Look for the vl_phow descriptor corresponding to the vl_sift descriptor.
ix = find((f2(1,:) == f1(1)) & (f2(2,:) == f1(2)));
f2a = f2(:, ix);
d2a = d2(:, ix);

% By plotting the two descriptors, we can see that they are quite similar.  There are some
% slight differences due to implementation details, which are explained in the vl_feat
% documentation.
plot(1:128, d1, 1:128, d2a);


% From libsvm, there are two functions you will need, which you should call as follows:


% model = svmtrain(trainlabels, trainfeats, options);
% [preds, acc, decvals] = svmpredict(testlabels, testfeats, model);



% where
% - trainlabels is column vector of training data labels (1 for "same", -1 for "different").
% - trainfeats is your normalized training data feature matrix, with one row per training
%   sample.
% - options is a libsvm option string describing which kernel you want to use and various other
%   options.  Run svmtrain() without arguments to see a description of the options.
% - model is the trained SVM returned.
% - testlabels is a column vector with the labels of the test data.  It's used only to calculate
%   the accuracy of the SVM.
% - testfeats is the normalized test data feature matrix.
% - preds is a column vector holding the predicted class labels (1 or -1) for the test data.
% - acc is the accuracy of the predicted labels.
% - decvals is a column vector with the same size as preds, holding the signed distance from the
%   decision boundary for each test sample.  preds is just determined by the sign of decvals.
