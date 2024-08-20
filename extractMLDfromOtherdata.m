clear
excelfile='MLD_ref10m2023.xlsx';
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
datafile='MLD data/mld_dr003_ref10m_v2023.nc';
WOAlon=ncread(datafile,'lon');
WOAlat=ncread(datafile,'lat');
[oriLon,oriLat]=meshgrid(WOAlon,WOAlat);
oriLon=double(oriLon)';
oriLat=double(oriLat)';
% Loop through annual, montly, and seasonal data files
tardata=zeros(1968,12);
oridata=squeeze(ncread(datafile,'mld_dr003'));
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