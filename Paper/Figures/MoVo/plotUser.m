startup;
fsize=14;
set(0, 'defaultAxesFontSize', fsize);
set(0, 'defaultTextFontSize', fsize);

targets = [];
target = ones(1,15);
for i=1:20
    targets=[targets target*i];
end
targets=targets';

error = [0 3 0 0 1   1 0 1 2 1   0 0 0 1 2   0 0 4 0 1];
outputs = [];
for i=1:20
    for j = 1:error(i)
        outputs=[outputs randi(20)];
    end
    outputs=[outputs ones(1, 15-error(i))*i];
end
outputs=outputs';
% outputs = [2 2 2 3 3 ones(1,5*20-5) 1 1 1 3 3  ones(1,5*20-5)*2 1 2 2 2 2 2 2 2 2 ones(1,5*20-9)*3]';
% 281

C = confusionmat(targets,outputs);
C=C';

% plotconfusion(targets,outputs);
% figure;
% confusionchart(C);
nameCells = 1:20;


labels=nameCells;
% plotConfMat(C,labels,map,fsizew-6);
plotConfMat(C,labels);
axis square;
maximize;
pause(1);
export_fig('usermat','-pdf');

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