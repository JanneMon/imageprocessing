clear all; close all; clc;
%% READ

im = imread('projekt_shark.jpg');


%% FILTER
%imagesc(abs(fftshift(im4)))
d_low = 70^2; % low value = less clear
d_high = 1.5^2; % low value = less black 
lucorner = zeros(1024); %creates corner matrix of image consisting of zeros

for u = 1:3 %Everything is applied to each color
    %The following determines how much each color should weight. The
    %parameter g is apllied in the filter
    if u ==1 %red
        g = 3;
    elseif u ==2 %green
        g = 1;
    else g = 1.2; %blue
    end
    
        R = sqrt(j^2+i^2); %defines radius
        DR = 1500; %  
        
   for i = 1:(2048/2)
        for j = 1:(2048/2)
       
        %lucorner(j,i) = 1*R+5;
        
        %if d_low < (i^2+ j^2 ) & (i^2+ j^2 ) < d_high                 %bandpass
         %      lucorner(i,j) = 0*g; 
        if i^2+ j^2 < d_high                     %highpass
               lucorner(j,i) = 0.3*g; %0.3 because the effects should not be too high (0).
        %if i^2+ j^2 > d_low                       %lowpass
         %     lucorner(j,i) = 0*g; 
        else lucorner(i,j) = 1.5*g;                 %parameter 1.5 determines how much filter weight 
        end
        %lucorner(i,j)=lucorner(i,j)*1/(1+(R/DR)^2); 
        %a function which can be applied for a smooth trnasition
        end
   end 


rucorner = fliplr(lucorner);
top = [lucorner rucorner];
bottom = flipud(top);
total = [top; bottom]; %createz total filter image
  
%%
%FFT
k = 10; 

    %im3 = im(1:2048,1:2048,a)
    im3 = im2double(im); %image to double (matrixform)
    im4 = fft2(im3(:,:,u),2048,2048); 
    %fft of 2047x2047 image, compensates by adding pixels of value zero
    
    im5(:,:,u) = im4.*total; %convoluting the image (smooth transition)
end
%% POWER AND SCALE
%POWER
im6 = abs(im5).^2; %powerspectrum


%RESCALE 
im6 = log10(im6+10);
im6 = im6 - min(min(im6));
im6 = im6./max(max(im6))*255;
%imagesc(im5)
im_done = ifft2(im5); %inverse fourier transform
%imshow(im_done)

%% PLOTS
subplot(2,2,1)
imagesc(im)
subplot(2,2,2)
imagesc(im6)
subplot(2,2,3)
imshow(im_done)
