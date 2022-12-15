clear all %#ok
close all
clc

normImg = @(I) (I - min(I(:))) ./ max(I(:) - min(I(:)));

image = imread('image.png', 'png');
image = rgb2gray(image);
image = mat2gray(image);
image = normImg(image);


noiseParams = {'gaussian', 0, 0.001};
image = imnoise( image, noiseParams{:} );
imwrite(image, 'noisy_image.png');

fileID = fopen('noisy_image.txt', 'wt');
for iter = 1:size(image, 1)
    fprintf(fileID, '%g\t', image(iter,:));
    fprintf(fileID, '\n');
end
fclose(fileID);