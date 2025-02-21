%% Description
% MATLAB Script to measure phase shift in interference pattern between two images
% Method:
    % 1. User crops sections of each image where intereference lines are clean and clear
    % 2. Take row in the middle of that cropped image ****----****----****----****---- ...
    % 3. Plot intensity plot for IP
    % 4. Repeat steps 1-3 for 2nd image
    % 5. Compare the two sinusoid plots to give phase shift

% Written by: Uri Kaufman 21/02/2025

%% Abbreviations
% IP = Interference Pattern

%% Notes

%% Constants
close all
clear all
clc

NUM_IMAGES = 2;
IMG_PIX_WIDTH = 2048;
IMG_PIX_HEIGHT = 2448;
IMG_PIX_DEPTH = 3;

%% Importing Image

%Initiate Img arrays
Img_Sample_IP_Array = zeros(IMG_PIX_WIDTH, IMG_PIX_HEIGHT, IMG_PIX_DEPTH, NUM_IMAGES);%For 2 phase shifted IP images

%Read in all images into arrays
Img_Sample_IP_Array(:,:,:,1) = imread("F Sample (shift = 0) (pol=45°) (No Speckle) (500us, 0.5OD)_45°.tiff"); 
Img_Sample_IP_Array(:,:,:,2) = imread("F Sample (shift = 2pi_3) (pol=45°) (No Speckle) (500us, 0.5OD)_45°.tiff"); 


%% Calculate IP Periods

[First_IP, rect1] = imcrop(Img_Sample_IP_Array(:,:,:,1)); % Crop first image where IP lines are clear and save cropped size in 'rect1'
[Second_IP, rect2] = imcrop(Img_Sample_IP_Array(:,:,:,2));

%Extract single row (in middle of cropped image)
First_IP_row = First_IP(round(size(First_IP,1)/2),:,:);
Second_IP_row = Second_IP(round(size(Second_IP,1)/2),:,:);

%Calculate Intensity Max of img

%Plot intensity of each IP

%Calculate shift between the two sinusoid plots

%Display Answer


