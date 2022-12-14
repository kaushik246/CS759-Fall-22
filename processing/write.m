clear all %#ok
close all
clc

delimiterIn = '\t';
headerlinesIn = 0;

filename1 = 'noisy_image.txt';
noisy_image = importdata(filename1, delimiterIn, headerlinesIn);

delimiterIn = ' ';
filename2 = 'filtered_image.txt';
filtered_image = importdata(filename2, delimiterIn, headerlinesIn);

imwrite(filtered_image, 'filtered_image.png');