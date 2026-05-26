% Plot and compare time series of MLD (winter and annual means) from
% reconstruction and deglaciation simulations
% 12-0 ka BP

% Define groups for the cores sites
gr1={'P4','P21','P13','MD27'};
%gr2={'P94'};
%gr3={'TW85'};
%gr4={'P72','MD54','P80'};
gr234={'P94','TW85','P72','MD54','P80'};
gr5={'G1','HM25'};
gr6={'GIK1','PS47','PS43','PS42','M71','M11','HM43','M62','M80','PS30',...
    'M52'};
gr7={'MSM2','PS63'};
groups={gr1,gr234,gr5,gr6,gr7};

% Import core list
corelist='C:/Users/wuxin/OneDrive - UQAM/PMIP-MLD_comparison/ListofCores_updated.xlsx';
cores=readtable(corelist);
coreName=cores.shortName;
Corelat=cores.Latitude;
Corelon=cores.Longitude;
nc=length(coreName);
anom_dino=cores.MLDannanomalie;

% Import baseline values (ref value for anomaly)
BDrecon='./mat/BM23recon.csv';
BDcoord='./mat/coor1968_DupCleaned.txt';
BDdata=readtable(BDrecon).MLDann;
BDlon=readtable(BDcoord).Longitude;
BDlat=readtable(BDcoord).Latitude;
coreRef=griddata(BDlon,BDlat,BDdata,Corelon,Corelat,'natural');

% Import reconstruction list
path='./mat/predictions/';
reconlist=dir([path,'*.csv']);
reconlegend='Reconstruction';

% Import model data and calculate centennial means for plotting
% Reference for anomaly = average of last 100 years
load('LDdata/HadCM3_routed.mat','MLD','YSbp','YEbp','freq')
MLD=reshape(MLD(1:end-1,:),100*freq,[],nc);
MLD=squeeze(mean(MLD,1));
ref=MLD(end,:);
HadCM3_routed=MLD;
HadCM3_routed_anom=MLD-ref;
load('LDdata/HadCM3_uniform.mat','MLD')
MLD=reshape(MLD(1:end-1,:),100*freq,[],nc);
MLD=squeeze(mean(MLD,1));
ref=MLD(end,:);
HadCM3_uniform=MLD;
HadCM3_uniform_anom=MLD-ref;
year_HadCM3=YSbp:1/freq:YEbp;
cent_HadCM3=reshape(year_HadCM3(1:end-1),100*freq,[]);
cent_HadCM3=mean(cent_HadCM3,1)/1000; % convert to ka

load('LDdata/trace21ka.mat','MLD','YSbp','YEbp','freq')
MLD=reshape(MLD(1:end-1,:),100*freq,[],nc);
MLD=squeeze(mean(MLD,1));
ref=MLD(end,:);
trace21ka=MLD;
trace21ka_anom=MLD-ref;
dec_trace21ka=YSbp:1/freq:YEbp;
cent_trace21ka=reshape(dec_trace21ka(1:end-1),100*freq,[]);
cent_trace21ka=mean(cent_trace21ka,1)/1000; % convert to ka

