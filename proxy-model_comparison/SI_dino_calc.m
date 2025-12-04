% Calculates anomalies from dinocyst reconstructions
% When there is no point in 5.5-6.5 ka, the closest point is taken
% Interpolate to get "baseline" values at core sites
% Load data
BDrecon='./mat/SIrecon.csv';
BDcoord='./mat/coor1968.txt';
corelist='C:/Users/wuxin/OneDrive - UQAM/PMIP-MLD_comparison/list of cores.xlsx';
BDdata=readtable(BDrecon).SIwin;
BDlon=readtable(BDcoord).Longitude;
BDlat=readtable(BDcoord).Latitude;
cores=readtable(corelist);
Corelat=cores.Latitude;
Corelon=cores.Longitude;
% Interpolate
Coredata=griddata(BDlon,BDlat,BDdata,Corelon,Corelat,'natural');
cores.SIbaseline=Coredata;

% Calculate the average of the 5.5-6.5 kyr bin
minAge=5.5; maxAge=6.5;
% Load data
path='./mat/SI-predictions/';
reconlist=dir([path,'*.csv']);
MH=zeros(length(Coredata),1)+NaN;
for i=1:length(reconlist)
    file=reconlist(i).name;
    record=readtable([path,file]);
    si1=record.SeaIce1;
    si2=record.SeaIce2;
    si3=record.SeaIce3;
    recon=(si1+si2+si3)/3;
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
cores.SImidHolocene=MH;
% Save data
writetable(cores,corelist)