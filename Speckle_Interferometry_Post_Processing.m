close all
clear all
clc

%% Importing Image
ImageOrig = imread("S.B. A sample Trial 2_0°_0°.jpg");

%% Initial Plots/Figure Calculation
% Original Image Phase
im_orig_fft = fft(ImageOrig); %Take Fourier Transform of image - FT of Real value produces a complex number at each frequency (each Real part = amplitude of number, each imaginary part contains the phase information)
im_orig_phases = angle(im_orig_fft); %angle() extracts the phase of a complex number - extracts all the phases of each cell in the image array


%% Processing

% Divide 

%% Writing New Output Image
%imwrite(...);

%% Displaying Figures
figure
title("Original Image");
imshow(ImageOrig);

figure
title("Original Image Heatmap");
imshow(ImageOrig,colormap);

figure %For heatmap
Img_orig_squeezed = squeeze(ImageOrig);
imshow(Img_orig_squeezed(:,:,1), [], Colormap=hot)
colormap(hot);

figure
title("Original Image Phases")
imshow(im_orig_phases);
