% creates paired observations for data-model agreement metrics
% 1) assign each dinocyst records to the nearest grid-cell for each model
% 2) binarize anomaly data (larger MLD vs. smaller MLD) for Cohen's kappa
% also calculates RMSE; Cohen's kappa is done in R

clear
modelList={'ACCESS-ESM1-5' 'CESM2' 'EC-Earth3' 'EC-Earth3-LR' 'EC-Earth3-Veg' 'FGOALS-f3-L' 'FGOALS-g3' 'GISS-E2-1-G' 'INM-CM4-8' 'IPSL-CM6A-LR' 'MIROC-ES2L' 'MPI-ESM1-2-LR' 'MRI-ESM2-0' 'NESM3' 'NorESM2-LM'};
fileP='./data/';

% load dinocyst data
corelist='C:/Users/wuxin/OneDrive - UQAM/PMIP-MLD_comparison/list of cores.xlsx';
cores=readtable(corelist);
Corelat=cores.Latitude;
Corelon=cores.Longitude;
MH=cores.MLDmidHolocene;
baseline=cores.MLDbaseline;
anom_dino=MH-baseline;
binary_dino=anom_dino>=0; %or >= 0? also check distance from nearest point

% preallocate statistic metric arrays
rmse=zeros(length(modelList),1);
spearman_rho=zeros(length(modelList),1);
spearman_pval=zeros(length(modelList),1);

% load model data and assign value (Jan-Mar average MLD)
anom_model=zeros(length(anom_dino),length(modelList))+NaN;
for i=1:length(modelList)
    path=fileP;
    mhFile=[path,modelList{i},'_MLD_MH.mat'];
    piFile=[path,modelList{i},'_MLD_PI.mat'];
    load(mhFile,"MLDmean","nav_lon","nav_lat")
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
    anom_model(:,i)=griddata(nav_lon,nav_lat,fulldata,Corelon,Corelat,'nearest');
    rmse(i)=sqrt( mean( (anom_model(:,i)-anom_dino).^2 ) );
    [spearman_rho(i),spearman_pval(i)]=corr(anom_dino,anom_model(:,i),'Type','Spearman');
end

% save to csv files
%spearman_table=table(spearman_rho,spearman_pval,'RowNames',modelList);
%writetable(spearman_table,'./Stats/SpearmanCorr.csv','WriteRowNames',true)

binary_model=anom_model>=0;
dino_table=table(binary_dino);
%writetable(dino_table,'./Stats/binary_dino_anom.csv')
model_table=table(binary_model);
%writetable(model_table,'./Stats/binary_model_anom.csv')

% check distance
%[~, dist] = knnsearch([Corelon(:), Corelat(:)], [nav_lon(:), nav_lat(:)]);
%fprintf('Max distance to nearest observation: %.2f\n', max(dist));