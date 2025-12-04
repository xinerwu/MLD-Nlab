% Compute MLD using sigma theta (potential density) threshold (delta sigma theta = 0.03, reference depth = 10 m)
addpath('/lustre06/project/6019326/wuxiner/seawater/')
model='NESM3_';
YS=1798; YE=YS+99;
saveP='./mean/';
fileP='./MH/';
svar='so';
tvar='thetao';
lonvar='longitude';
latvar='latitude';
depvar='lev';
threshold=0.03;
filename=[saveP,model,sprintf('%04d',YS),'-',sprintf('%04d',YE),'_mld010_MH.nc']; %name for the output nc file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get file list and load grid info (lon, lat, depth)
sfileList=dir([fileP,svar,'_*.nc']);
tfileList=dir([fileP,tvar,'_*.nc']);
nav_lon=ncread([fileP,tfileList(1).name],lonvar);
nav_lat=ncread([fileP,tfileList(1).name],latvar);
deptht=ncread([fileP,tfileList(1).name],depvar);
ni=size(nav_lon,1); nj=size(nav_lon,2); nk=length(deptht); nt=(YE-YS+1)*12;
MLD=zeros(ni,nj,12,nt/12)+NaN;
time=zeros(1,nt);
yearC=1; % year counter
% find the index of the reference depth (closest to and larger than
% 10m)
kstart=find(deptht>=10, 1, 'first');

for l=1:numel(sfileList)
    sfile=[fileP,sfileList(l).name];
    tfile=strrep(sfile,svar,tvar);
    parts = split(sfile, '_');
    sYear=str2double(parts{7}(1:4)); % the starting year of each original data file
    eYear=str2double(parts{7}(8:11)); % the last year of the file
    if eYear<YS || sYear>YE
        % skip the current file
        disp([sfile,' is skipped'])
        disp([tfile,' is skipped'])
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

    fprintf('Reading data from file: %s\n', sfile);
    fprintf('Reading data from file: %s\n', tfile);

    for ii=Yrange
        mytime=ii*100+1:ii*100+12;
        % extract the months that we need
        Smonth=(ii-sYear)*12+1;
        temp=ncread(tfile,tvar,[1,1,1,Smonth],[ni,nj,nk,12]);
        sal=ncread(sfile,svar,[1,1,1,Smonth],[ni,nj,nk,12]);

        % find MLD in each cell column
        for i=1:ni
            for j=1:nj
                if ~isnan(sal(i,j,1,1))
                MLD(i,j,:,yearC)=getMLD(i,j,sal,temp,12,kstart,deptht,threshold);
                end
            end
        end
        disp(yearC)
        yearC=yearC+1; 
    end
end
        
% calculate average monthly MLD
MLDmean=mean(MLD,4);

% save to netcdf and .mat
ncid=netcdf.create(filename,'NETCDF4');
dimid(1)=netcdf.defDim(ncid,'i',ni);
dimid(2)=netcdf.defDim(ncid,'j',nj);
dimid(3)=netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));
varid(1)=netcdf.defVar(ncid,'lon','double',[dimid(1),dimid(2)]);
varid(2)=netcdf.defVar(ncid,'lat','double',[dimid(1),dimid(2)]);
varid(3)=netcdf.defVar(ncid,'time','double',dimid(3));
varid(4)=netcdf.defVar(ncid,'mxl010','float',[dimid(1),dimid(2),dimid(3)]);
netcdf.putAtt(ncid,varid(4),'long_name',"Mixed Layer Depth (dsigma = 0.03 wrt 10m) for the last 100 years");
netcdf.endDef(ncid)
netcdf.putVar(ncid,varid(1),nav_lon)
netcdf.putVar(ncid,varid(2),nav_lat)
netcdf.putVar(ncid,varid(3),0,nt,time)
netcdf.putVar(ncid,varid(4),MLD)
netcdf.close(ncid)

save([saveP,model,'MLD_MH.mat'])

function MLD=getMLD(i,j,sal,temp,nt,kstart,deptht,threshold)
    %pres=sw_pres(deptht,nav_lat(i,j)); %calculate pressure
    S=squeeze(sal(i,j,:,:));
    T=squeeze(temp(i,j,:,:));
    pden=sw_dens(S,T,0)-1000; %calculate potential density referenced to ocean surface
    
    % find the first depth that exceeds threshold
    MLD=zeros(1,nt);
    for t=1:nt
        bot=find(~isnan(S(:,1)), 1, 'last');
        pden_ref=interp1(deptht,pden(:,t),10,'linear');
        found=false;
        for k=kstart:bot
            dsigma=abs(pden_ref-pden(k,t));
            if dsigma>threshold
                MLD(t)=deptht(k);
                found=true;
                break;
            end
        end
        if ~found
            MLD(t)=deptht(bot);
        else
            % interpolate for an exact match
            if k-kstart>=1
                depseg=[deptht(k-1) deptht(k)];
                dsigmaseg=[abs(pden_ref-pden(k-1,t)) dsigma];
            else
                depseg=[10 deptht(k)];
                dsigmaseg=[0 dsigma];
            end
            MLD(t)=interp1(dsigmaseg,depseg,threshold,"linear");
        end
    end
end
