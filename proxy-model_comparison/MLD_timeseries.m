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
nc=length(coreName);

% Import reconstruction list
path='./mat/predictions/';
reconlist=dir([path,'*.csv']);
reconlegend='Reconstruction';

% Import model data and calculate centennial means for plotting
load('LDdata/HadCM3_routed.mat','MLD','YSbp','YEbp','freq')
MLD=reshape(MLD(1:end-1,:),100*freq,[],nc);
MLD=squeeze(mean(MLD,1));
HadCM3_routed=MLD; 
load('LDdata/HadCM3_uniform.mat','MLD')
MLD=reshape(MLD(1:end-1,:),100*freq,[],nc);
MLD=squeeze(mean(MLD,1));
HadCM3_uniform=MLD;
year_HadCM3=YSbp:1/freq:YEbp;
cent_HadCM3=reshape(year_HadCM3(1:end-1),100*freq,[]);
cent_HadCM3=mean(cent_HadCM3,1);

load('LDdata/trace21ka.mat','MLD','YSbp','YEbp','freq')
MLD=reshape(MLD(1:end-1,:),100*freq,[],nc);
MLD=squeeze(mean(MLD,1));
trace21ka=MLD;
dec_trace21ka=YSbp:1/freq:YEbp;
cent_trace21ka=reshape(dec_trace21ka(1:end-1),100*freq,[]);
cent_trace21ka=mean(cent_trace21ka,1);

load('LDdata/MPI-ESM1-2-CRtransient-deglaciation-prescribed-glac1dr1i1p1f1.mat','MLD','YSbp','YEbp','freq')
MLD=reshape(MLD,100*freq,[],nc);
MLD=squeeze(mean(MLD,1));
MPI_glac111=MLD;
load('LDdata/MPI-ESM1-2-CRtransient-deglaciation-prescribed-glac1dr1i1p2f2.mat','MLD')
MLD=reshape(MLD,100*freq,[],nc);
MLD=squeeze(mean(MLD,1));
MPI_glac122=MLD;
load('LDdata/MPI-ESM1-2-CRtransient-deglaciation-prescribed-glac1dr1i1p3f2.mat','MLD')
MLD=reshape(MLD,100*freq,[],nc);
MLD=squeeze(mean(MLD,1));
MPI_glac132=MLD;
load('LDdata/MPI-ESM1-2-CRtransient-deglaciation-prescribed-ice6gr1i1p1f1.mat','MLD')
MLD=reshape(MLD,100*freq,[],nc);
MLD=squeeze(mean(MLD,1));
MPI_ice111=MLD;
load('LDdata/MPI-ESM1-2-CRtransient-deglaciation-prescribed-ice6gr1i1p2f2.mat','MLD')
MLD=reshape(MLD,100*freq,[],nc);
MLD=squeeze(mean(MLD,1));
MPI_ice122=MLD;
load('LDdata/MPI-ESM1-2-CRtransient-deglaciation-prescribed-ice6gr1i1p3f2.mat','MLD')
MLD=reshape(MLD,100*freq,[],nc);
MLD=squeeze(mean(MLD,1));
MPI_ice132=MLD;

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
cent_MPI=mean(cent_MPI,1);

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
set(fig,'Units','centimeters','OuterPosition',[1,1,18,20]);
t=tiledlayout(length(groups),1,"TileSpacing","tight","Padding","loose");
labels={'Labrador Sea','Central Subpolar North Atlantic','Eastern Subpolar North Atlantic','Nordic Seas','Fram Strait'};

for i=1:length(groups)
    ax(i)=nexttile;
    gr=groups{i};
    [~,row]=ismember(gr,coreName);
    h1=plot(cent_HadCM3,HadCM3_uniform(:,row),'Color',H(1));
    hold on
    h2=plot(cent_HadCM3,HadCM3_routed(:,row),'Color',H(2));
    %plot(cent_trace21ka,trace21ka(:,row),'Color',H(3),'DisplayName','TraCE-21ka');
    %plot(cent_MPI,MPI_glac111(:,row),'Color',H(4),'DisplayName',);
    for j=1:length(gr)
        file=[gr{j},'_predictions.csv'];
        record=readtable([path,file]);
        recon=record.MLDann;
        age=-record{:,1}*1000;
        hc=plot(age,recon,'DisplayName',reconlegend,'Color','k','LineWidth',1);
        hold on
    end
    xlim([-12000,0])
    title(labels{i})
    if i==1
    legend([h1(1),h2(1),hc],{'HadCM3_uniform','HadCM3_routed',reconlegend}, ...
        'IconColumnWidth',17,'Location','best','Interpreter', 'none')
    end
    hold off
