%% Plot residuals of reconstructions (MAT/WAPLS) and distribution on a map
clear
% load data
fileName1='coor1968.txt';
fileName2='residuals.xlsx';
dataTable1=readtable(fileName1,'Delimiter','\t','NumHeaderLines',1);
dataTable2=readtable(fileName2,'Sheet','Sheet1');
station=dataTable1.Var1;
lat=dataTable1.Var2;
lon=dataTable1.Var3;
resid=dataTable2.residuals_WAPLS;

% Sort the values
[~,idx]=sort(abs(resid),'descend');
resid=resid(idx);
lat=lat(idx);
lon=lon(idx);

% Define circle sizes based on the values and load colormap
circle_sizes = abs(resid)/100+3; % Adjust the scaling factor as needed
%circle_sizes = 5;
cmap=cmocean('balance');
clim=500;

% plot
figure;
set(gcf, 'Position', [100, 100, 850, 400]);
m_proj('Miller','lat',[-10 85])
m_coast('patch',[.7 .7 .7],'edgecolor','none');
%m_grid('linest','none','xticklabels',[],'xtick',[],'yticklabels',[],'ytick',[],'fontsize',5);
m_grid('tickdir','out','fontsize',5,'linest','none')

for i=1:1968
    if circle_sizes(i)>0
        cindex=fix((resid(i)-(-clim))/(clim-(-clim)) *length(cmap))+1;
        if isnan(cindex)==true
            continue
        end
        if cindex>256; cindex=256; elseif cindex<1; cindex=1; end
        h(i)=m_line(lon(i),lat(i),'marker','o','markersize',circle_sizes(i),'color','none','linest','none','markerfacecolor',cmap(cindex,:));
    end
end

% Add legend
%legend_cell = {'8%', '40%', '80%'};
legend_value=[-500,-100,-50,50,100,500];
for ii=1:length(legend_value)
    abs_diff=abs(resid-legend_value(ii));
    index_closest_value (ii) = find(abs_diff == min(abs_diff));
end
l=legend([h(index_closest_value(1)),h(index_closest_value(2)),h(index_closest_value(3)),h(index_closest_value(4)),h(index_closest_value(5)),h(index_closest_value(6))],'-500','-100','-50','+50', '+100', '+500','Location', 'southeast');
set(l,'Orientation','horizontal')
set(l,'FontSize',10) %this somehow put the dots in the legend into the correct size
f=gcf;
%exportgraphics(f,'./newFigs/S12wap.pdf','ContentType','vector')
exportgraphics(f,'./newFigs/S12wap.png')
%histogram(resid,'Normalization','pdf')
%exportgraphics(f,'./newFigs/S12wap-hist.png')
