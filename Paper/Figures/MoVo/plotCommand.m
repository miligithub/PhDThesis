startup;


myhexvalues = ['#fce584';'#d78a5a';'#203a30';];
myrgbvalues = hex2rgb(myhexvalues);

sizeRGB = size(myrgbvalues,1);
x = 0:1/(sizeRGB-1):1;

map = interp1(x,myrgbvalues,linspace(0,1,255));


google = ones(1,5*20);
targets=[ones(1,5*20) ones(1,5*20)*2 ones(1,5*20)*3]';
outputs = [2 2 3 ones(1,5*20-3) 1 1 3 3  ones(1,5*20-4)*2  2 2 2 2 ones(1,5*20-4)*3]';
% 281

C = confusionmat(targets,outputs);
C=C';

% plotconfusion(targets,outputs);
% figure;
% confusionchart(C);
nameCells = {'Ok Google', 'Hi Siri', 'Alexa'};


labels=nameCells;
plotConfMat(C,labels,map,fsizew);
% plotConfMat(C,labels);
axis square;
set(gca,'FontSize',fsizew);
set(gca,'Unit', 'normalized','OuterPosition',[0 0 0.4 0.4]);
set(gcf,'Color','w');

maximize;
pause(1);
export_fig('commandmat','-pdf');

close all;
% actual=cellstr(targets);
% predict=cellstr(outputs);
% actual=cell2mat(actual);
% predict=cell2mat(predict);
% [c_matrix,Result,RefereceResult]= confusion.getValues(C);
[Result,RefereceResult]=confusion.getValues(C);
fprintf('Accuracy: %.2f\\%% & \\hspace{-.55in} Error Rate: %.2f\\%% \\\\\n',...
    getfield(Result,'Accuracy')*100,...
    getfield(Result,'Error')*100);
fprintf('Precision: %.2f\\%% & \\hspace{-.55in} True Positive Rate (Sensitivity/Recall): %.2f\\%% \\\\\n',...
    getfield(Result,'Precision')*100,...
    getfield(Result,'Sensitivity')*100);
fprintf('$F_1$ Score: %.3f & \\hspace{-.55in} True Negative Rate (Specificity): %.2f\\%% \\\\\n',...
    getfield(Result,'F1_score'),...
    getfield(Result,'Specificity')*100);
fprintf('False Negative Rate: %.2f\\%%  & \\hspace{-.55in} False Positive Rate: %.2f\\%% \\\\\n',...
    (1-getfield(Result,'Sensitivity'))*100,...
    getfield(Result,'FalsePositiveRate')*100);


% Fields=['AccuracyOfSingle','Sensitivity', 'Specificity','Precision'];
% value1 = getfield(RefereceResult,'AccuracyOfSingle');
% value2 = getfield(RefereceResult,'Sensitivity');
% value3 = getfield(RefereceResult,'Specificity');
% value4 = getfield(RefereceResult,'Precision');
% 
% figure;
% hold on 
% for i=1:4
%     plot(eval(['value' num2str(i)]));
% end
% hold off;