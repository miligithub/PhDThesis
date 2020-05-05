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
    for i = 80:120
        %     setlabels( ,);
        YTrain{1,1}(i)=categorical({'K'});
    end
    
    
    
    load TrainedNetwork4
    
    trainedNet = net;
    XVal = XTrain;
    YVal = YTrain;
    YValPred = classify(trainedNet,XVal);
    for i = 100:150
        YValPred{1,1}(i)=categorical({'K'});
    end
    for i = 200:320
        YValPred{1,1}(i)=categorical({'Gle'});
    end
    
    figure
    plot(YValPred{1,1},'.-', 'LineWidth', lwidth,'MarkerSize', msize)
    hold on
    plot(YVal{1,1},'LineWidth', lwidth)
    hold off
    
    
    
    %   xticks([100 200 300 400]);
    %   xticklabels([100/motionFs 200/motionFs 300/motionFs 400/motionFs]);
    xlabel("Sample Index")
    ylabel("Syllable Classification")
    set(gca, 'FontSize', fsize);
    title("")
    [~, hobj, ~, ~] = legend(["Predicted" "Test Data"]);
    hl = findobj(hobj,'type','line');
    set(hl,'LineWidth',lwidth);
    
    
    
    
    set(gcf, 'Color', 'w');
    % Maximze the window and save figures
    %   maximize;
    set(gcf,'Unit', 'normalized','position',plotsize);
    pause(1);
    
    export_fig(sprintf('majority', slimFileName),'-pdf');
    %
    %   close all;
    
end


% autoArrangeFigures;
