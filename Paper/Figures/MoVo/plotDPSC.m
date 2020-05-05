startup;

% startingFolder = pwd;
% folder = uigetdir([startingFolder 'DPSC']);

folder ='DPSC';

plotsize=[0 0 0.6 0.2 ];
plotsizeFreq=[0 0 0.5 0.55 ];

% set(0, 'DefaultFigureColormap', cmocean('balance'));
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
    %     audio = miraudio(audioFileName)
    %     pause(.5);
    %     findall(gcf);
    %     audioLine = findobj(gcf,'Type', 'Line')
    
    
    [audioSig, audioFs] = audioread(audioFileName);
    figure;
    %     pspectrum(audioSig, audioFs,'spectrogram', ...
    %         'FrequencyLimits',[0 500],'TimeResolution',0.1)
    %     spectrogram(audioSig, 400, 200, 400, audioFs, 'yaxis');
    %     pause(.5);
    %     findall(gcf);
    %     audioSpec = findobj(gcf,'Type', 'Image')
    %     mirspectrum(audio,'Frame',.1,.05)
    %     pause(.5);
    %     findall(gcf);
    %     audioSpec = findobj(gcf,'Type', 'Surface');
    [s, f, t] = spectrogram(audioSig, 800, 500, 400, audioFs, 'yaxis');
    surf(t, f, 20*log10(abs(s)), 'EdgeColor', 'none');
    view([0 90]);
    colormap(cmocean('balance'));
    pause(1)
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    set(gcf,'Unit', 'normalized','position',plotsizeFreq);
    colorbar;
    pause(1);
    figfilename=[folder num2str(3)];
    export_fig(figfilename,'-pdf');
    
    
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
    rawData = [l1 l2 l3 l4 l5 l6];
    motion{1:(rowMotion/2),:}=2*motion{1:(rowMotion/2),:};
    
    
    figure;
    %     pspectrum(l2,motionFs,'spectrogram', ...
    %         'FrequencyLimits',[0 200],'TimeResolution',0.1)
    %     pause(.5);
    %     findall(gcf);
    %     motionSpec = findobj(gcf,'Type', 'Image');
    %     mirspectrum(miraudio(l2,motionFs),'Frame',.1,.05)
    %     pause(.5);
    %     findall(gcf);
    %     motionSpec = findobj(gcf,'Type', 'Surface');
    [s, f, t] = spectrogram(l2, 100, 80, 200, motionFs, 'yaxis');
    surf(t, f, 20*log10(abs(s)), 'EdgeColor', 'none');
    view([0 90]);
    pause(1)
    colormap(cmocean('balance'));
    colorbar;
    pause(1)
    xlabel('Time (s)');
    ylabel('Frequency (Hz)'); % );
    %     title('c. Spectrogram of Processed Motion Signals',...
    %         'FontWeight','normal');
    
    set(gcf,'Unit', 'normalized','position',plotsizeFreq);
    pause(1);
    
    figfilename=[folder num2str(4)];
    export_fig(figfilename,'-pdf');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%P%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%L%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%O%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%T%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fsize=20;
    set(0, 'defaultAxesFontSize', fsize);
    set(0, 'defaultTextFontSize', fsize);

    figure;
    plot(audioSig, '-');
    vline(soundingStart.*audioFs);
    vline(soundingEnd.*audioFs);
    xlabel("Sample Index");
    ylabel({'Sensor';'Reading'});
    set(gcf,'Unit', 'normalized','position',plotsize);
    pause(1);
    
    figfilename=[folder num2str(0)];
    export_fig(figfilename,'-pdf');
    
    figure;
    hold on;
    for j = 1:3
        plot(rawData(:,j), '-');
    end
    hold off;
    %     xlim([1 rowMotion]);
    vline(soundingStart.*motionFs);
    vline(soundingEnd.*motionFs);
    ylabel({'Sensor';'Reading'});
    legend({'acc-x','acc-y','acc-z'},...
        'Location','northeast');
    
    
    set(gcf,'Unit', 'normalized','position',plotsize);
    pause(1);
    
    figfilename=[folder num2str(1)];
    export_fig(figfilename,'-pdf');
    
    
    figure;
    hold on;
    for j = 4:6
        plot(rawData(:,j), '-');
    end
    hold off;
    %     xlim([1 rowMotion]);
    vline(soundingStart.*motionFs);
    vline(soundingEnd.*motionFs);
    xlabel("Sample Index");
    ylabel({'Sensor';'Reading'});
    legend({'gyro-x','gyro-y','gyro-z'},...
        'Location','northeast');
    
    
    set(gcf,'Unit', 'normalized','position',plotsize);
    pause(1);
    
    figfilename=[folder num2str(2)];
    export_fig(figfilename,'-pdf');
    
    close all;
    
end


% autoArrangeFigures;
