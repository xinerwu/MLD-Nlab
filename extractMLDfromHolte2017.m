clear
excelfile='MLD_da_Holte.xlsx';
% Import site list (lon and lat)
fileName='coor1968.txt';
dataTable=readtable(fileName,'Delimiter','\t','NumHeaderLines',1);
station=dataTable.Var1;
lat=dataTable.Var2;
lon=dataTable.Var3;
tarLon=lon;
tarLat=lat;
%[tarLon,tarLat]=meshgrid(lon,lat);
% Get lon lat from WOA18 dataset
datafile='MLD data/Argo_mixedlayers_monthlyclim_04142022.mat';
load(datafile)
oriLon=lonm;
oriLat=latm;

% Loop through annual, montly, and seasonal data files
tardata=zeros(1968,12);
oridata=permute(mld_da_mean,[2 3 1]);
    %oridata=oridata';
    %mask=ncread(datafile,'mask'); %0=land,1=ocean
    %idx=find(mask==1); %not working because there are NaNs in the ocean!!
    %tardata(:,i)=griddata(oriLon,oriLat,oridata,tarLon,tarLat,'nearest');

for i=1:12
    month_oridata=oridata(:,:,i);
    idx=find(~isnan(month_oridata));
    F = scatteredInterpolant(oriLon(idx), oriLat(idx), month_oridata(idx), 'natural', 'nearest');
    %F = griddedInterpolant(oriLon', oriLat', oridata', 'nearest', 'nearest');
    tardata(:,i)=F(tarLon,tarLat);
    %clear("datafile"); %clear("oridata")
end
tardataTable=array2table(tardata,'VariableNames',{'MLD1','MLD2','MLD3','MLD4','MLD5','MLD6','MLD7','MLD8','MLD9','MLD10','MLD11','MLD12'});
writetable(tardataTable,excelfile)