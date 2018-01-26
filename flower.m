clear all; close all; clc;
%% READ

im = imread('flower_original.jpg'); % loads the image. Note that image has two be quadratic with 2^n
im = im(1:2048,1001:3048);
if size(im,3) == 1 %checks if image has one or three (RGB) dimensions
    im = cat(3,im,im,im); %if only one dimension, last two dimensions are applied
end
%% FILTER 
%imagesc(abs(fftshift(im4)))
d_low = 75^2; %lower limit
d_high = 30^2; %higher limit
lucorner = zeros(1024); %defines a matrix of zeros with dimensions corresponding to one corner of a 2048x2048

for i = 1:(2048/2) %for loops running over one corner
    for j = 1:(2048/2)
        R = sqrt(j^2+i^2); %define radius
        %lucorner(j,i) = 1*R+5;
        
        %if  d_low < (i^2+ j^2 ) & (i^2+ j^2 ) < d_high %bandpass
               lucorner(j,i) = lucorner(j,i)*0; 
        if i^2+ j^2 < d_high                            %highpass
        
              % lucorner(j,i) = lucorner(j,i)*0; 
        %if (i^2+ j^2) > d_low                        %lowpass, all values above a limit are excluded
         %      lucorner(j,i) = lucorner(j,i)*0; 
        else lucorner(j,i) = 1; %one can also just swap what is zero and what is one to change filters
        end
    end
end
%% FLIPS

rucorner = fliplr(lucorner);
top = [lucorner rucorner];
bottom = flipud(top);
total = [top; bottom];

%creates a total matrix using the filtered left upper corner

%%
%FFT
k=3;
for a = 1:3 %in three dimension RGB or grey
    %im3 = im(1:2048,1:2048,a)
    im3 = im2double(im); %converts image to double 
    im4 = fft2(im3(:,:,a),2048,2048); %takes fourier transform of 2047x2047 image
    
    im5(:,:,a) = im4.*total; %filter is either applied by adding or convolution
end
%% POWER AND SCALE
%POWER
im6 = abs(im5).^2; %creates powerspectrum


%RESCALE 
im6 = log10(im6+10000);
im6 = im6 - min(min(im6));
im6 = im6./max(max(im6))*255;
%imagesc(im5
im_done = ifft2(im5); %inverse fourier transform to get resulting image with applied filter
%imshow(im_done)

%% PLOTS
subplot(2,2,1)
imagesc(im)
subplot(2,2,2)
imshow(im_done)

subplot(2,2,3)
imagesc(im6)