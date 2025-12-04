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
    path=fileP;
    mhFile=[path,modelList{i},'_SIconc_MH.mat'];
    piFile=[path,modelList{i},'_SIconc_PI.mat'];

    %mh data
    load(mhFile,varname,'lon','lat')
    mhsi=SImean;

    N=mean(mhsi(:,:,1:3),3); % mean winter anomalie in the Northern Hemisphere
    S=mean(mhsi(:,:,7:9),3); % mean winter anomalie in the Southern Hemisphere
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
    m_contour(x,y,regridData,[15 15],'-','LineWidth',1.5)
    hold on
    
    if strcmp(modelList{i},'FGOALS-f3-L')==0
    %pi data
    load(piFile,varname)
    pisi=SImean;

    N=mean(pisi(:,:,1:3),3); % mean winter anomalie in the Northern Hemisphere
    S=mean(pisi(:,:,7:9),3); % mean winter anomalie in the Southern Hemisphere
    fulldata=N;
    fulldata(lat<0)=S(lat<0);
    lon(lon>180)=lon(lon>180)-360;
    % regrid for plotting
    regridData=griddata(lon(idx),lat(idx),fulldata(idx),x,y,'linear'); 

    m_contour(x,y,regridData,[15 15],':k','LineWidth',1)
    end
    m_grid('tickdir','out','fontsize',5,'linest','none');
    m_coast('patch',[.7 .7 .7],'edgecolor','none');
    title(modelList{i})
    hold off
end
t.Padding = 'compact';
t.TileSpacing = 'compact';

fig=gcf;
exportgraphics(fig,'./plots/formal/FigS3.png')
