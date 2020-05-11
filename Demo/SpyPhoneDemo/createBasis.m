%% This file generates a basis from piano note frequencies (plus a few
% more). We will use this as the basis for our songs during l1-minimization routines.
startup;


fs=20000;           % Sampling frequency
t = 1/fs:1/fs:0.1; % Time points of each sample in a quarter-second note
T = length(t);      % Number of samples in a note
M = 10;             % Number of notes in Mary Had a Little Lamb.

% The frequencies for piano notes can be derived from formula.
% I simply downloaded them from Professor Bryan Suits at Michigan Tech.
% http://www.phy.mtu.edu/~suits/notefreqs.html

allfreqs = 1:100;
lengthAF = length(allfreqs);
files=dir('sameBoy/*.wav');
fileL = length(files);
dict = [];
for i=1:fileL
    [y,Fs] = audioread(fullfile(files(i).folder, files(i).name));
    middle = floor(length(y)/2);
    y=y((middle-7099):(middle+7100));
    y = buffer(y,T);
    dict = [dict y];
    if size(dict,2) > lengthAF
        break;
    end
end



%% First let's generate the scale so we can hear what the notes will sound
% like.

xall=[]; % This vector will hold all our notes.

% I multiply the sine waves by exponentials to get a "ding" sound:
df = 15; % This is the rate of decay of the note.
sf = 15; % This is the rate of growth at the beginning of the note.

for frequency = allfreqs
    n1 = dict(:,frequency)';
    xall = [xall n1];
end
% Play the whole scale to hear what it sounds like:
% sound(xall,fs);


%% Now let's create a basis that we will use to reconstruct songs.
% All notes will be a quarter-second long, and our basis will handle 
% 29-note songs. So we simply need to replicate each note in each position 
% in the song.

% Since there will be a lot of zeros, we will use the sparse matrix format 
% for efficient computation.

I=zeros(1,length(t)*length(allfreqs)*M); % Row indices
J=zeros(1,length(t)*length(allfreqs)*M); % Column indices
S=zeros(1,length(t)*length(allfreqs)*M); % The matrix value at that index.
inds=1:length(t);
biter=1;
for fiter=1:length(allfreqs)
    for k=1:M
        I(inds) = [ones(1,length(t))*biter];
        J(inds) = [((k-1)*T+1):k*T];
        S(inds) = dict(:,allfreqs(fiter))';
        biter=biter+1;
        inds = inds+length(t);
    end
end
tic
pianoBasis = sparse(I,J,S,length(allfreqs)*M,M*T);
toc

save pianoBasis.mat pianoBasis fs t M allfreqs
