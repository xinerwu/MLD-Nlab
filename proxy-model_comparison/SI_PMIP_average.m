% Averaging recomputed MLD from PMIP models
% excluding 'FGOALS-f3-L', because PI siconc is not available
clear
modelList={'ACCESS-ESM1-5' 'CESM2' 'EC-Earth3' 'EC-Earth3-LR' 'EC-Earth3-Veg' 'FGOALS-g3' 'GISS-E2-1-G' 'INM-CM4-8' 'IPSL-CM6A-LR' 'MIROC-ES2L' 'MPI-ESM1-2-LR' 'MRI-ESM2-0' 'NESM3' 'NorESM2-LM'};
varname='SImean';
fileP='./SIdata/';

% create a 1-deg standard grid for averaging
x=-180:0.5:180;
y=-90:0.5:90;
[y,x]=meshgrid(y,x);

% load data and calculate average (Jan-Mar average in NH, Jul-Sep in SH)
allmodels=zeros(size(x,1),size(x,2),length(modelList));
for i=1:length(modelList)
    path=fileP;
    mhFile=[path,modelList{i},'_SIconc_MH.mat'];
    piFile=[path,modelList{i},'_SIconc_PI.mat'];
    load(mhFile,varname,"lon","lat")
    mh=SImean;
    load(piFile,varname)
    pi=SImean;
    %data=mh-pi;
    data=pi;
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
    allmodels(:,:,i)=regridData;
end
%meanmodels=mean(allmodels,3);
PImodels=mean(allmodels,3);
stdmodels=std(allmodels,0,3);
%save('SImean_models.mat')
save('SImean_models.mat','PImodels','-append')