load('LDdata/MPI-ESM1-2-CRtransient-deglaciation-prescribed-glac1dr1i1p1f1.mat','MLD','YSbp','YEbp','freq')
MLD=reshape(MLD,100*freq,[],nc);
MLD=squeeze(mean(MLD,1));
ref=MLD(end,:);
MPI_glac111=MLD;
MPI_glac111_anom=MLD-ref;
load('LDdata/MPI-ESM1-2-CRtransient-deglaciation-prescribed-glac1dr1i1p2f2.mat','MLD')
MLD=reshape(MLD,100*freq,[],nc);
MLD=squeeze(mean(MLD,1));
ref=MLD(end,:);
MPI_glac122=MLD;
MPI_glac122_anom=MLD-ref;
load('LDdata/MPI-ESM1-2-CRtransient-deglaciation-prescribed-glac1dr1i1p3f2.mat','MLD')
MLD=reshape(MLD,100*freq,[],nc);
MLD=squeeze(mean(MLD,1));
ref=MLD(end,:);
MPI_glac132=MLD;
MPI_glac132_anom=MLD-ref;
load('LDdata/MPI-ESM1-2-CRtransient-deglaciation-prescribed-ice6gr1i1p1f1.mat','MLD')
MLD=reshape(MLD,100*freq,[],nc);
MLD=squeeze(mean(MLD,1));
ref=MLD(end,:);
MPI_ice111=MLD;
MPI_ice111_anom=MLD-ref;
load('LDdata/MPI-ESM1-2-CRtransient-deglaciation-prescribed-ice6gr1i1p2f2.mat','MLD')
MLD=reshape(MLD,100*freq,[],nc);
MLD=squeeze(mean(MLD,1));
ref=MLD(end,:);
MPI_ice122=MLD;
MPI_ice122_anom=MLD-ref;
load('LDdata/MPI-ESM1-2-CRtransient-deglaciation-prescribed-ice6gr1i1p3f2.mat','MLD')
MLD=reshape(MLD,100*freq,[],nc);
MLD=squeeze(mean(MLD,1));
ref=MLD(end,:);
MPI_ice132=MLD;
MPI_ice132_anom=MLD-ref;

% % MPI runs:
% [t, n]=size(MPI_glac111);
% Y=t/freq;
% % Reshape into [months, years, sites]
% MPI_glac111=reshape(MPI_glac111, 12, Y, n);
% % Take the mean along dimension 1 (averaging all 12 months)
% MPI_glac111_ann=squeeze(mean(MPI_glac111, 1));
% 
% MPI_glac122=reshape(MPI_glac122, 12, Y, n);
% MPI_glac122_ann=squeeze(mean(MPI_glac122, 1));
% MPI_glac132=reshape(MPI_glac132, 12, Y, n);
% MPI_glac132_ann=squeeze(mean(MPI_glac132, 1));
% MPI_ice111=reshape(MPI_ice111, 12, Y, n);
% MPI_ice111_ann=squeeze(mean(MPI_ice111, 1));
% MPI_ice122=reshape(MPI_ice122, 12, Y, n);
% MPI_ice122_ann=squeeze(mean(MPI_ice122, 1));
% MPI_ice132=reshape(MPI_ice132, 12, Y, n);
% MPI_ice132_ann=squeeze(mean(MPI_ice132, 1));

year_MPI=YSbp:YEbp;
cent_MPI=reshape(year_MPI,100,[]);
cent_MPI=mean(cent_MPI,1)/1000; % convert to ka

% % --- JAN-MAR (JFM) MEANS ---
% % Extract just rows 1 through 3 from the first dimension, then average
% jfm_3D = mean(A_3D(1:3, :, :), 1);
% 
% % Reshape back to [Y, n]
% jfm_means = reshape(jfm_3D, Y, n);

%% Create tiled layout
RGB = orderedcolors("gem");
H = rgb2hex(RGB);
fig=figure;
set(fig,'WindowStyle','normal');
set(fig,'Units','centimeters','OuterPosition',[1,1,18,22.5]);
t=tiledlayout(length(groups),1,"TileSpacing","tight","Padding","loose");
labels={'Labrador Sea','Central Subpolar North Atlantic','Eastern Subpolar North Atlantic','Nordic Seas','Fram Strait'};

% Prepare for binning proxy records
bin=-12:0.5:0;

