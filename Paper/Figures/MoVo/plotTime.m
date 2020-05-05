startup;
fsize = fsize+2;
x = 1:8;
x = categorical(x);
accuracy = [281 274 234 220 187 169 174 158];
accuracy = accuracy./3;%%

accuracy2 = [281 274 282 284 289 288 283 286];
accuracy2 = accuracy2./3;%%


figure;
hold on;
plot(x, accuracy,'-*', 'LineWidth',lwidth,...
        'MarkerSize', msize);
plot(x, accuracy2,':o', 'LineWidth',lwidth,...
        'MarkerSize', msize);

hold off;

xlabel("Week")
ylabel("Successful Defend Percentage (%)")
legend('One Time','Learning','FontSize',fsizew,'Location','east');
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
%
 export_fig('time','-pdf');
 
 close all;