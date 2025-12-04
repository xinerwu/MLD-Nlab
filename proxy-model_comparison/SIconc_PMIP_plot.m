% plot 15% sea ice extent
clear
modelList={'ACCESS-ESM1-5' 'CESM2' 'EC-Earth3' 'EC-Earth3-LR' 'EC-Earth3-Veg' 'FGOALS-f3-L' 'FGOALS-g3' 'GISS-E2-1-G' 'INM-CM4-8' 'IPSL-CM6A-LR' 'MIROC-ES2L' 'MPI-ESM1-2-LR' 'MRI-ESM2-0' 'NESM3' 'NorESM2-LM'};
varname='SImean';
fileP='./SIdata/';

figure('Position',[100,100,672,864]);
m_proj('Miller')
t=tiledlayout(5,3);
% create a standard grid for plotting
x=-180:0.5:180;
y=-90:0.5:90;
[y,x]=meshgrid(y,x);

% load data and plot (Jan-Mar average MLD)
for i=1:length(modelList)
    if strcmp(modelList{i},'FGOALS-f3-L')==0
    path=fileP;
    mhFile=[path,modelList{i},'_SIconc_MH.mat'];
    piFile=[path,modelList{i},'_SIconc_PI.mat'];

    load(mhFile,varname,'lon','lat')
    mhsi=SImean;
    load(piFile,varname)
    pisi=SImean;
    data=mhsi-pisi;
    N=mean(data(:,:,1:3),3); % mean winter anomalie in the Northern Hemisphere
    S=mean(data(:,:,7:9),3); % mean winter anomalie in the Southern Hemisphere
    fulldata=N;
    fulldata(lat<0)=S(lat<0);

    if isa(lon,"single")
        lon=double(lon);
        lat=double(lat);
    end
    lon(lon>180)=lon(lon>180)-360;
    %NorESM2-LM has NaNs in lon/lat
    idx=~isnan(lon);
    % regrid for plotting
    regridData=griddata(lon(idx),lat(idx),fulldata(idx),x,y,'linear'); 

    ax(i)=nexttile;
    h=m_pcolor(x,y,regridData);    
    m_grid('tickdir','out','fontsize',5,'linest','none');
    m_coast('patch',[1 1 1],'edgecolor','none');
    title(modelList{i})
    clim([-30 30])
    else
    % for FGOALS-f3-L, because PI siconc is not available
    ax(i)=nexttile;
    m_grid('tickdir','out','fontsize',5,'linest','none');
    m_coast('patch',[1 1 1],'edgecolor','k');
    title(modelList{i})
    end
end
cmap=cmocean('balance',256);
reversed_cmap=flipud(cmap);
colormap(reversed_cmap)
a=colorbar;
a.Label.String='(%)';
a.Layout.Tile='south';
t.Padding = 'compact';
t.TileSpacing = 'compact';

fig=gcf;
exportgraphics(fig,'./plots/winter-anom_SIconc.png')
