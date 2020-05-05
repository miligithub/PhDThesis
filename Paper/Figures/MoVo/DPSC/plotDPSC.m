startup;
% colormap(cmocean('balance'));
% addpath(genpath('../../../mPraat/'));
% addpath(genpath('../../../FigGenMatlab/'));
% addpath(genpath('../../../MIRtoolbox/'));
% addpath(genpath('../../../autoArrangeFigures/'));
% addpath(genpath('../../../hline_vline/'));
% 
% 
% %Same Person Same Command
% 
% msize = 25;
% fsize = 15;
% lwidth = 0.5;
% color1 = [191/255 63/255 63/255]; % red
% color2 = [191/255 127/255 63/255]; % orange
% color3 = [191/255 191/255 63/255]; % yellow
% color4 = [63/255 191/255 63/255]; % green
% color5 = [63/255 127/255 191/255]; % blue
% color6 = [127/255 63/255 191/255]; % purple
% color7 = [63/255 63/255 191/255]; % purple
% color8 = [63/255 191/255 191/255]; % green


%subfigures: audio, spectrogram, acc gyro, psd of acc and gyro, data after
%preprocessing

startingFolder = pwd;
folder = uigetdir(startingFolder);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%TextGrid%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filePattern = fullfile(folder, '*.TextGrid');
files = dir(filePattern);
for k = 1 : length(files)
  fullFileName = fullfile(folder, files(k).name);
  slimFileName = erase(files(k).name, '.wav.TextGrid');
  fprintf('Now processing file %s...\n', slimFileName);
  
  tg = tgRead(fullFileName);
  tiers = tgGetNumberOfTiers(tg);
  duration = tgGetTotalDuration(tg);
  
  tier1name = tgGetTierName(tg, 1);
  type1 = tg.tier{1}.type;
  numSyllablePoints = length(tg.tier{1}.T);
  syllabletime = tg.tier{1}.T;
  
  tier2name = tgGetTierName(tg, 2);
  type2 = tg.tier{2}.type;
  %     totalDuration = tgGetTotalDuration(tg, 'silences');
  %     tStart = tgGetStartTime(tg, 'silences');
  %     tEnd = tgGetEndTime(tg, 'silences');
  
  numIntervals = length(tg.tier{2}.T1);
  label = tg.tier{2}.Label;
  sounding = tgFindLabels(tg, 'silences', {'sounding'});
  numSounding = length(sounding)
  soundingStart = tg.tier{2}.T1(cell2mat(sounding));
  soundingEnd = tg.tier{2}.T2(cell2mat(sounding));
  soundingDuration = soundingEnd - soundingStart;
  % Test the 1st sounding interval
  assert(soundingStart(1) == tg.tier{2}.T1(sounding{1}));
  assert(soundingEnd(1) == tg.tier{2}.T2(sounding{1}));
  assert(strcmp('sounding',tg.tier{2}.Label{sounding{1}}));
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Audio%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Audio File
  audioFileName = fullfile(folder, [slimFileName '.wav']);
  %   audioInfo = audioinfo(audioFileName)
  audio = miraudio(audioFileName)
  pause(.5);
  findall(gcf);
  audioLine = findobj(gcf,'Type', 'Line')
  
  
  [audioSig, audioFs] = audioread(audioFileName);
  figure;
  %   pspectrum(audioSig, audioFs,'spectrogram', ...
  %     'FrequencyLimits',[0 500],'TimeResolution',0.1)
  spectrogram(audioSig, 400, 200, 400, audioFs, 'yaxis')
  pause(.5);
  findall(gcf);
  audioSpec = findobj(gcf,'Type', 'Image')
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Motion%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Motion File
  motionFileName = fullfile(folder, [slimFileName '.txt']);
  motion = readtable(motionFileName);
  %   summary(motion)
  rowMotion = size(motion,1);
  colMotion = size(motion,2);
  
  motionFs = 400;
  motionExpect = duration*motionFs
  motionTrue = size(motion)
  motion(1:50,:) = [];
  tmpn=motionExpect/2;
  for i = 1:50
    motion(tmpn+1:end+1,:) = motion(tmpn:end,:);
    motion(tmpn,:) = [];
  end
  motion(1:50,:) = [];
  motionFs = size(motion,1)/duration;
  summary(motion)
  motionStart = round(soundingStart./duration.*rowMotion)
  motionEnd = round(soundingEnd./duration.*rowMotion)
  
  % Draw Raw Data (-9.81m/s^2)
  l1 = motion.Var1;
  l2 = motion.Var2;
  l3 = motion.Var3-9.81;
  l4 = motion.Var4;
  l5 = motion.Var5;
  l6 = motion.Var6;
  
  motion{1:(rowMotion/2),:}=2*motion{1:(rowMotion/2),:};
  
  
  figure;
  pspectrum(l2,motionFs,'spectrogram', ...
    'FrequencyLimits',[0 200],'TimeResolution',0.1)
  pause(.5);
  findall(gcf);
  motionSpec = findobj(gcf,'Type', 'Image');
  
  figure;
  figrow=2;
  figcol=2;
  subplot(figrow,figcol,1);
  xlim([0 6]);
  %   ylim([0 500]);
  ax = gca;
  copyobj(audioLine,ax);
  vline(soundingStart);
  vline(soundingEnd);
  xlabel('Time (s)', 'FontSize', fsize);
  ylabel('Sensor Reading', 'FontSize', fsize);
  set(gca, 'FontSize', fsize);
  title('a) Raw Audio Data');
  pause(1)
  
  subplot(figrow,figcol,2);
  hold on;
  xlim([0 6*motionFs]);
