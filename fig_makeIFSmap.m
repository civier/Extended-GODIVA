%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  fig_makeIFSmap
%  ==============
%
%  Draws the utterance plan
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Usage: fig_makeIFSmap(plan)
%
%         plan - the utterance plan, e.g., 'g5.di.v@'
%
%  Author:  Jay Bohland
%  Date:    23/10/2006
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Z = fig_makeIFSmap(plan)

figure;
[Z,nil] = str2gradient(plan);

Z = Z(:,:,1);  % discard the repeated elements for now
map = flipud(hot(64));
colormap([1 1 1; map(10:42,:);]);
%colormap(flipud(hot));
%Z(1,1) = nan;
%Z(Z(:)==0) = nan;
subplot(2,1,1);
imagesc(Z');
%bar3(Z);

set(gca,'YTick',[0.5:1:7.5],'XTick',[0.5:1:53.5],'GridLineStyle','-', ...
    'XTickLabel',[],'YTickLabel',[],'XGrid','on','YGrid','on');
%axis off;

load IFS.mat;
cv = {'C','C','C','V','C','C','C'};

for i=1:53, 
    text(i,7.8,IFSp.symbol{i},'FontSize',8);
end;
for i=1:7,
    text(-0.8,i,cv{i},'FontSize',8);
end;

% DRAW ALL THE INELIGIBLE SLOTS

figure;

size(Z)
mx = max(Z);
for i=3:4,
    for j=1:53,
        if (Z(j,i) ~= mx(i)),
            %Z(j,i) = 0;
        end;
    end;
end;
bar3(Z);
set(gca,'ZLim',[0 2]); axis off;
view([20 10 10])
set(gcf,'color','k','InvertHardCopy','off');


