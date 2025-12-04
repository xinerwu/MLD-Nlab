% Averaging recomputed MLD from PMIP models
clear
modelList={'ACCESS-ESM1-5' 'CESM2' 'EC-Earth3' 'EC-Earth3-LR' 'EC-Earth3-Veg' 'FGOALS-f3-L' 'FGOALS-g3' 'GISS-E2-1-G' 'INM-CM4-8' 'IPSL-CM6A-LR' 'MIROC-ES2L' 'MPI-ESM1-2-LR' 'MRI-ESM2-0' 'NESM3' 'NorESM2-LM'};
varname='mxl010';
fileP='./data/';

% create a 1-deg standard grid for averaging
x=-180:0.5:180;
y=-90:0.5:90;
[y,x]=meshgrid(y,x);

% load data and calculate average (Jan-Mar average in NH, Jul-Sep in SH)
allmodels=zeros(size(x,1),size(x,2),length(modelList));
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
    allmodels(:,:,i)=regridData;
end
meanmodels=mean(allmodels,3);
stdmodels=std(allmodels,0,3);
save('mean_models.mat')