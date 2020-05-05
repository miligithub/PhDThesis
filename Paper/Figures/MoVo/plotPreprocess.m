startup;

startingFolder = 'DataV2/mili3/OkGoogleSingle';
folder = 'OkGoogleSingle';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%TextGrid%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filePattern = fullfile(folder, '*.TextGrid');
files = dir(filePattern);
for k = 1 : length(files)
  fullFileName = fullfile(folder, files(k).name);
  slimFileName = erase(files(k).name, 'audio.wav.TextGrid');
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
  
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Motion%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Motion File
  motionFileName = fullfile(folder, [slimFileName 'motion.txt']);
  motion = readtable(motionFileName);
  %   summary(motion)
  rowMotion = size(motion,1);
  colMotion = size(motion,2);
  
  motionFs = 400;
  motionExpect = duration*motionFs
  motionTrue = size(motion)
  motion(1:(motionTrue-motionExpect),:) = [];
  summary(motion)
  motionStart = round(soundingStart./duration.*rowMotion)
  motionEnd = round(soundingEnd./duration.*rowMotion)
  
  % Draw Raw Data (-9.81m/s^2)
  l1 = motion.Var1;
  l2 = motion.Var2-9.81;
  l3 = motion.Var3;
  l4 = motion.Var4;
  l5 = motion.Var5;
  l6 = motion.Var6;
  
  figure;
  pspectrum(l2,motionFs,'spectrogram', ...
    'FrequencyLimits',[0 200],'TimeResolution',0.1)
  pause(.5);
  findall(gcf);
  motionSpec = findobj(gcf,'Type', 'Image');
  
  % Preprocessing
  %   %highpass filter
  passFreq = 30;
  startFreq = passFreq;
  endFreq = motionFs/2;
  l1 = highpass(l1, passFreq, motionFs);
  l2 = highpass(l2, passFreq, motionFs);
  l3 = highpass(l3, passFreq, motionFs);
  l4 = highpass(l4, passFreq, motionFs);
  l5 = highpass(l5, passFreq, motionFs);
  l6 = highpass(l6, passFreq, motionFs);
  
  % plot spectrograms using mirtoolbox
  mirspectrum(miraudio(l2,motionFs),'Frame',.05,.5)
  findall(gcf);
  motionSpec2 = findobj(gcf,'Type', 'Surface');
  
  rawData = [l1 l2 l3 l4 l5 l6];
  %For RNN figure
  %   figure;
  %   motion.Var1 = l1;
  %   motion.Var2 = l2;
  %   motion.Var3 = l3;
  %   motion.Var4 = l4;
  %   motion.Var5 = l5;
  %   motion.Var6 = l6;
  %
  %
  %   [ha, pos] = tight_subplot(6,1,0);
  %
  %   for ii = 1:6
  %     tmpData = eval(sprintf('motion.Var%d',ii));
  %     tmpData = tmpData(200:210);
  %     tmpData = normalize(tmpData);
  %     axes(ha(ii));
  %
  %     plot(tmpData,'LineWidth',1);
  %
  %     grid(ha(ii), 'minor')
  %     set(gca, 'Color', 'none'); %transparent
  %
  %   end
  %   set(ha,'XTickLabel','','XTick', 1:10,'xlim',[1 10]);
  % %   set(ha(6),'XTickLabel',0:20:200,'FontSize', fsize)
  %   set(ha,'YTickLabel','','YTick', -2:1:2,'ylim',[-2 2]);
  %
  %
  %
  %
  %
  %
  %
  %   % Maximze the window and save figures
  %   maximize;
  %   pause(1);
  %
  %   export_fig('InputLayer','-pdf');
  %
  %   break;
  %*******************For RNN figure
  
  
  figure;
  figrow=3;
  figcol=2;
  
  subplot(figrow,figcol,1);
  xlim([0.1 2.7]);
  ylim([0 200]);
  ax = gca;
  copyobj(motionSpec,ax);
  pause(.5)
  vline(soundingStart);
  vline(soundingEnd);
  colormap(cmocean('balance'));
  xlabel('Time (s)', 'FontSize', fsize);
  ylabel('Frequency (Hz)', 'FontSize', fsize);
  set(gca, 'FontSize', fsize);
  title('a) Spectrogram of Raw Motion Signals', 'FontSize', fsize)
  pause(1)
  
  subplot(figrow,figcol,2);
  xlim([0.1 2.7]);
  ylim([0 200]);
  ax = gca;
  copyobj(motionSpec2,ax);
  pause(.5)
  vline(soundingStart);
  vline(soundingEnd);
%   colormap(cmocean('balance', 'pivot', 0.2));
  xlabel('Time (s)', 'FontSize', fsize);
  ylabel('Frequency (Hz)', 'FontSize', fsize);
  set(gca, 'FontSize', fsize);
  title('b) Spectrogram of Processed Motion Signals','FontSize', fsize);
  pause(1)
  
  subplot(figrow,figcol,[3, 4]);
  hold on;
  xlim([300 772]);
%   motionSyl = floor(syllabletime*motionFs);
%   ticks = [motionStart motionSyl motionEnd];
ticks = [310   367   470   555   636   752];
halfs = [367   470   555   636   752];
halfs = ticks(1:5) +  halfs;
halfs = halfs/2;
  xticks(ticks)
  xticklabels({'Sounding Start', 'Syllable 1', 'Syllable 2',...
    'Syllable 3', 'Syllable 4', 'Sounding End'});
  for j = 1:6
        plot(rawData(:,j), '-');
  end
  hold off;
  vline(ticks(1));
  vline(ticks(6));
  vline(halfs, 'g-.');
   hvl = vline(ticks(2:5), 'b-');
%   set(hvl, 'LineWidth', 3);
  xlabel("")
  ylabel("Sensor Reading")
  set(gca, 'FontSize', fsize);
  title('c) Motion Data Segementation','FontSize', fsize);
  legend({'acc-x','acc-y','acc-z','gyro-x','gyro-y','gyro-z'},...
    'Location','southoutside','NumColumns', 6);
  pause(1)
  
  
  
  
  load(sprintf('%s.mat', fullfile(folder,slimFileName)));
  for i = 80:120
    YTrain{1,1}(i)=categorical({'K'});
  end
  subplot(figrow,figcol,[5, 6]);
  xlim([0 360]);
  hold on
  
  lineStyle={':', '-.', '.', '-'};
  for i = [2 4]
    X = XTrain{1}(i, :);
    classes = categories(YTrain{1});
    for j = 1:numel(classes)
      label = classes(j);
      idx = find(YTrain{1} == label);
      plot(idx,X(idx),lineStyle{i}, 'LineWidth', lwidth*i/2);
%       , ...
%         'Color', eval(sprintf('color%d',j)));
    end
  end
  hold off
  %   xticks([100 200 300 400]);
  %   xticklabels([100/motionFs 200/motionFs 300/motionFs 400/motionFs]);
  xlabel("")
  ylabel("Sensor Reading")
  set(gca, 'FontSize', fsize);
  title("d) Motion Data Segementation Result",'FontSize', fsize);
  [~, hobj, ~, ~] = legend(classes,'Location','eastoutside');
  hl = findobj(hobj,'type','line');
  set(hl,'LineWidth',6,'LineStyle','-');
  
  
  
  
  set(gcf, 'Color', 'w');
  % Maximze the window and save figures
  maximize;
  pause(1);
  
    export_fig(sprintf('movopreprocess', slimFileName),'-pdf');
  %
  %   close all;
  
end


% autoArrangeFigures;