for i=1:length(groups)
    ax(i)=nexttile;
    gr=groups{i};
    [~,row]=ismember(gr,coreName);
    h1=plot(cent_HadCM3,mean(HadCM3_uniform(:,row),2),'Color',H(1),'LineStyle','--','DisplayName','HadCM3_uniform');
    hold on
    h2=plot(cent_HadCM3,mean(HadCM3_routed(:,row),2),'Color',H(1),'DisplayName','HadCM3_routed');
    h3=plot(cent_trace21ka,mean(trace21ka(:,row),2),'Color',H(2),'DisplayName','TraCE-21ka');
    h4=plot(cent_MPI,mean(MPI_glac111(:,row),2),'Color',H(3),'DisplayName','MPI_Glac1D_P1','LineStyle',':');
    h5=plot(cent_MPI,mean(MPI_glac122(:,row),2),'Color',H(4),'DisplayName','MPI_Glac1D_P2','LineStyle',':');
    h6=plot(cent_MPI,mean(MPI_glac132(:,row),2),'Color',H(5),'DisplayName','MPI_Glac1D_P3','LineStyle',':');
    h7=plot(cent_MPI,mean(MPI_ice111(:,row),2),'Color',H(3),'DisplayName','MPI_Ice6G_P1');
    h8=plot(cent_MPI,mean(MPI_ice122(:,row),2),'Color',H(4),'DisplayName','MPI_Ice6G_P2');
    h9=plot(cent_MPI,mean(MPI_ice132(:,row),2),'Color',H(5),'DisplayName','MPI_Ice6G_P3');
    reconRef=mean(coreRef(row));
    reconBin=zeros(length(bin)-1,length(gr))+nan;
    for j=1:length(gr)
        file=[gr{j},'_predictions.csv'];
        record=readtable([path,file]);
        recon=record.MLDann;
        age=-record{:,1};
        % Loop through bins for each core
        for jj=1:length(reconBin)
            idx=find(age>=bin(jj) & age<bin(jj+1));
            reconBin(jj,j)=mean(recon(idx),'omitnan');
        end
        % Then get the average of the group
        reconBin_avg=mean(reconBin,2,'omitnan');
    end
    hc=plot(-11.75:0.5:-0.25,reconBin_avg,'DisplayName',reconlegend,'Color','k','LineWidth',1);
    xlim([-12,0])
    title(labels{i})
    if i==1
    legend('show','IconColumnWidth',17,'Location','bestoutside','Interpreter', 'none')
    end
    hold off
end
xticklabels(ax(1:4), {});
xticklabels(ax(end),{'12','10','8','6','4','2','0'})
xlabel(t,'Time (ka BP)')
ylabel(t,'Annual mean MLD (m)')
exportgraphics(fig, './plots/revised/Fig6.pdf','ContentType','vector');

%% Calculate statistical metrics

modelList={'HadCM3_uniform' 'HadCM3_routed' 'TraCE-21ka' 'MPI_Glac1D_P1' ...
    'MPI_Glac1D_P2' 'MPI_Glac1D_P3' 'MPI_Ice6G_P1' 'MPI_Ice6G_P2' 'MPI_Ice6G_P3'};
fileP='./LDdata/';

binary_dino=anom_dino>=0;
anom_model=zeros(length(anom_dino),length(modelList))+NaN;
rmse=zeros(length(modelList),1);
spearman_rho=rmse;
spearman_pval=rmse;

fileList=dir([fileP,'*_MHPI.mat']);
c=1;
for i=[2,1,9,3,4,5,6,7,8]
    ldFile=[fileP,fileList(i).name];
    load(ldFile,"MLDanom","nav_lon","nav_lat")
    anom_model(:,c)=griddata(nav_lon,nav_lat,MLDanom,Corelon,Corelat,'nearest');
    rmse(c)=sqrt( mean( (anom_model(:,c)-anom_dino).^2 ) );
    [spearman_rho(c),spearman_pval(c)]=corr(anom_dino,anom_model(:,c),'Type','Spearman');
    c=c+1;
end

spearman_table=table(spearman_rho,spearman_pval,'RowNames',modelList);
writetable(spearman_table,'./Stats/SpearmanCorr.csv','WriteRowNames',true)

rmse_table=table(rmse,'RowNames',modelList);
writetable(rmse_table,'./Stats/rmse.csv','WriteRowNames',true)

binary_model=anom_model>=0;
dino_table=table(binary_dino);
writetable(dino_table,'./Stats/binary_dino_anom.csv')
model_table=table(binary_model);
writetable(model_table,'./Stats/binary_model_anom.csv')
