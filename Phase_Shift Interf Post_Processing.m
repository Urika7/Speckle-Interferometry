%% Description
% MATLAB Script to post-process Phase-Shifting Interferometry
% Phase Shifting Interferometry Steps (https://wp.optics.arizona.edu/jcwyant/wp-content/uploads/sites/13/2016/08/05-1-Direct_Phase_Measurement_Interferometry.pptx.pdf):
    % 1. Modulate phase (move mirror to shift fringe lines) (move mirror lambda/8 for pi/2 phase shift) 
    % 2. Record min 3 different phase IPs (pictures A, B, and C) (to eliminiate aliasing)
    % 3. Calculate Optical Path Difference:
        %OPD = lambda/(2pi)*arctan[(C - B)/(A-B)]
% Image Processing steps:
    % 1. 

% Written by: Uri Kaufman 19/02/2025

%% Abbreviations
% IP = Interference Pattern

%% Notes

%% Constants
close all
clear all
clc

NUM_IMAGES = 3; %A, B, and C
IMG_PIX_WIDTH = 2048;
IMG_PIX_HEIGHT = 2448;
IMG_PIX_DEPTH = 3;

%% Importing Image

%Initiate Img arrays
Img_Sample = zeros(IMG_PIX_WIDTH, IMG_PIX_HEIGHT, IMG_PIX_DEPTH);

%Read in all images
Img_Sample_IP = imread("X-Sample Distorted Img (No Speckle) (179895us, 1.5OD)_90°.jpg");

%Read in all images into arrays (save only 1st pixel depth of image)
for i = 1:NUM_IMAGES
    %Use sprintf() and %d to quickly iterate through file names and read them in
    Img_Sample_IP_Array(:,:,1,i) = imread(sprintf("CU Sample 3 w Speckle (600us, 0.0OD) (%ddeg)_90°.tiff",(i-1)*20)); %Array of shifted Sample-Distorted Interference Patterns (IP)
end


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
% Img_Inv_Fourier = ifftshift(ifft2(Img_Divided));

%Take log of magnitude of inv Fourier image (for graphing)
% Img_log = log(abs(Img_Inv_Fourier));
Img_log = Img_Divided;

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
title("Sample-Distorted Intererence Pattern");

subplot(2, 2, 2);
imshow(Img_log, []);
title("Processed Image (After Division)")

subplot(2, 2, 3);
imshow(Img_Orig);
title("Original Sample Image (Expected Output)")

% subplot(2, 2, 4);
% Img_squeezed = squeeze(Img_log);
% imshow(Img_squeezed, [], Colormap=parula);
% title("Heatmap of Inv Fourier Image (Log Scaled)");

subplot(2, 2, 4);
Img_squeezed = squeeze(Img_log);
imshow(Img_squeezed, [], Colormap=turbo);
title("Heatmap of Processed Image (After Division)");