end
xlabel(t,'Time (ka BP)')
ylabel(t,'Annual mean MLD (m)')
%%
fig=figure;
set(fig,'WindowStyle','normal');
set(fig,'Units','centimeters','OuterPosition',[1,1,18,20]);
t=tiledlayout(length(groups),1,"TileSpacing","tight","Padding","loose");

for i=1:length(groups)
    ax(i)=nexttile;
    gr=groups{i};
    [~,row]=ismember(gr,coreName);
    h1=plot(cent_trace21ka,trace21ka(:,row),'Color',H(3));
    hold on
    for j=1:length(gr)
        file=[gr{j},'_predictions.csv'];
        record=readtable([path,file]);
        recon=record.MLDann;
        age=-record{:,1}*1000;
        hc=plot(age,recon,'DisplayName',reconlegend,'Color','k','LineWidth',1);
        hold on
    end
    xlim([-12000,0])
    title(labels{i})
    if i==1
    legend([h1(1),hc],{'TraCE-21ka',reconlegend}, ...
        'IconColumnWidth',17,'Location','best','Interpreter', 'none')
    end
    hold off
end
xlabel(t,'Time (ka BP)')
ylabel(t,'Annual mean MLD (m)')

%%
fig=figure;
set(fig,'WindowStyle','normal');
set(fig,'Units','centimeters','OuterPosition',[1,1,18,20]);
t=tiledlayout(length(groups),1,"TileSpacing","tight","Padding","loose");

for i=1:length(groups)
    ax(i)=nexttile;
    gr=groups{i};
    [~,row]=ismember(gr,coreName);
    h1=plot(cent_MPI,MPI_glac111(:,row),'Color',H(1));
    hold on
    h2=plot(cent_MPI,MPI_glac122(:,row),'Color',H(2));
    h3=plot(cent_MPI,MPI_glac132(:,row),'Color',H(3));
    for j=1:length(gr)
        file=[gr{j},'_predictions.csv'];
        record=readtable([path,file]);
        recon=record.MLDann;
        age=-record{:,1}*1000;
        hc=plot(age,recon,'DisplayName',reconlegend,'Color','k','LineWidth',1);
        hold on
    end
    xlim([-12000,0])
    title(labels{i})
    if i==1
    legend([h1(1),h2(1),h3(1),hc],{'MPI_Glac1D_p1','MPI_Glac1D_p2','MPI_Glac1D_p3',reconlegend}, ...
        'IconColumnWidth',17,'Location','best','Interpreter', 'none')
    end
    hold off
end
xlabel(t,'Time (ka BP)')
ylabel(t,'Annual mean MLD (m)')

%%
fig=figure;
set(fig,'WindowStyle','normal');
set(fig,'Units','centimeters','OuterPosition',[1,1,18,20]);
t=tiledlayout(length(groups),1,"TileSpacing","tight","Padding","loose");

for i=1:length(groups)
    ax(i)=nexttile;
    gr=groups{i};
    [~,row]=ismember(gr,coreName);
    h1=plot(cent_MPI,MPI_ice111(:,row),'Color',H(1));
    hold on
    h2=plot(cent_MPI,MPI_ice122(:,row),'Color',H(2));
    h3=plot(cent_MPI,MPI_ice132(:,row),'Color',H(3));
    for j=1:length(gr)
        file=[gr{j},'_predictions.csv'];
        record=readtable([path,file]);
        recon=record.MLDann;
        age=-record{:,1}*1000;
        hc=plot(age,recon,'DisplayName',reconlegend,'Color','k','LineWidth',1);
        hold on
    end
    xlim([-12000,0])
    title(labels{i})
    if i==1
    legend([h1(1),h2(1),h3(1),hc],{'MPI_Ice6G_p1','MPI_Ice6G_p2','MPI_Ice6G_p3',reconlegend}, ...
        'IconColumnWidth',17,'Location','best','Interpreter', 'none')
    end
    hold off
end
xlabel(t,'Time (ka BP)')
ylabel(t,'Annual mean MLD (m)')