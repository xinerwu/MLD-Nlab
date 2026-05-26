% Calculates anomalies from dinocyst reconstructions
% When there is no point in 5.5-6.5 ka, the closest point is taken
% Interpolate to get "baseline" values at core sites
% Load data
BDrecon='./mat/BM23recon.csv';
BDcoord='./mat/coor1968_DupCleaned.txt';
corelist='C:/Users/wuxin/OneDrive - UQAM/PMIP-MLD_comparison/ListofCores_updated.xlsx';
BDdata=readtable(BDrecon).MLDwin;
BDann=readtable(BDrecon).MLDann;
BDlon=readtable(BDcoord).Longitude;
BDlat=readtable(BDcoord).Latitude;
cores=readtable(corelist);
Corelat=cores.Latitude;
Corelon=cores.Longitude;
% Interpolate
Coredata=griddata(BDlon,BDlat,BDdata,Corelon,Corelat,'natural');
cores.MLDbaseline=Coredata;
Coreann=griddata(BDlon,BDlat,BDann,Corelon,Corelat,'natural');
cores.MLDannbaseline=Coreann;

% Calculate the average of the 5.5-6.5 kyr bin
minAge=5.5; maxAge=6.5;
% Load data
path='./mat/predictions/';
reconlist=dir([path,'*.csv']);
MH=zeros(length(Coredata),1)+NaN;
for i=1:length(reconlist)
    file=reconlist(i).name;
    record=readtable([path,file]);
    recon=record.MLDwin;
    age=record{:,1};
    idx=find(age>=minAge & age<=maxAge);
    if isempty(idx)
        [~,idx]=min(abs(age-6));
        closestVal=age(idx);
        disp(file); disp(closestVal)
    end
    sixka=mean(recon(idx));
    corename=extractBefore(file,"_");
    tableidx=find(contains(cores.shortName,corename));
    MH(tableidx)=sixka;
end
cores.MLDmidHolocene=MH;
cores.MLDanomalie=cores.MLDmidHolocene-cores.MLDbaseline;

% Calculate the maximum of the 5.5-6.5 kyr bin
MH_max=zeros(length(Coredata),1)+NaN;
for i=1:length(reconlist)
    file=reconlist(i).name;
    record=readtable([path,file]);
    recon=record.MLDwin;
    age=record{:,1};
    idx=find(age>=minAge & age<=maxAge);
    if isempty(idx)
        [~,idx]=min(abs(age-6));
        closestVal=age(idx);
        disp(file); disp(closestVal)
    end
    sixka_max=max(recon(idx));
    corename=extractBefore(file,"_");
    tableidx=find(contains(cores.shortName,corename));
    MH_max(tableidx)=sixka_max;
end
cores.MLDmidHolocene_max=MH_max;

% Calculate the average of the 5.5-6.5 kyr bin for annual MLD
minAge=5.5; maxAge=6.5;
% Load data
path='./mat/predictions/';
reconlist=dir([path,'*.csv']);
MH=zeros(length(Coreann),1)+NaN;
for i=1:length(reconlist)
    file=reconlist(i).name;
    record=readtable([path,file]);
    recon=record.MLDann;
    age=record{:,1};
    idx=find(age>=minAge & age<=maxAge);
    if isempty(idx)
        [~,idx]=min(abs(age-6));
        closestVal=age(idx);
        disp(file); disp(closestVal)
    end
    sixka=mean(recon(idx));
    corename=extractBefore(file,"_");
    tableidx=find(contains(cores.shortName,corename));
    MH(tableidx)=sixka;
end
cores.MLDannmidHolocene=MH;
cores.MLDannanomalie=cores.MLDannmidHolocene-cores.MLDannbaseline;

% Save data
writetable(cores,corelist)