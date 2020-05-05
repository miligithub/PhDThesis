startup;

fsizew=16;

label = {'Replay Attack','Voice Conversion',...
    'Replay Attack','Voice Conversion',...
    'Replay Attack','Voice Conversion',...
    'Replay Attack','Voice Conversion',...
    'Replay Attack','Voice Conversion',};
label = {'Simple Playback-Smartphone','Simple Playback Attack-Laptop','Simple Playback-Desktop', 'Mimicry Attack', 'Sophisticated Mimicry Attack'};
x = 1:5;
x = categorical(x);
accuracy = [295 298; 291 294; 284 296; 287 293; 281 291];
accuracy = accuracy./3;%%
hb = bar(x, accuracy,0.5,'FaceAlpha',1.0);
% Y=accuracy;
% y=reshape(Y',[1 10]);
% for i1=1:numel(y)
%     text(x(i1),y(i1),num2str(y(i1),'%0.2f'),...
%                'HorizontalAlignment','center',...
%                'VerticalAlignment','bottom')
% end
% box off
ylim([80 100]);
% hb(1,1).FaceAlpha = 1;
grid on
% figure;
% hold on
% for i = 1:length(x)
%     h=bar(x(i),accuracy(i));
%     if i < 4
%         set(h,'FaceColor',color6);
%     elseif i < 7
%         set(h,'FaceColor',color8);
%     end
% end
% hold off
set(gca,'xticklabel',label);
% xlabel("Attacking Type")
ylabel("Successful Defend Percentage (%)")
legend('replay attack','voice conversion','FontSize',fsizew,'Location','southeast');
set(gca, 'FontSize', fsize);


%   [~, hobj, ~, ~] = legend();
%   hl = findobj(hobj,'type','line');
%   set(hl,'LineWidth',lwidth);




set(gcf, 'Color', 'w');

% xlabel('x','Interpreter','latex');
% ylabel('y','Interpreter','latex');
% zlabel('z','Interpreter','latex');
% title(['$' latex(f) '$ for $x$ and $y$ in $[-2\pi,2\pi]$'],'Interpreter','latex')

% axis square;
set(gca,'FontSize',fsizew);
% set(gcf,'Color','w');
set(gca,'Unit', 'normalized','OuterPosition',[0 0 1 0.5]);


% Maximze the window and save figures
maximize;
pause(1);

 export_fig('defend','-pdf');
 
 close all;