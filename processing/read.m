clear all %#ok
close all
clc

%% USEFUL FUNCTION(S)

% image normalizer
normImg = @(I) (I - min(I(:))) ./ max(I(:) - min(I(:)));

%% READ IMAGE, CONVERT TO GRAYSCALE & NORMALIZE

% change file name accordingly
image = imread('image.png', 'png');
image = rgb2gray(image);
image = mat2gray(image);
% normalize the image
image = normImg(image);

%% APPLY NOISE AND EXPORT TO .PNG

% apply noise to image
noiseParams = {'gaussian', 0, 0.001};
image = imnoise( image, noiseParams{:} );
imwrite(image, 'noisy_image.png');

%% EXPORT NOISY IMAGE TO .TXT FILE

fileID = fopen('noisy_image.txt', 'wt');
for iter = 1:size(image, 1)
    fprintf(fileID, '%g\t', image(iter,:));
    fprintf(fileID, '\n');
end
fclose(fileID);