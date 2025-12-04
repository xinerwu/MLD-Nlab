% Compute regional averages of MLD in the Labrador Sea, the Irminger Sea,
% the Greenland Sea
% version 2.1: calculates on the original grids and make one tiled plot

% define regions
lab_lon=[-59, -56, -45, -45, -55,  -59];
lab_lat=[58,  55,  55,  59,  60,   58];
lab_lon=lab_lon(:);
lab_lat=lab_lat(:);

irm_lon=[-45, -40, -35, -39, -45, -45];
irm_lat=[55,  55,  60,  64,  59,  55];
irm_lon=irm_lon(:);
irm_lat=irm_lat(:);

gre_lon=[-10,  5,   5, -5 , -10];
gre_lat=[72,  72,  80,  80 , 72];
gre_lon=gre_lon(:);
gre_lat=gre_lat(:);

% calculate regional means
modelList={'ACCESS-ESM1-5' 'CESM2' 'EC-Earth3' 'EC-Earth3-LR' 'EC-Earth3-Veg' 'FGOALS-f3-L' 'FGOALS-g3' 'GISS-E2-1-G' 'INM-CM4-8' 'IPSL-CM6A-LR' 'MIROC-ES2L' 'MPI-ESM1-2-LR' 'MRI-ESM2-0' 'NESM3' 'NorESM2-LM'};
fileP='./data/';
labMH=zeros(12,length(modelList));
irmMH=labMH;
greMH=labMH;
labPI=labMH; irmPI=labMH; grePI=labMH;

for i=1:length(modelList)
    % load data
    path=fileP;
    mhFile=[path,modelList{i},'_MLD_MH.mat'];
    piFile=[path,modelList{i},'_MLD_PI.mat'];
    load(mhFile,"MLDmean","nav_lon","nav_lat")
    mh=MLDmean;
    load(piFile,"MLDmean")
    pi=MLDmean;
    if isa(nav_lon,"single")
        nav_lon=double(nav_lon);
        nav_lat=double(nav_lat);
    end
    nav_lon(nav_lon>180)=nav_lon(nav_lon>180)-360;
    
    % define masks
    lab_mask=inpolygon(nav_lon(:),nav_lat(:),lab_lon,lab_lat);
    lab_mask=reshape(lab_mask,size(nav_lon));
    irm_mask=inpolygon(nav_lon(:),nav_lat(:),irm_lon,irm_lat);
    irm_mask=reshape(irm_mask,size(nav_lon));
    gre_mask=inpolygon(nav_lon(:),nav_lat(:),gre_lon,gre_lat);
    gre_mask=reshape(gre_mask,size(nav_lon));

    for t=1:12
        tmpMH=mh(:,:,t);
        tmpPI=pi(:,:,t);
        % get regional means
        labMH(t,i)=mean(tmpMH(lab_mask),'omitnan');
        irmMH(t,i)=mean(tmpMH(irm_mask),'omitnan');
        greMH(t,i)=mean(tmpMH(gre_mask),'omitnan');
        labPI(t,i)=mean(tmpPI(lab_mask),'omitnan');
        irmPI(t,i)=mean(tmpPI(irm_mask),'omitnan');
        grePI(t,i)=mean(tmpPI(gre_mask),'omitnan');
    end
end
% calculate regional means from BM23 obs data
BMfile='../Mixed Layer Depth test/MLD data/mld_dr003_ref10m_v2023.nc';
lon=ncread(BMfile,'lon');
lat=ncread(BMfile,'lat');
[nav_lat,nav_lon]=meshgrid(lat,lon);
mld=ncread(BMfile,'mld_dr003');

% define masks
lab_mask=inpolygon(nav_lon(:),nav_lat(:),lab_lon,lab_lat);
lab_mask=reshape(lab_mask,size(nav_lon));
irm_mask=inpolygon(nav_lon(:),nav_lat(:),irm_lon,irm_lat);
irm_mask=reshape(irm_mask,size(nav_lon));
gre_mask=inpolygon(nav_lon(:),nav_lat(:),gre_lon,gre_lat);
gre_mask=reshape(gre_mask,size(nav_lon));

labBM=zeros(12,1);
irmBM=labBM;
greBM=labBM;

