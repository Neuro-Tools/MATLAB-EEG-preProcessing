clear all;
close all;
clc;



[EEG] = doLoadBVData('Cognitive_Assessment_01.vhdr');

% not needed but here for demonstration purposes
% [EEG] = doRemoveChannels(EEG,{},EEG.chanlocs);

[EEG] = doRereference(EEG,{'AVERAGE'},{'ALL'},EEG.chanlocs);

[EEG] = doFilter(EEG,0.1,30,60,2,EEG.srate);

[icaEEG] = doICA(EEG,0);
doICAPlotComponents(EEG,25);
doICAPlotComponentLoadings(EEG,16,[8000 10000]);

componentsToRemove = [1];
[EEG] = doICARemoveComponents(EEG,componentsToRemove);

% not needed but here for demonstration purposes
% [EEG] = doInterpolate(EEG,EEG.chanlocs,'spherical');

[EEG] = doSegmentData(EEG,{'S202','S203'},[-200 800]);

[EEG] = doBaseline(EEG,[-200,0]);

[EEG] = doArtifactRejection(EEG,'Gradient',30);
[EEG] = doArtifactRejection(EEG,'Difference',150);

[EEG] = doRemoveEpochs(EEG,EEG.artifactPresent);

[ERP] = doERP(EEG,{'S202','S203'});

% plot the results, a P300 on Channel 52 (Pz)
figure;
plot(ERP.times,ERP.data(52,:,1),'LineWidth',3);
hold on;
plot(ERP.times,ERP.data(52,:,2),'LineWidth',3);
hold off;
title('Channel Pz');
ylabel('Voltage (uV)');
xlabel('Time (ms)');
