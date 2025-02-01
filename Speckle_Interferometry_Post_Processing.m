%% Description
% MATLAB Script to post-process Speckle-Interferometry Images
% Image Processing steps:
    % 1. Divide Sample-Distorted img by referance speckle image

% Written by: Uri Kaufman 28/01/2025

%% Notes
% OD 1.0 with polarised camera view gives the best results (first image in
% array)


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
Img_Ref_Speckle = zeros(IMG_PIX_WIDTH, IMG_PIX_HEIGHT, IMG_PIX_DEPTH, NUM_IMAGES);
Img_Sample_Speckle = zeros(IMG_PIX_WIDTH, IMG_PIX_HEIGHT, IMG_PIX_DEPTH, NUM_IMAGES);
Img_Divided = zeros(IMG_PIX_WIDTH, IMG_PIX_HEIGHT, IMG_PIX_DEPTH, NUM_IMAGES); %Sample img / ref img (for post processing)

%Read in all images into arrays
for i = 1:NUM_IMAGES
    %Use sprintf() and %d to quickly iterate through file names and read them in
    Img_Ref_Speckle(:,:,:,i) = imread(sprintf("Referance Speckle (33us, 1.0OD, pol, %ddegdiff)_90°.tiff",20*(i-1))); %Referance Speckle
    Img_Sample_Speckle(:,:,:,i) = imread(sprintf("Sample-Distorted Speckle (33us, 1.0OD, pol, %ddegdiff)_90°.tiff",20*(i-1))); %Sample-Distorted Speckle
end

%% Processing
%Combine images with varying speckle patterns
Img_Ref_Combined = zeros(IMG_PIX_WIDTH, IMG_PIX_HEIGHT, IMG_PIX_DEPTH, NUM_IMAGES);
Img_Sample_Combined = zeros(IMG_PIX_WIDTH, IMG_PIX_HEIGHT, IMG_PIX_DEPTH, NUM_IMAGES);
for t = 1:NUM_IMAGES
    Img_Ref_Combined = Img_Ref_Combined + Img_Ref_Speckle(:,:,:,t);
    Img_Sample_Combined = Img_Sample_Combined + Img_Sample_Speckle(:,:,:,t);
end
Img_Ref_Combined = Img_Ref_Combined / NUM_IMAGES;
Img_Sample_Combined = Img_Sample_Combined / NUM_IMAGES;

% Divide sample-distorted img by referance img
Img_Divided = Img_Ref_Combined ./ Img_Sample_Combined;

%% Choosing Best Processed Image (found after looking at output images)
Best_Output_Img = Img_Divided(:,:,:,1);

%% Initial Plots/Figure Calculation
% Original Image Phase - not needed
Img_fft = fft2(fftshift(Img_Sample_Speckle(:,:,:,1))); %Take Fourier Transform of image - FT of Real value produces a complex number at each frequency (each Real part = amplitude of number, each imaginary part contains the phase information)
                                          % fftshift to shift it so that low freqs are in the center      
Img_phases = angle(Img_fft); %angle() extracts the phase of a complex number - extracts all the phases of each cell in the image array

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

figure
imshow(Img_Divided(:,:,:,1));

% figure
% title("Processed Image (BEST)");
% imshow(Best_Output_Img);
