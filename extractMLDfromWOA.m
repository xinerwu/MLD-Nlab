clear
excelfile='MLD_1981-2010.xlsx';
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
WOAlon=ncread('/lustre06/project/6004767/wuxiner/WOA/MLD/woa18_decav81B0_M0200_01.nc','lon');
WOAlat=ncread('/lustre06/project/6004767/wuxiner/WOA/MLD/woa18_decav81B0_M0200_01.nc','lat');
[oriLon,oriLat]=meshgrid(WOAlon,WOAlat);
oriLon=double(oriLon);
oriLat=double(oriLat);
% Loop through annual, montly, and seasonal data files
tardata=zeros(1968,17);
for i=1:17
    datafile=['woa18_decav81B0_M02',sprintf('%02d', i-1),'_01.nc'];
    oridata=squeeze(ncread(datafile,'M_an'));
    oridata=oridata';
    idx=find(~isnan(oridata));
    %tardata(:,i)=griddata(oriLon,oriLat,oridata,tarLon,tarLat,'nearest');
    F = scatteredInterpolant(oriLon(idx), oriLat(idx), oridata(idx), 'nearest', 'nearest');
    %F = griddedInterpolant(oriLon', oriLat', oridata', 'nearest', 'nearest');
    tardata(:,i)=F(tarLon,tarLat);
    %clear("datafile"); %clear("oridata")
end
tardataTable=array2table(tardata,'VariableNames',{'MLDann','MLD1','MLD2','MLD3','MLD4','MLD5','MLD6','MLD7','MLD8','MLD9','MLD10','MLD11','MLD12','MLDwin','MLDspr','MLDsum','MLDaut'});
writetable(tardataTable,excelfile)