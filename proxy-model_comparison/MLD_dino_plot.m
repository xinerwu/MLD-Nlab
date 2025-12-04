function MLD_dino_plot(ax)
% Plot model & data MLD anomalies
axes(ax);
% general plot settings
lim=250;
dotsize=6; % was 8 for single plot
cmap=cmocean('balance',15);
%figure;
%set(gcf, 'Position', [100, 100, 400, 440]);
m_proj('Lambert Conformal Conic','lat',[47 85],'long',[-65 15],'rect','on')

% Plot model anomalies as background
% load data
load("mean_models.mat","meanmodels","x","y")
h=m_pcolor(x,y,meanmodels);
hold on

% Plot dino anomalies
% load data
corelist='C:/Users/wuxin/OneDrive - UQAM/PMIP-MLD_comparison/list of cores.xlsx';
cores=readtable(corelist);
Corelat=cores.Latitude;
Corelon=cores.Longitude;
MH=cores.MLDmidHolocene;
baseline=cores.MLDbaseline;
anom_dino=MH-baseline; 

% Rearrange order for plotting
[~,idx]=sort(abs(anom_dino),'descend');
anom_dino=anom_dino(idx);
Corelon=Corelon(idx);
Corelat=Corelat(idx);

% Plot data points
for i=1:length(anom_dino)
    cindex=fix((anom_dino(i)-(-lim))/(lim-(-lim))*length(cmap))+1;
    if cindex>length(cmap)
        cindex=length(cmap);m_line(Corelon(i),Corelat(i),'marker','o','markersize',dotsize,'color','k','linest','none','markerfacecolor',cmap(cindex,:))
        %m_line(Corelon(i),Corelat(i),'marker','o','color','r','linewi',2,'linest','none','markerfacecolor','w')
    elseif cindex<1
        cindex=1;m_line(Corelon(i),Corelat(i),'marker','o','markersize',dotsize,'color','k','linest','none','markerfacecolor',cmap(cindex,:))
        %m_line(Corelon(i),Corelat(i),'marker','o','color','b','linewi',2,'linest','none','markerfacecolor','w')
    elseif ~isnan(cindex)==1
        m_line(Corelon(i),Corelat(i),'marker','o','markersize',dotsize,'color','k','linest','none','markerfacecolor',cmap(cindex,:))
    end
end
hold off

% General plot settings
m_grid('tickdir','out','fontsize',6,'linest','none');%('linest','none','xticklabels',[],'xtick',[],'yticklabels',[],'ytick',[],'fontsize',5); %('box','on','tickdir','in','ytick',(2|[0 40]));
m_coast('color','k');
colormap(ax,cmap);
clim([-lim lim]);
C=colorbar;
C.Location = "southoutside";
C.Title.String = 'MLD anomalies (m)';
C.Title.FontSize = 8;
C.FontSize = 6;
%fig=gcf;
%exportgraphics(fig, './plots/Fig3.pdf','ContentType','vector');
end