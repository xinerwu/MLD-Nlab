% plot recomputed MLD from PMIP models
clear
%addpath('/home/wuxiner/projects/rrg-pausata/wuxiner/m_map')

%modelList={'ACCESS-ESM1-5' 'CESM2' 'EC-Earth3' 'EC-Earth3-LR' 'EC-Earth3-Veg' 'FGOALS-f3-L' 'FGOALS-g3' 'GISS-E2-1-G' 'INM-CM4-8' 'IPSL-CM6A-LR' 'MIROC-ES2L' 'MPI-ESM1-2-LR' 'MRI-ESM2-0' 'NESM3' 'NorESM2-LM'};
modelList={'bcc-csm1-1' 'CNRM-CM5' 'CSIRO-Mk3L-1-2' 'FGOALS-g2' 'FGOALS-s2' 'GISS-E2-R' 'HadGEM2-CC' 'HadGEM2-ES' 'IPSL-CM5A-LR' 'KCM1-2-2' 'MIROC-ESM' 'MPI-ESM-P' 'MRI-CGCM3'};
varname='mxl010';
%fileP='./data/';
fileP='./PMIP3data/';
%stats=readtable('./Stats/MLDpmip4/rmse.csv');
stats=readtable('./Stats/MLDpmip3/rmse.csv');
rmse=stats.rmse;
%kappa=stats.kappa;
kappa=zeros(size(rmse));

% Plot dino anomalies
% load data
corelist='C:/Users/wuxin/OneDrive - UQAM/PMIP-MLD_comparison/ListofCores_updated.xlsx';
cores=readtable(corelist);
Corelat=cores.Latitude;
Corelon=cores.Longitude;
anom_dino=cores.MLDanomalie; 

% Rearrange order for plotting
[~,idx]=sort(abs(anom_dino),'descend');
anom_dino=anom_dino(idx);
Corelon=Corelon(idx);
Corelat=Corelat(idx);

lim=500;
dotsize=4.5;
cmap=cmocean('balance',19);

figure('Position',[100,100,610,864]);
%m_proj('Miller')
m_proj('Lambert Conformal Conic','lat',[47 85],'long',[-65 15],'rect','on')
t=tiledlayout(5,3);
% create a standard grid for plotting
x=-180:0.5:180;
y=-90:0.5:90;
[y,x]=meshgrid(y,x);

% load data and plot (Jan-Mar average MLD)
for i=1:length(modelList)
    path=fileP;
    mhFile=[path,modelList{i},'_MLD_MH.mat'];
    piFile=[path,modelList{i},'_MLD_PI.mat'];
    load(mhFile,"MLDmean","nav_lon","nav_lat","ni","nj")
    mh=MLDmean;
    load(piFile,"MLDmean")
    pi=MLDmean;
    data=mh-pi;
    N=mean(data(:,:,1:3),3); % mean winter anomalie in the Northern Hemisphere
    S=mean(data(:,:,7:9),3); % mean winter anomalie in the Southern Hemisphere
    fulldata=N;
    fulldata(nav_lat<0)=S(nav_lat<0);

    if isa(nav_lon,"single")
        nav_lon=double(nav_lon);
        nav_lat=double(nav_lat);
    end
    if strcmp(modelList{i},'KCM1-2-2')==1
        nav_lon=nav_lon-180;
    end
    nav_lon(nav_lon>180)=nav_lon(nav_lon>180)-360;
    % regrid for plotting
    regridData=griddata(nav_lon,nav_lat,fulldata,x,y,'linear'); 
    
    ax(i)=nexttile;
    h=m_pcolor(x,y,regridData);
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
    title(modelList{i})
    clim([-lim lim])
    text(0.02,1,{['RMSE = ',sprintf('%.2f',rmse(i)),' m'],['\kappa = ',sprintf('%.2f',kappa(i)),]},'Units','normalized', ...
        'HorizontalAlignment','left','VerticalAlignment','top','fontsize',7)
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
exportgraphics(fig,'./plots/revised/Fig1pmip3.pdf','ContentType','vector')