for t=1:12
    tmp=mld(:,:,t);
    labBM(t)=mean(tmp(lab_mask),'omitnan');
    irmBM(t)=mean(tmp(irm_mask),'omitnan');
    greBM(t)=mean(tmp(gre_mask),'omitnan');
end
%% plotting data
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

% Create tiled layout
fig=figure;
set(fig,'WindowStyle','normal');
set(fig,'Units','centimeters','OuterPosition',[1,1,18,20]);
tiledlayout(3,2,"TileSpacing","tight","Padding","loose")
p=1;
labelList={'a' 'd' 'b' 'e' 'c' 'f'};

maskList={'Labrador Sea' 'Irminger Sea' 'Greenland Sea'};
for nmask=1:3
    mask=maskList{nmask};
    switch mask
        case 'Labrador Sea'
            dataMH=labMH;
            dataPI=labPI;
            dataBM=labBM;
        case 'Irminger Sea'
            dataMH=irmMH;
            dataPI=irmPI;
            dataBM=irmBM;
        case 'Greenland Sea'
            dataMH=greMH;
            dataPI=grePI;
            dataBM=greBM;
    end
    
    ax(p)=nexttile;
    plot(1:12,dataBM,'DisplayName','Modern data','Color','k','LineWidth',1)
    hold on
    for i=1:length(modelList)
        % Cycle through line styles (4 styles, repeat every 4 series)
        style = lineStyles{mod(i-1, length(lineStyles))+1};
        %plot(1:12,dataMH(:,i),'-','DisplayName',modelList{i})
        plot(1:12,dataMH(:,i),'DisplayName',modelList{i},'Color', ...
            colors(i,:),'LineStyle',style,'LineWidth',1)
        hold on
    end
    title(['MH - ',mask],'FontSize',10)
    if nmask==3
        xlabel('Time (month)','FontSize',8)
    end
    ax(p).XAxis.FontSize=8;
    ylabel('MLD(m)','FontSize',8)
    ax(p).YAxis.FontSize=8;
    add_panel_label(ax(p),labelList{p})
    hold off
    p=p+1;
    %exportgraphics(gcf,['./plots/fig2/',mask,'MH.png'])
    
    ax(p)=nexttile;
    plot(1:12,dataBM,'DisplayName','Modern data','Color','k','LineWidth',1)
    hold on
    for i=1:length(modelList)
        %plot(1:12,dataPI(:,i),'--','DisplayName',modelList{i})
        style = lineStyles{mod(i-1, length(lineStyles))+1};
        plot(1:12,dataPI(:,i),'DisplayName',modelList{i},'Color', ...
            colors(i,:),'LineStyle',style,'LineWidth',1)
        hold on
    end
    title(['PI - ',mask],'FontSize',10)
    if nmask==1
        legend('show','Fontsize',6,'Color','none', ...
            'Location','bestoutside','IconColumnWidth',17)
    elseif nmask==3
        xlabel('Time (month)','FontSize',8)
    end
    ax(p).XAxis.FontSize=8;
    %ylabel('MLD(m)','FontSize',8)
    ax(p).YAxis.FontSize=8;
    add_panel_label(ax(p),labelList{p})
    hold off
    p=p+1;
    %exportgraphics(gcf,['./plots/fig2/',mask,'PI.png'])
end
exportgraphics(fig,'./plots/formal/Fig2.pdf','ContentType','vector');

function add_panel_label(ax, letter)
    text(ax, 0.02, 0.98, letter, ...
         'Units', 'normalized', ...
         'FontSize', 14, 'FontWeight', 'bold', ...
         'VerticalAlignment', 'top', ...
         'HorizontalAlignment', 'left', ...
         'BackgroundColor', 'white', ...     % optional: makes it readable on dark plots
         'EdgeColor', 'black', ...           % optional: thin black border
         'Margin', 2);
end
%% visualize masks
figure;
m_proj('Lambert Conformal Conic','lat',[47 85],'long',[-65 15],'rect','on')
h1=m_contour(x,y,lab_mask,[1 1]);
hold on
h2=m_contour(x,y,irm_mask,[1 1]);
h3=m_contour(x,y,gre_mask,[1 1]);
m_grid('tickdir','out','fontsize',5,'linest','none');
m_coast('patch',[1 1 1],'edgecolor','k');