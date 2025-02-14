%% Description
% MATLAB Script to post-process Speckle-Interferometry Images
% Image Processing steps:
    % 1. Divide Sample-Distorted img by referance speckle image
    % 2. Take 2D inverse fourier transform of result
    % 3. Shift inverse fourier transformed image to align sample on center
    % of image plane
    

% Written by: Uri Kaufman 28/01/2025

%% Notes
% Img_Divided = (Img_Ref_One_Plane - Img_Sample_One_Plane) ./
% (Img_Ref_One_Plane + Img_Sample_One_Plane);  gave some interesting
% results

%% Constants
close all
clear all
clc

NUM_IMAGES = 18;
IMG_PIX_WIDTH = 2048;
IMG_PIX_HEIGHT = 2448;
IMG_PIX_DEPTH = 3;

%% Importing Image

%Initiate Img arrays
Img_Ref = zeros(IMG_PIX_WIDTH, IMG_PIX_HEIGHT, IMG_PIX_DEPTH);
Img_Sample = zeros(IMG_PIX_WIDTH, IMG_PIX_HEIGHT, IMG_PIX_DEPTH);
Img_Divided = zeros(IMG_PIX_WIDTH, IMG_PIX_HEIGHT, IMG_PIX_DEPTH); %Sample img / ref img (for post processing)
Img_Inv_Fourier = zeros(IMG_PIX_WIDTH, IMG_PIX_HEIGHT); %Inverse Fourier of an image (for post processing)

%Read in all images
Img_Sample = imread("X-Sample Distorted Img (No Speckle) (179895us, 1.5OD)_90°.jpg");
Img_Ref = imread("Ref Img (No Speckle) (179895us, 1.5OD)_90°.jpg");

%Extract one plane of images
Img_Sample_One_Plane = Img_Sample(:,:,1);
Img_Ref_One_Plane = Img_Ref(:,:,1);



%% Processing
%Combine images with varying speckle patterns
% Img_Ref_Combined = zeros(IMG_PIX_WIDTH, IMG_PIX_HEIGHT, IMG_PIX_DEPTH, NUM_IMAGES);
% Img_Sample_Combined = zeros(IMG_PIX_WIDTH, IMG_PIX_HEIGHT, IMG_PIX_DEPTH, NUM_IMAGES);
% for t = 1:NUM_IMAGES
%     Img_Ref_Combined = Img_Ref_Combined + Img_Ref_Speckle(:,:,:,t);
%     Img_Sample_Combined = Img_Sample_Combined + Img_Sample_Speckle(:,:,:,t);
% end
% Img_Ref_Combined = Img_Ref_Combined / NUM_IMAGES;
% Img_Sample_Combined = Img_Sample_Combined / NUM_IMAGES;

% Divide sample-distorted img by referance img
% Img_Divided = Img_Ref_Combined ./ Img_Sample_Combined;
Img_Divided = Img_Ref_One_Plane ./ Img_Sample_One_Plane;

%Take inv Fourier transform and shift in spacial plane
Img_Inv_Fourier = ifftshift(ifft2(Img_Divided));

%Take log of magnitude of inv Fourier image (for graphing)
Img_log = log(abs(Img_Inv_Fourier));

%% Choosing Best Processed Image (found after looking at output images)
%Best_Output_Img = Img_Divided(:,:,:,1);

%% Initial Plots/Figure Calculation
% Original Image Phase - not needed
% Img_fft = fft2(fftshift(Img_Sample_Speckle(:,:,:,1))); %Take Fourier Transform of image - FT of Real value produces a complex number at each frequency (each Real part = amplitude of number, each imaginary part contains the phase information)
%                                           % fftshift to shift it so that low freqs are in the center      
% Img_phases = angle(Img_fft); %angle() extracts the phase of a complex number - extracts all the phases of each cell in the image array

%% Writing New Output Image
%imwrite(...);

%% Displaying Figures
% figure
% title("Original Image");
% imshow(Img_Sample_Speckle(:,:,:,1));
% 
% figure %For heatmap
% Img_squeezed = squeeze(Best_Output_Img);
% imshow(Img_squeezed(:,:,3), [], Colormap=hot);
% colormap(hot);

% figure
% imagesc(Img_phases);

%All output images with varying OD for the ND filters
% for k = 1:NUM_IMAGES
%     figure
%     imshow(Img_Divided(:,:,:,k));
% end

% figure
% imshow(Img_Divided(:,:,:,1));

% figure
% title("Processed Image (BEST)");
% imshow(Best_Output_Img);

%----------------------------------------
subplot(2, 2, 1);
imshow(Img_Sample);
title("Original Image (Fourier Transformed)");

subplot(2, 2, 2);
imshow(Img_log, []);
title("Inv Fourier Image (Log scaled)")

subplot(2, 2, 3);
imshow(rgb2gray(Img_Sample), [], Colormap=hot);
title("Original Image (Fourier Transformed) Heatmap")

% subplot(2, 2, 4);
% Img_squeezed = squeeze(Img_log);
% imshow(Img_squeezed, [], Colormap=parula);
% title("Heatmap of Inv Fourier Image (Log Scaled)");

subplot(2, 2, 4);
Img_squeezed = squeeze(Img_log);
imshow(Img_squeezed, [], Colormap=turbo);
title("Heatmap of Inv Fourier Image (Log Scaled)");
