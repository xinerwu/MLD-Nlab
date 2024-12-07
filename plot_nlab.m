%% Plot Nlab percentages and distribution on a map
clear
% load data
fileName1='coor1968.txt';
fileName2='dino1968.txt';
dataTable1=readtable(fileName1,'Delimiter','\t','NumHeaderLines',1);
dataTable2=readtable(fileName2,'Delimiter','\t','NumHeaderLines',1);
station=dataTable1.Var1;
lat=dataTable1.Var2;
lon=dataTable1.Var3;
Nlab=dataTable2.Var17;

% Define circle sizes based on the values and load colormap
circle_sizes = Nlab/100; % Adjust the scaling factor as needed
%circle_sizes = 5;
cmap=cmocean('algae');

% plot
figure;

set(gcf, 'Position', [100, 100, 850, 400]);
m_proj('Miller','lat',[-10 85])
m_coast('patch',[.7 .7 .7],'edgecolor','none');
%m_grid('linest','none','xticklabels',[],'xtick',[],'yticklabels',[],'ytick',[],'fontsize',5);
m_grid('tickdir','out','fontsize',5,'linest','none')
for i=1:1968
    if circle_sizes(i)>0
        cindex=fix(Nlab(i)/1000*length(cmap))+1;
        h(i)=m_line(lon(i),lat(i),'marker','o','markersize',circle_sizes(i)+3,'color','none','linest','none','markerfacecolor',cmap(cindex,:));
    end
end

% Add legend
%legend_cell = {'8%', '40%', '80%'};
legend_value=[80,400,800];
for ii=1:length(legend_value)
    abs_diff=abs(Nlab-legend_value(ii));
    index_closest_value (ii) = find(abs_diff == min(abs_diff));
end
l=legend([h(index_closest_value(1)),h(index_closest_value(2)),h(index_closest_value(3))],'8%', '40%', '80%','Location', 'southwest');
set(l,'FontSize',10) %this somehow put the dots in the legend into the correct size
f=gcf;
exportgraphics(f,'C:\Users\wuxin\OneDrive - UQAM\MLD-MAT\P&P\figs\fig2.pdf','ContentType','vector')