%% Description
% MATLAB Script to reconstruct phase of an image using phase shifting interferometry
% Phase Shifting Interferometry Steps (https://spie.org/samples/PM252.pdf    pg192):
    % 1. Modulate phase by 2pi/3 (move mirror to shift fringe lines) (move mirror lambda/6 for 2pi/3 phase shift) 
    % 2. Record min 3 different phase IPs (Intensity pictures (I) at 0, 2pi/3, and 4pi/3) to eliminiate aliasing and calculate phases
    % 3. Calculate Phases at each coordinate (phi(x,y)):
        % phi(x,y;) = arctan[(I(x,y;4pi/3) - I(x,y;0)) / (I(x,y;4pi/3) + I(x,y;0) - 2*I(x,y;2pi/3))]

% Written by: Uri Kaufman 19/02/2025

%% Abbreviations
% IP = Interference Pattern

%% Notes

%% Constants
close all
clear all
clc

NUM_IMAGES = 3; %0, 2pi/3, and 4pi/3
IMG_PIX_WIDTH = 2048;
IMG_PIX_HEIGHT = 2448;
IMG_PIX_DEPTH = 3;

%% Importing Image

%Initiate Img arrays
Img_Sample_IP_Array = zeros(IMG_PIX_WIDTH, IMG_PIX_HEIGHT, IMG_PIX_DEPTH, NUM_IMAGES);%For 3 phase shifted IP images
Img_Orig_Sample = zeros(IMG_PIX_WIDTH, IMG_PIX_HEIGHT, IMG_PIX_DEPTH); %Original Image of Sample (no Interference Pattern)

%Read in all images into arrays
Img_Sample_IP_Array(:,:,:,1) = imread("F Sample (shift = 0) (pol=45°) (No Speckle) (500us, 0.5OD)_45°.tiff"); 
Img_Sample_IP_Array(:,:,:,2) = imread("F Sample (shift = 2pi_3) (pol=45°) (No Speckle) (500us, 0.5OD)_45°.tiff"); 
Img_Sample_IP_Array(:,:,:,3) = imread("F Sample (shift = 4pi_3) (pol=45°) (No Speckle) (500us, 0.5OD)_45°.tiff");
Img_Orig_Sample(:,:,:) = imread("F Sample Orig (500us, 0.5OD)_45°.tiff");

%% Calculating Phase

phi = zeros(IMG_PIX_WIDTH, IMG_PIX_HEIGHT, IMG_PIX_DEPTH);%Phase matrix
I_0 = Img_Sample_IP_Array(:,:,:,1); %Intensity img with 0rad phase shift
I_2pi_3 = Img_Sample_IP_Array(:,:,:,2); %Intensity img with 2pi/3 phase shift
I_4pi_3 = Img_Sample_IP_Array(:,:,:,3); %Intensity img with 4pi/3 phase shift

%Use formula from Phase Reconstruction Algorithm
phi = atan(sqrt(3)*(I_4pi_3 - I_0)./(I_4pi_3 + I_0 - 2*I_2pi_3));


%% Writing New Output Image
%imwrite(...);

%% Displaying Figures
colormap("gray");

subplot(2, 3, 1);
imagesc(I_0(:,:,1));
title("F Sample Interference Pattern (0 rad phase shift)");

subplot(2, 3, 2);
imagesc(I_2pi_3(:,:,1));
title("F Sample Interference Pattern (2pi/3 rad phase shift)")

subplot(2, 3, 3);
imagesc(I_4pi_3(:,:,1));
title("F Sample Interference Pattern (4pi/3 rad phase shift)")

subplot(2, 3, 4);
imagesc(Img_Orig_Sample(:,:,1));
title("Original Image");

subplot(2, 3, 5);
imshow(phi);
title("Phase Reconstruction");

subplot(2, 3, 6);
Phi_squeezed = squeeze(phi(:,:,1));%Extracting one layer of the RGB truecolor image for heatmap
imshow(Phi_squeezed, [], Colormap=hot);
title("Phase Reconstruction (Heatmap)");
