% Plot MLD fields from WOA18 datasets
%clear
% define data and figure
fileName={'woa18_decav81B0_M0213_01.nc','woa18_A5B7_M0213_01.nc'};
subtitle={'a      Winter (Jan-Mar) MLD 1981-2010','b      Winter (Jan-Mar) MLD 2005-2017','c      Winter (Jan-Mar) MLD 1970-2021','d      Winter (Jan-Mar) MLD 2000-2021'};
lonvar='lon';
latvar='lat';
varname='M_an';
figure;
set(gcf,'Units','inches', 'Position', [1, 1, 7, 4.8]);
m_proj('Miller')
m_coast('patch',[.7 .7 .7],'edgecolor','none');
t=tiledlayout(2,2);

% load and plot
for i=1:length(fileName)
    data=ncread(fileName{i},varname);
    lon=ncread(fileName{i},lonvar);
    lat=ncread(fileName{i},latvar);
    [lonmesh, latmesh]=meshgrid(lon,lat);
    vartitle = ncreadatt(fileName{i}, '/', 'title');
    disp(vartitle)
    %subtitle=input('Enter a string for subtitle:');
    disp(['Subtitle is: ',subtitle{i}])
    %ax(i)=subplot(2,2,i);
    ax(i)=nexttile;
    h=m_pcolor(lonmesh,latmesh,data');
    %m_grid('linest','none','xticklabels',[],'xtick',[],'yticklabels',[],'ytick',[],'fontsize',5);
    m_grid('tickdir','out','fontsize',5,'linest','none')
    title(subtitle{i})
    caxis([0 1550])
end
for i=3
    load('deBM2023.mat')
    ax(i)=nexttile;
    h=m_pcolor(oriLon,oriLat,MLDwin);
    %m_grid('linest','none','xticklabels',[],'xtick',[],'yticklabels',[],'ytick',[],'fontsize',5);
    m_grid('tickdir','out','fontsize',5,'linest','none')
    title(subtitle{i})
    caxis([0 1550])
end
for i=4
    load('Holte2017.mat')
    ax(i)=nexttile;
    h=m_pcolor(lonm,latm,MLDwin);
    %m_grid('linest','none','xticklabels',[],'xtick',[],'yticklabels',[],'ytick',[],'fontsize',5);
    m_grid('tickdir','out','fontsize',5,'linest','none')
    title(subtitle{i})
    caxis([0 1550])
end

colormap(cmocean('deep'))
a=colorbar;
a.Label.String='(m)';
a.Label.Position=[2, 1600, 0];
a.Label.Rotation=0;
a.Layout.Tile='east';

t.Padding = 'compact';
t.TileSpacing = 'compact';

f=gcf;
exportgraphics(f,'C:\Users\wuxin\OneDrive - UQAM\MLD-MAT\P&P\figs\fig1.pdf','ContentType','vector')