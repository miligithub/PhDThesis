%% In this file we use various methods to reconstruct undersampled versions
% of the Mary Had a Little Lamb song.
clear all;
clc;

load pianoBasis.mat
load marySong.mat
% addpath ./GPSR_6.0

n = length(marySong);

%% Here we create two measurement matrices which simulate various
% sampling operators. We either undersample by taking only 1200 random
% samples (that's less than 4% of the samples in the file), or we take
% every 265th sample, which gives us a little more than 1200 samples total.

% Depending on which simulation we ran, we uncommented either the first
% R_meas code or the second here. Then we also uncommented the appropriate
% wavwrite command at the very end of the code.

% % Uniform under-sample every 260th sample. Results in 1229 total samples.
iunder = 50;
ii=iunder:iunder:n;
R_meas = sparse(1:length(ii),ii,ones(size(ii)),length(ii),n);

 
% % Uniform under-sample every 700th sample. Results in 456 total samples.
% iunder = 700;
% ii=iunder:iunder:n;
% R_meas = sparse(1:length(ii),ii,ones(size(ii)),length(ii),n);


% Random time samples
% k = 456;                                    % Number of samples
% ii = sort(randsample(1:n,k));               % index of samples
% R_meas = sparse(1:k,ii,ones(size(ii)),k,n); % Measurement matrix


%% For the l1 minimization code, we need to fit the data using a matrix
% product of our measurement matrix and our known basis.

R = R_meas*pianoBasis';

% These are input functions to GPSR, the code we're using for l1
% minimization.

hR = @(x) R*x;
hRt = @(x) R'*x;

y = R_meas*marySong;
audioFile = 'blb1a.wav';
% folder='digitz/';
folder='sameBoy/';
[tempY,tempFs] = audioread([folder audioFile]);
middle = floor(length(tempY)/2);
tempY=tempY((middle-7999):(middle+8000));
% sound(tempY,tempFs);


downY=downsample(tempY,iunder);
y=[downY; zeros(length(y) - length(downY), 1)];
audiowrite(['raw' audioFile], downY, tempFs/iunder);

% regularization parameter
tau = 0.1*max(abs(R'*y));
debias = 1;
stopCri = 4;

[x,x_debias,obj,...
    times,debias_start,mse]= ...
         GPSR_BB(y,hR,tau,...
         'Debias',debias,...
         'AT',hRt,... 
         'Monotone',1,...
         'Initialization',0,...
         'MaxiterA', 2000, ...
         'StopCriterion',stopCri,...
         'ToleranceD',0.001);

% Play the l1 result
sound(pianoBasis'*x_debias,fs);

% mary_456random_l1 = pianoBasis'*x_debias;
% wavwrite(mary_456random_l1,fs,32,'mary_456random_l1.wav');
mary_456unif_l1 = pianoBasis'*x_debias;
audiowrite(['recovered' audioFile],mary_456unif_l1,fs);
% mary_1229unif_l1 = pianoBasis'*x_debias;
% wavwrite(mary_1229unif_l1, fs, 32, 'mary_1229unif_l1.wav');

return;

%% l2 result
xl2 = R\y;

% Debias the l2 result
inds = find(xl2>0);
xl2(inds) = R(:,inds)\y;

% Play the l2 result
sound(pianoBasis'*xl2,fs);

mary_456random_l2 = pianoBasis'*xl2;
wavwrite(mary_456random_l2,fs,32,'mary_456random_l2.wav');
% mary_456unif_l2 = pianoBasis'*xl2;
% wavwrite(mary_456unif_l2,fs,32,'mary_456unif_l2.wav');
% mary_1229unif_l2 = pianoBasis'*xl2;
% wavwrite(mary_1229unif_l2,fs,32,'mary_1229unif_l2.wav');



%% Linear interpolation result

tfull = 1/fs:1/fs:(0.25*M);
tii = tfull(ii);
y_interp = interp1(tii,y,tfull,'linear');
sound(y_interp,fs)

% For any lower sampling rate, linear interpolation is mostly inaudible.
% wavwrite(y_interp, fs, 'mary_1229unif_interp.wav');