filename='heatmap.xlsx';
tarmattable=readtable(filename);
corename=string(tarmattable.Properties.VariableNames);
bin=0:0.5:12;
tarmattable = array2table(nan(length(bin)-1, width(tarmattable)), ...
                    'VariableNames', tarmattable.Properties.VariableNames);
tarwaptable = tarmattable;
for i=1:length(corename)
    datacsv=[corename{i},'.csv'];
    datatable=readtable(datacsv,'NumHeaderLines',1);
    age=datatable.Var1;
    mat=datatable.Var2;
    wap=datatable.Var3;
    matbin=zeros(length(bin)-1,1);
    wapbin=matbin;
    for ii=1:length(matbin)
        idx=find(age>=bin(ii) & age<bin(ii+1));
        matbin(ii)=mean(mat(idx),'omitnan');
        wapbin(ii)=mean(wap(idx),'omitnan');
    end
    matanom=matbin-mean(matbin,'omitnan');
    wapanom=wapbin-mean(wapbin,'omitnan');
    if ismember(corename{i},tarmattable.Properties.VariableNames)
        tarmattable.(corename{i})=matanom;
        tarwaptable.(corename{i})=wapanom;
    else
        error('Header not found in excel file')
    end
end    
%writetable(tarmattable,filename,'Sheet','mat','WriteMode','overwriteSheet');
%writetable(tarwaptable,filename,'Sheet','wapls','WriteMode','overwriteSheet');

tarmat=table2array(tarmattable);
tarwap=table2array(tarwaptable);

% plot matrix as color table
alphamat=ones(size(tarmat)); 
alphawap=alphamat;
alphamat(isnan(tarmat))=0;
alphawap(isnan(tarwap))=0;
xLabel=corename;
yLabel=string(0:12);

t=tiledlayout(1,2);
nexttile;
imagesc(tarmat,'AlphaData',alphamat)
caxis([-400, 400]);
axis equal tight;
set(gca,'color',[.5 .5 .5])
set(gca,'XTick',1:length(xLabel),'XTickLabel',xLabel,'TickLength',[0 0],'XTickLabelRotation',90)
set(gca,'YTick',[1:2:length(bin)-1,length(bin)-1],'YTickLabel',yLabel)
title('a')

nexttile;
imagesc(tarwap,'AlphaData',alphawap)
caxis([-400, 400]);
axis equal tight;
set(gca,'color',[.5 .5 .5])
set(gca,'XTick',1:length(xLabel),'XTickLabel',xLabel,'TickLength',[0 0],'XTickLabelRotation',90)
set(gca,'YTick',[1:2:length(bin)-1,length(bin)-1],'YTickLabel',yLabel)
title('b')

colormap(cmocean('balance'))
C=colorbar;
C.Label.String='MLD anomalies (m)';
t.TileSpacing="compact";
t.Padding="compact";

%exportgraphics(gcf,'C:\Users\wuxin\Desktop\scpfiles\Mixed Layer Depth test\high qual figs\fig7.pdf','ContentType','vector')