% calculates mean sea ice concentration in a batch mode
clear
defvarname='siconc';
path='/lustre06/project/6004767/wuxiner/PMIP/';
modelList={'ACCESS-ESM1-5' 'CESM2' 'EC-Earth3' 'EC-Earth3-LR' 'EC-Earth3-Veg' 'FGOALS-f3-L' 'FGOALS-g3' 'GISS-E2-1-G' 'INM-CM4-8' 'IPSL-CM6A-LR' 'MIROC-ES2L' 'MPI-ESM1-2-LR' 'MRI-ESM2-0' 'NESM3' 'NorESM2-LM'};
saveP='/lustre06/project/6004767/wuxiner/PMIP/siconc_last100y/';

for i=10:length(modelList)
    meanP=[path,modelList{i},'/mean/'];
    fileP=[path,modelList{i},'/'];
    MHfiled=dir([meanP,'*mld010_MH.nc']);
    PIfiled=dir([meanP,'*mld010_PI.nc']);
    MHfile=MHfiled(1).name;
    PIfile=PIfiled(1).name;
    if strcmp(modelList{i},'GISS-E2-1-G')
    varname='siconca';
    else
    varname=defvarname;
    end
    twoDaverage(modelList{i},'MH',fileP,MHfile,varname,saveP);
    % siconc is not available from FGOALS-f3-L piControl experiment
    if strcmp(modelList{i},'FGOALS-f3-L')==0
    twoDaverage(modelList{i},'PI',fileP,PIfile,varname,saveP);
    end
end % end of loop through models

function twoDaverage(model,exp,fileP,sampleFile,varname,saveP)
switch exp
case 'MH'
	expName='midHolocene';
case 'PI'
	expName='piControl';
end

parts=split(sampleFile,'_');
YS=str2double(parts{2}(1:4));
YE=str2double(parts{2}(6:9));

fileList=dir([fileP,varname,'*',expName,'*']);
[lonvar, latvar]=identify_coords([fileP,fileList(1).name]);
lon=ncread([fileP,fileList(1).name],lonvar);
lat=ncread([fileP,fileList(1).name],latvar);
if size(lon,1)==1 || size(lon,2)==1
    % convert to mesh lon/lat
    [lat,lon]=meshgrid(lat,lon);
end
ni=size(lon,1); nj=size(lon,2); nt=(YE-YS+1)*12;
SIconc=zeros(ni,nj,12,nt/12)+NaN;

yearC=1;
for l=1:numel(fileList)
    ifile=[fileP,fileList(l).name];
    parts=split(ifile,'_');
    sYear=str2double(parts{7}(1:4));
    eYear=str2double(parts{7}(8:11));

    if eYear<YS || sYear>YE
        % skip the current file
        disp([ifile,' is skipped'])
        continue
    end

    if sYear<YS && eYear<=YE
        Yrange=YS:eYear;
    elseif sYear<YS && eYear>YE
        Yrange=YS:YE;
    elseif sYear>=YS && eYear<=YE
        Yrange=sYear:eYear;
    elseif sYear>=YS && eYear>YE
        Yrange=sYear:YE;
    else
        error('What happened???')
    end

    fprintf('Reading data from file: %s\n', ifile);
    
    for ii=Yrange
        Smonth=(ii-sYear)*12+1;
        SIconc(:,:,:,yearC)=ncread(ifile,varname,[1,1,Smonth],[ni,nj,12]);
        disp(yearC)
        yearC=yearC+1;
    end
end
SImean=mean(SIconc,4);
save([saveP,model,'_SIconc_',exp,'.mat'],'lon','lat','SIconc','SImean')
end

function [lon_name, lat_name] = identify_coords(filename)
    % Get netCDF file information
    info = ncinfo(filename);
    variables = {info.Variables.Name};
    
    % Identify longitude coordinate
    if any(strcmp(variables, 'lon'))
        lon_name = 'lon';
    elseif any(strcmp(variables, 'longitude'))
        lon_name = 'longitude';
    elseif any(strcmp(variables, 'nav_lon'))
        lon_name = 'nav_lon';
    else
        error('Longitude coordinate not found');
    end
    
    % Identify latitude coordinate
    if any(strcmp(variables, 'lat'))
        lat_name = 'lat';
    elseif any(strcmp(variables, 'latitude'))
        lat_name = 'latitude';
    elseif any(strcmp(variables, 'nav_lat'))
        lat_name = 'nav_lat';
    else
        error('Latitude coordinate not found');
    end
end
