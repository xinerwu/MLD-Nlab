% plot recomputed MLD from PMIP models
clear
%addpath('/home/wuxiner/projects/rrg-pausata/wuxiner/m_map')
%cmap=load('CBR_coldhot.rgb')/255;
modelList={'ACCESS-ESM1-5' 'CESM2' 'EC-Earth3' 'EC-Earth3-LR' 'EC-Earth3-Veg' 'FGOALS-f3-L' 'FGOALS-g3' 'GISS-E2-1-G' 'INM-CM4-8' 'IPSL-CM6A-LR' 'MIROC-ES2L' 'MPI-ESM1-2-LR' 'MRI-ESM2-0' 'NESM3' 'NorESM2-LM'};
varname='mxl010';
fileP='./data/';

% Define colors (7 from 'lines' + 8 additional distinct colors)
colors = [231 41 138; ...
    254 217 166; ...
    166 206 227; ... % Additional colors (e.g., from ColorBrewer or manual selection)
    31 120 180; ...
    178 223 138; ...
    51 160 44; ...
    251 154 153; ...
    227 26 28; ...
    253 191 111; ...
    255 127 0; ...
    202 178 214; ...
    106 61 154; ...
    102 194 165; ...
    23 190 207; ...
    177 89 40]/255; % Total 15 colors
% Define line styles
lineStyles = {'-', '--', '-.'}; % Solid, dashed, dotted, dash-dot

% define bins
nbins=180;
edges=linspace(-90,90,nbins+1);
centers=(edges(1:end-1)+edges(2:end))/2;

figure;
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
    
    %unique_lat=unique(nav_lat);
    zmean=zeros(nbins,1);
    for nb=1:nbins
        %idx=nav_lat==unique_lat(nb);
        idx=nav_lat>=edges(nb) & nav_lat<edges(nb+1);
        if any(idx,'all')
            zmean(nb)=mean(fulldata(idx),'omitnan');
        else
            zmean(nb)=NaN;
        end
    end
    % Cycle through line styles (4 styles, repeat every 4 series)
    style = lineStyles{mod(i-1, length(lineStyles))+1};
    plot(centers,zmean,'DisplayName',modelList{i},'Color',colors(i,:), ...
        'LineStyle',style,'LineWidth',1.5)
    hold on
end
legend('show','Location','eastoutside')
xlabel('Latitude')
ylabel('Winter MLD anomaly (MH-PI) (m)')
xlim([-90 90])
ax = gca;
ax.XDir = 'reverse';

exportgraphics(gcf,'./plots/formal/S5winter-anom_zmean.tiff','Resolution',300)
