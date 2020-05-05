startup;

folder = 'syllable';


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
    
    pitchFileName = fullfile(folder, [slimFileName 'audio.wav.PitchTier']);
    pt = ptRead(pitchFileName);
    
    figure;
    ptPlot(pt); xlabel('Time (s)'); ylabel('Frequency (Hz)');
    
    
    intensityFileName = fullfile(folder, [slimFileName 'audio.wav.IntensityTier']);
    it = itRead(intensityFileName);
    
    figure;
    plot(it.t, it.i, 'ko')
    xlabel('Time (sec)'); ylabel('Intensity (dB)')
    
    %   break;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Audio%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Audio File
    audioFileName = fullfile(folder, [slimFileName 'audio.wav']);
    %   audioInfo = audioinfo(audioFileName)
    audio = miraudio(audioFileName)
    pause(.5);
    findall(gcf);
    audioLine = findobj(gcf,'Type', 'Line')
    
    
    
    [audioSig, audioFs] = audioread(audioFileName);
    
    %bandpass filter
    startFreq = 50;
    endFreq = 1000;
    audioSig = bandpass(audioSig, [startFreq endFreq], audioFs);
    
    figure;
    %   pspectrum(audioSig, audioFs,'spectrogram', ...
    %     'FrequencyLimits',[0 500],'TimeResolution',0.1)
    spectrogram(audioSig, 400, 200, 400, audioFs, 'yaxis')
    pause(.5);
    findall(gcf);
    audioSpec = findobj(gcf,'Type', 'Image')
    
    
    figure;
    figrow=2;
    figcol=1;
    
    subplot(figrow,figcol,1);
    ax = gca;
    copyobj(audioSpec,ax);
    hold on;
    pause(1)
    xlim([0 3]);
    ylim([0 1000]);
    yticks(0:200:1000);
    audioSpec = findobj(gcf, 'Type','Image');
    audioSpec.YData = [1 4000];
    ptPlot(pt);   %TODO change ptPlot about ylim
    %   set(pth, 'ylim', [0 1000]);
    vline(soundingStart);
    vline(soundingEnd);
    
    hvl = vline(syllabletime, 'b-');
    set(hvl, 'LineWidth', 5);
    colormap(cmocean('balance'));
    
    hold off;
    xlabel('Time (s)', 'FontSize', fsize);
    ylabel('Frequency (Hz)', 'FontSize', fsize);
    set(gca, 'FontSize', fsize);
    title('a) Spectrogram of Filtered Speech Signals')
    pause(1)
    
    subplot2 = subplot(figrow,figcol,2);
    plot(it.t, it.i, 'ko'); % k     black ; o     circle
    xlabel('Time (s)', 'FontSize', fsize);
    ylabel('Intensity (dB)', 'FontSize', fsize);
    vline(soundingStart);
    vline(soundingEnd);
    hvl = vline(syllabletime, 'b-');
    set(hvl, 'LineWidth', 5);
    
    set(gca, 'FontSize', fsize);
    title('b) Sound Intensity of Filtered Speech Signals')
    
    pause(1)
    text('Parent',subplot2,'FontSize',fsize,'String','Silent',...
        'Position',[0.35 50 0], 'BackgroundColor', 'w');
    text('Parent',subplot2,'FontSize',fsize,'String','Sounding',...
        'Position',[1.34 50 0], 'BackgroundColor', 'w');
    text('Parent',subplot2,'FontSize',fsize,'String','Silent',...
        'Position',[2.35 50 0], 'BackgroundColor', 'w');
    
    set(gcf, 'Color', 'w');
    
    % Maximze the window and save figures
    maximize;
    pause(1);
    
    %   export_fig(sprintf('syllable%s', slimFileName),'-pdf');
    %     figfilename=[folder slimFileName];
    figfilename=[folder];
    export_fig(figfilename,'-pdf');
    
    %   close all;
    
end


% autoArrangeFigures;
