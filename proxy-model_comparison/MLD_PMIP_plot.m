% plot recomputed MLD from PMIP models
clear
%addpath('/home/wuxiner/projects/rrg-pausata/wuxiner/m_map')
%cmap=load('CBR_coldhot.rgb')/255;
modelList={'ACCESS-ESM1-5' 'CESM2' 'EC-Earth3' 'EC-Earth3-LR' 'EC-Earth3-Veg' 'FGOALS-f3-L' 'FGOALS-g3' 'GISS-E2-1-G' 'INM-CM4-8' 'IPSL-CM6A-LR' 'MIROC-ES2L' 'MPI-ESM1-2-LR' 'MRI-ESM2-0' 'NESM3' 'NorESM2-LM'};
varname='mxl010';
fileP='./data/';
stats=readtable('./Stats/rmse.csv');
rmse=stats.RMSE;
kappa=stats.kappa;

figure('Position',[100,100,672,864]);
m_proj('Miller')
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
    nav_lon(nav_lon>180)=nav_lon(nav_lon>180)-360;
    % regrid for plotting
    regridData=griddata(nav_lon,nav_lat,fulldata,x,y,'linear'); 
    
    ax(i)=nexttile;
    h=m_pcolor(x,y,regridData);
    m_grid('tickdir','out','fontsize',5,'linest','none')
    %m_coast('patch',[.7 .7 .7],'edgecolor','none');
    title(modelList{i})
    clim([-500 500])
    text(0.98,0.001,['\kappa = ',sprintf('%.2f',kappa(i)),', RMSE = ', ...
        sprintf('%.2f',rmse(i)),' m'],'Units','normalized', ...
        'HorizontalAlignment','right','VerticalAlignment','bottom', ...
        'fontsize',7)
end
colormap(cmocean('balance'))
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
exportgraphics(fig,'./plots/formal/Fig1.pdf','ContentType','vector')
