startup;
folder = 'OkGoogleSingle';

plotsize=[0 0 0.5 0.6];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%TextGrid%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filePattern = fullfile(folder, '*.TextGrid');
files = dir(filePattern);
for k = 1 : length(files)
  fullFileName = fullfile(folder, files(k).name);
  slimFileName = erase(files(k).name, 'audio.wav.TextGrid');
  fprintf('Now processing file %s...\n', slimFileName);
  
  
  load(sprintf('%s.mat', fullfile(folder,slimFileName)));
  
  
  
  
  load TrainedNetwork4
  
  trainedNet = net;
  XVal = XTrain;
  YVal = YTrain;
  YValPred = classify(trainedNet,XVal);
  for i = 1:360
    YVal{1,1}(i)=categorical({'Ok Google'});
  end
  for i = 1:360
    YValPred{1,1}(i)=categorical({'Alexa'});
  end
  
 YValPred{1,1} = removecats(YValPred{1,1})
  YVal{1,1} = removecats(YVal{1,1})
  YValPred{1,1} = addcats(YValPred{1,1}, {'Hi Siri'});
  YVal{1,1} = addcats(YVal{1,1}, {'Hi Siri'});
  
  figure
  plot(YValPred{1,1},'-', 'LineWidth', lwidth,'MarkerSize', msize)
  hold on
  plot(YVal{1,1},'LineWidth', lwidth)
  hold off
  
  
  
  %   xticks([100 200 300 400]);
  %   xticklabels([100/motionFs 200/motionFs 300/motionFs 400/motionFs]);
  xlabel("Sample Index")
  ylabel("Command Classification")
  set(gca, 'FontSize', fsize);
  title("")
  [~, hobj, ~, ~] = legend(["Predicted" "Test Data"], 'Location', 'east');
  hl = findobj(hobj,'type','line');
  set(hl,'LineWidth',lwidth);
  
  
  
  
  set(gcf, 'Color', 'w');
  % Maximze the window and save figures
  set(gcf,'Unit', 'normalized','position',plotsize);
%   maximize;
  pause(1);
  
      export_fig(sprintf('nonmajority', slimFileName),'-pdf');
  %
  %   close all;
  
end


% autoArrangeFigures;
