%% In this file we generate the song Mary Had a Little Lamb using the basis
% of quarter-second notes that we created for the piano.
clear all; clc;
load pianoBasis.mat

% These are indices into the vector of piano frequencies that refer to the
% 29 notes of Mary Had a Little Lamb. Where there are zeros, there are
% pauses in the song.
msInds =[1:7 0 0 0];

% Now we pick out which basis functions will result in our song.
note=[];
for i=1:M
    if msInds(i) > 0
        note=[note msInds(i)*M+i];
    end   
end
maryWeights = zeros(M*length(allfreqs),1);
maryWeights(note)=1;

% Multiply the Basis by the Weights to get the song:
marySong = pianoBasis'*maryWeights;
audiowrite('fullDigit.wav',marySong, fs);

% Let's hear how it sounds:
sound(marySong,fs);

save marySong.mat