% Plot MLD extracted from LDv1 runs
clear
modelList={'HadCM3_uniform' 'HadCM3_routed' 'TraCE-21ka' 'MPI_Glac1D_P1' ...
    'MPI_Glac1D_P2' 'MPI_Glac1D_P3' 'MPI_Ice6G_P1' 'MPI_Ice6G_P2' 'MPI_Ice6G_P3'};
fileP='./LDdata/';

stats=readtable('./Stats/LDv1/rmse.csv');
rmse=stats.rmse;
kappa=stats.kappa;

% Import core list
corelist='C:/Users/wuxin/OneDrive - UQAM/PMIP-MLD_comparison/ListofCores_updated.xlsx';
cores=readtable(corelist);
coreName=cores.shortName;
Corelat=cores.Latitude;
Corelon=cores.Longitude;
anom_dino=cores.MLDannanomalie;

% Rearrange order for plotting
[~,idx]=sort(abs(anom_dino),'descend');
anom_dino=anom_dino(idx);
Corelon=Corelon(idx);
Corelat=Corelat(idx);

lim=500;
dotsize=4.5;
cmap=cmocean('balance',19);

figure('Position',[100,100,610,550]);
%m_proj('Miller')
m_proj('Lambert Conformal Conic','lat',[47 85],'long',[-65 15],'rect','on')
t=tiledlayout(3,3);
% create a standard grid for plotting
x=-180:0.5:180;
y=-90:0.5:90;
[y,x]=meshgrid(y,x);

% load data and plot (Jan-Mar average MLD)
fileList=dir([fileP,'*_MHPI.mat']);
counter=1;
for i=[2,1,9,3,4,5,6,7,8]
    ldFile=[fileP,fileList(i).name];
    load(ldFile,"MLDanom","nav_lon","nav_lat")
    nexttile;
    h=m_pcolor(nav_lon,nav_lat,MLDanom);
    hold on

    % Plot proxy data points
    for p=1:length(anom_dino)
        cindex=fix((anom_dino(p)-(-lim))/(lim-(-lim))*length(cmap))+1;
        if cindex>length(cmap)
            cindex=length(cmap);m_line(Corelon(p),Corelat(p),'marker','o','markersize',dotsize,'color','k','linest','none','markerfacecolor',cmap(cindex,:))
            %m_line(Corelon(i),Corelat(i),'marker','o','color','r','linewi',2,'linest','none','markerfacecolor','w')
        elseif cindex<1
            cindex=1;m_line(Corelon(p),Corelat(p),'marker','o','markersize',dotsize,'color','k','linest','none','markerfacecolor',cmap(cindex,:))
            %m_line(Corelon(i),Corelat(i),'marker','o','color','b','linewi',2,'linest','none','markerfacecolor','w')
        elseif ~isnan(cindex)==1
            m_line(Corelon(p),Corelat(p),'marker','o','markersize',dotsize,'color','k','linest','none','markerfacecolor',cmap(cindex,:))
        end
    end
    hold off
    m_grid('tickdir','out','fontsize',5,'linest','none','xtick',[-60 -30 0],'ytick',[45 55 65])
    %m_coast('patch',[.7 .7 .7],'edgecolor','none');
    title(modelList{counter},'Interpreter', 'none')
    clim([-lim lim])
    text(0.02,1,{['RMSE = ',sprintf('%.2f',rmse(counter)),' m'],['\kappa = ',sprintf('%.2f',kappa(counter)),]},'Units','normalized', ...
        'HorizontalAlignment','left','VerticalAlignment','top','fontsize',7)
    counter=counter+1;
end

colormap(cmap)
a=colorbar;
a.Label.String='m';
a.Label.FontSize=10;
a.Label.FontWeight="bold";
a.Label.HorizontalAlignment='center';
a.Label.Position=[0,2,0];
a.Layout.Tile='south';
t.Padding = 'compact';
t.TileSpacing = 'compact';

fig=gcf;
exportgraphics(fig,'./plots/revised/Fig7.pdf','ContentType','vector')