%   plot(l1, '-', 'color',color1, 'LineWidth', lwidth);
%   plot(l3, '-', 'color',color2,'LineWidth', lwidth);
%   plot(l2, '-', 'color',color3,'LineWidth', lwidth);
%   plot(l4, '-', 'color',color4,'LineWidth', lwidth*2);
%   plot(l5, '-', 'color',color5,'LineWidth', lwidth*2);
%   plot(l6, '-', 'color',color6,'LineWidth', lwidth*2);
  plot(l1, '-', 'LineWidth', lwidth);
  plot(l3, '-', 'LineWidth', lwidth);
  plot(l2, '-', 'LineWidth', lwidth);
  plot(l4, '-', 'LineWidth', lwidth*2);
  plot(l5, '-', 'LineWidth', lwidth*2);
  plot(l6, '-', 'LineWidth', lwidth*2);
  hold off;
  pause(1)
  vline(soundingStart.*motionFs);
  vline(soundingEnd.*motionFs);
  xticks([0 1*motionFs 2*motionFs 3*motionFs 4*motionFs 5*motionFs 6*motionFs])
  xticklabels({'0','1','2','3','4','5','6'})
  xlabel('Time (s)', 'FontSize', fsize);
  ylabel('Sensor Reading', 'FontSize', fsize);
  %   [lgd, hobj, ~, ~] =
  lgd = legend({'acc-x','acc-y','acc-z','gyro-x','gyro-y','gyro-z'},...
    'Location','southoutside','NumColumns', 6);
  %   findall(lgd)
  %   hl = findobj(hobj,'type','Line');
  %   set(hl,'LineWidth',3);
  %   lgd.NumColumns = 6;
  set(gca, 'FontSize', fsize);
  title('b) Raw Motion Data');
  pause(1)
  
  subplot(figrow,figcol,3);
  xlim([0 6]);
  ylim([0 4000]);
  ax = gca;
  copyobj(audioSpec,ax);
  audioSpec = findobj(gcf, 'Type','Image');
  audioSpec.YData = [1 4000];
  pause(.5)
  vline(soundingStart);
  vline(soundingEnd);
  xlabel('Time (s)', 'FontSize', fsize);
  ylabel('Frequency (Hz)', 'FontSize', fsize);
  set(gca, 'FontSize', fsize);
  title('c) Raw Audio Spectrogram')
  pause(1)
  
  subplot(figrow,figcol,4);
  xlim([0 6]);
  ylim([0 200]);
  ax = gca;
  copyobj(motionSpec,ax);
  pause(.5)
  vline(soundingStart);
  vline(soundingEnd);
  xlabel('Time (s)', 'FontSize', fsize);
  ylabel('Frequency (Hz)', 'FontSize', fsize);
  set(gca, 'FontSize', fsize);
  title('d) Raw Motion Spectrogram')
  pause(1)
  
  set(gcf, 'Color', 'w');
  % Maximze the window and save figures
  maximize;
  pause(1);
  
  export_fig(sprintf('DPSC%s', slimFileName),'-pdf');
  
  close all;
  
end


% autoArrangeFigures;
