%% Description
% MATLAB Script to measure phase shift in interference pattern between two
% images (also validates input data - OPTIONAL)
% Method:
    % 1. User uses improfile to extract one line of first image where intereference lines are clean and clear
    % 2. Take row in the middle of that cropped image ****----****----****----****---- ...
    % 3. Plot intensity plot for IP
    % 4. Repeat steps 1-3 for 2nd image (using same coordinates of the original line)
    % 5. Validate data - make sure phase shifting has not altered IP frequency too much
    % 6. Display sinusoid intensity graph to user. They must decide if the
    % line they picked accurately depicts their interference pattern -
    % specifically if there is an extra peak at the start that will ruin
    % the sync between the two sinusoids
    % 7. Compare the two sinusoid plots to give phase shift (for best
    % results, user should also take multiple measurements and look closely
    % at the phase shift plot)

%Libraries Needed:
    % 1. Image Processing Toolbox
    % 2. Signal Processing Toolbox (OPTIONAL - needed only for Data Validation)

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

FREQ_PEAK_PROMINENCE_MIN = 2e3; %Used in data validation to find relevant peaks
FREQ_DATA_ERROR_MARGIN = 1e-5; % Percent acceptable error in data (specifically in changes in frequency whilst phase shifting)

PHASE_PEAK_PROMINENCE_MIN = 15; %Used to find peaks in sinusoid of IP intensity (for phase shift measuring)

PEAK_DIFF_TOLERANCE = 0.3; %How different two peaks can be in magnitude before they are considered to correspond to a different phase (used to determine if peak has been truncated)

%% Importing Image

%Initiate Img arrays
Img_Sample_IP_Array = zeros(IMG_PIX_WIDTH, IMG_PIX_HEIGHT, IMG_PIX_DEPTH, NUM_IMAGES);%For 2 phase shifted IP images

%Read in all images into arrays
Img_Sample_IP_Array(:,:,:,1) = imread("0 shift_45°.jpg"); 
Img_Sample_IP_Array(:,:,:,2) = imread("2pi shift_45°.jpg"); 


%% Extract Intensity plot 

%Use improfile to extract intensity profile along one line (user selects line only for first image)
IP1 = Img_Sample_IP_Array(:,:,1,1);
imagesc(IP1);
title("Select line perpendicular to pattern. Choose area where lines are distinct.");
xlabel("INSTRUCTIONS: Single click to begin line => Double click to finish line");
[cx, cy, IP1_Intensity, xi2, yi2] = improfile; % xi2 and yi2 = vectors of coordinates of line endpoints (cx and cy needed for syntax but not used)

%Extract intensity plot of 2nd image on same coordinate line
IP2 = Img_Sample_IP_Array(:,:,1,2);
IP2_Intensity = improfile(IP2, xi2, yi2);

%% Data Validation Checks - not strictly necessary
%Fourier Transform both patterns to validate that IP freq was not accidentally altered whilst phase shifting
Mag_Fourier_IP1 = abs(fft2(fftshift(IP1_Intensity)));
Mag_Fourier_IP2 = abs(fft2(fftshift(IP2_Intensity)));

%Find location of freq peaks in both IPs and compare (only peaks with prominence of at least PEAK_PROMINENCE_MIN)
[pks1, locs1] = findpeaks(Mag_Fourier_IP1,'MinPeakProminence',FREQ_PEAK_PROMINENCE_MIN);
[pks2, locs2] = findpeaks(Mag_Fourier_IP2,'MinPeakProminence',FREQ_PEAK_PROMINENCE_MIN);

% If peaks occur at very similar freqs, freq was not affected during phase shift
data_valid = 1;
% Check for same number of freq peaks
if(size(pks1) ~= size(pks2))
    display("Sub-optimal data detected : Extra noise frequencies detected in one image. This is non-critical ; calculation will continue.");
end
%Validate that peak freqs are the same (within acceptable error range)
for k = 1:size(locs1,1)
    if ~(ismembertol(locs1(k), locs2(k), FREQ_DATA_ERROR_MARGIN))
        data_valid = 0; %Data is invalid
    end
end

%% User checks if captured sinusoids is indeed the pattern they want to analyse
%Show User possible error with their peak graph
imshow("BAD Extra peak.png")
%Plot intensity of each IP together to show phase shift for user to verify
%if this is the pattern they want to analyse
figure
hold on
plot(IP1_Intensity);
plot(IP2_Intensity);
title("Intensity Plot Showing Phase Shift");
xlabel("Travel along Interference Pattern");
ylabel("Intensity");
legend("First Pattern Sinusoid", "Second Pattern Sinusoid (Phase-Shifted)")
hold off

%% Calculate Phase Shift
% Find peaks in each IP intensity sinusoid
[pks_IP1, loc_pks_IP1] = findpeaks(IP1_Intensity,'MinPeakProminence',PHASE_PEAK_PROMINENCE_MIN);
[pks_IP2, loc_pks_IP2] = findpeaks(IP2_Intensity,'MinPeakProminence',PHASE_PEAK_PROMINENCE_MIN);

% Make loc_pks_IP1 and loc_pks_IP2 the same size (truncate from the end)
if(size(loc_pks_IP1,1) > size(loc_pks_IP2,1))
    loc_pks_IP1 = loc_pks_IP1(1:size(loc_pks_IP2,1), :);
else
    loc_pks_IP2 = loc_pks_IP2(1:size(loc_pks_IP1,1), :);
end

% Find average period of IP1 (should be simliar to that of IP2 if data is validated)
IP1_periods = zeros(size(loc_pks_IP1,1) - 1, 1);%Array of measured periods of IP1
for k = 1:((size(loc_pks_IP1,1) - 1))
    IP1_periods(k) = loc_pks_IP1(k+1) - loc_pks_IP1(k);
end

% Remove outliers and calculate average period
avg_period = mean(rmoutliers(IP1_periods))

% Find average distance between corresponding peaks of IP1 and IP2
Peak_distances = zeros(size(loc_pks_IP1,1), 1); %Array of distances between peaks
for j = 1:size(loc_pks_IP1,1)
    Peak_distances(j) = abs(loc_pks_IP1(j) - loc_pks_IP2(j));
end

% Remove outliers and calculate average phase shift
avg_phase_shift_unscaled = mean(rmoutliers(Peak_distances));


%Calculate phase shift with reference to period
scaled_phase_shift = avg_phase_shift_unscaled/avg_period;

%% Display Results
%Take Fourier Transform to show phase shift did not impact frequency (OPTIONAL)
figure
hold on
plot(Mag_Fourier_IP1);
plot(Mag_Fourier_IP2);
title("Fourier Transform (Magnitude) Plot - Invariant Frequency Validation");
xlabel("Frequency");
ylabel("Magnitude");
legend("First Pattern", "Second Pattern (Phase-Shifted)")
hold off

%Display if Data is Valid
if (data_valid)
    display("DATA VALID - Phase shift has not significantly altered the interference pattern frequency. (Tolerance = " + FREQ_DATA_ERROR_MARGIN + "% )");
else
    display("WARNING - DATA INVALID - Your phase shift has altered the interference pattern frequency by more than " + FREQ_DATA_ERROR_MARGIN + "% . Using this data is not recommended. See 'Invariant Frequency Validation' Plot or try running again.");
end

%Display Phase Shift in terms of pi
display("Phase Shift = " + scaled_phase_shift + "π");


