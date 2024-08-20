%% Subsetting the n=1968 database for different regions
% 1=North Atlantic; 2=Arctic + ATL + PCF
option=2; makeplot=false; write=false;

if option==1
% North Atlantic
% 30-90N, -80-40E
clear
% define lon-lat bounds for the subset
minlat=30; maxlat=90;
minlon=-80; maxlon=40;
newfile1='coor1968NA.txt';
newfile2='dino1968NA.txt';
newfile3='envi1968NA.txt';
newfile4='MLD_1981-2010_naturalNA.txt';

% load data
fileName1='coor1968.txt';
fileName2='dino1968.txt';
fileName3='envi1968.txt';
fileName4='MLD_1981-2010_natural.txt';
dataTable1=readtable(fileName1,'Delimiter','\t','NumHeaderLines',1);
dataTable2=readtable(fileName2,'Delimiter','\t','NumHeaderLines',1);
dataTable3=readtable(fileName3,'Delimiter','\t','NumHeaderLines',1);
dataTable4=readtable(fileName4,'Delimiter','\t','NumHeaderLines',1);

station=dataTable1.Var1;
lat=dataTable1.Var2;
lon=dataTable1.Var3;

% find rows that correspond to the selection
rows=lat>=minlat & lat<=maxlat & lon>= minlon & lon<= maxlon;

% extract rows and save as txt file
coor=dataTable1(rows,:);
dino=dataTable2(rows,:);
envi=dataTable3(rows,:);
MLD=dataTable4(rows,:);
writetable(coor,newfile1,'Delimiter','\t')
writetable(dino,newfile2,'Delimiter','\t')
writetable(envi,newfile3,'Delimiter','\t')
writetable(MLD,newfile4,'Delimiter','\t')
end

if option==2
    % first extract Arctic = lat > 65.5 deg
    % then lat = [18, 65.5], ATL: lon=[-97,40], PCF: lon=[-180,-97]or[40,180]
    % finally lat < 18, ATL lon=[-90,40], PCF lon=[-180,-90]or[40,180]
    
    %load data
    fileName1='coor1968.txt';
    fileName2='C:\Users\xiner\Desktop\scpfiles\Mixed Layer Depth test\data for fig ABC.xlsx';
    newfile='C:\Users\xiner\Desktop\scpfiles\Mixed Layer Depth test\figABC.xls';
    dataTable1=readtable(fileName1,'Delimiter','\t','NumHeaderLines',1);
    dataTableA=readtable(fileName2,'Sheet','A');
    dataTableB=readtable(fileName2,'Sheet','B');
    dataTableC=readtable(fileName2,'Sheet','C');
    
    lat=dataTable1.Var2;
    lon=dataTable1.Var3;

    %find rows according to lon lat selection
    arc=lat>65.5001;
    atl1=lat>18 & lat<65.5001 & lon>-97 & lon<40; atl2=lat<18 & lon>-90 & lon<40;
    atl=atl1 | atl2;
    pcf=~(arc+atl);

    %extract rows and save
    arcA=dataTableA(arc,:);
    arcB=dataTableB(arc,:);
    arcC=dataTableC(arc,:);
    atlA=dataTableA(atl,:);
    atlB=dataTableB(atl,:);
    atlC=dataTableC(atl,:);
    pcfA=dataTableA(pcf,:);
    pcfB=dataTableB(pcf,:);
    pcfC=dataTableC(pcf,:);
    coor_arc=dataTable1(arc,:);
    coor_atl=dataTable1(atl,:);
    coor_pcf=dataTable1(pcf,:);
    
    if write==true
    writetable(arcA,newfile,'Sheet','arcA')
    writetable(arcB,newfile,'Sheet','arcB')
    writetable(arcC,newfile,'Sheet','arcC')
    writetable(atlA,newfile,'Sheet','atlA')
    writetable(atlB,newfile,'Sheet','atlB')
    writetable(atlC,newfile,'Sheet','atlC')
    writetable(pcfA,newfile,'Sheet','pcfA')
    writetable(pcfB,newfile,'Sheet','pcfB')
    writetable(pcfC,newfile,'Sheet','pcfC')
    writetable(coor_arc,'coor_arc.txt','Delimiter','\t')
    writetable(coor_atl,'coor_atl.txt','Delimiter','\t')
    writetable(coor_pcf,'coor_pcf.txt','Delimiter','\t')
    end

end

if makeplot==true
    figure;
    x1=arcA.CaseR_1;
    x2=atlA.CaseR_1;
    x3=pcfA.CaseR_1;
    y1=arcA.CaseR_2;
    y2=atlA.CaseR_2;
    y3=pcfA.CaseR_2;
    
    xline(0)
    hold on
    yline(0)
    hold on
    plot(x1,y1,'Marker','o','MarkerEdgeColor',[0 0.4470 0.7410],'LineStyle' ...
        ,'none')
    hold on
    plot(x2,y2,'Marker','square','MarkerEdgeColor', ...
        [0.8500 0.3250 0.0980],'LineStyle','none')
    hold on
    plot(x3,y3,'Marker','diamond','MarkerEdgeColor',[0.9290 0.6940 0.1250],'LineStyle','none')
    hold on
    %plot(x1,y1,'bo',x2,y2,'rsquare',x3,y3,'ydiamond')
    legend('Artic and circum-Arctic','North Atlantic and adjacent seas','North Pacific and adjacent seas')
    legend('Location','southeast')
    xlabel('Axis 1')
    ylabel('Axis 2')
    hold off

    figure;
    x1=arcB.CaseR_1;
    x2=atlB.CaseR_1;
    x3=pcfB.CaseR_1;
    y1=arcB.CaseR_2;
    y2=atlB.CaseR_2;
    y3=pcfB.CaseR_2;
    
    plot(x1,y1,'Marker','o','MarkerEdgeColor',[0 0.4470 0.7410],'LineStyle' ...
        ,'none')
    hold on
    plot(x2,y2,'Marker','square','MarkerEdgeColor', ...
        [0.8500 0.3250 0.0980],'LineStyle','none')
    hold on
    plot(x3,y3,'Marker','diamond','MarkerEdgeColor',[0.9290 0.6940 0.1250],'LineStyle','none')
    %plot(x1,y1,'bo',x2,y2,'rsquare',x3,y3,'ydiamond')
    %legend('Artic and circum-Arctic','North Atlantic and adjacent seas','North Pacific and adjacent seas')
    %legend('Location','southeast')
    xline(0)
    hold on
    yline(0)
    hold on
    xlabel('Axis 1')
    ylabel('Axis 2')
    hold off

    figure;
    x1=arcC.CaseR_1;
    x2=atlC.CaseR_1;
    x3=pcfC.CaseR_1;
    y1=arcC.CaseR_2;
    y2=atlC.CaseR_2;
    y3=pcfC.CaseR_2;
    
    plot(x1,y1,'Marker','o','MarkerEdgeColor',[0 0.4470 0.7410],'LineStyle' ...
        ,'none')
    hold on
    plot(x2,y2,'Marker','square','MarkerEdgeColor', ...
        [0.8500 0.3250 0.0980],'LineStyle','none')
    hold on
    plot(x3,y3,'Marker','diamond','MarkerEdgeColor',[0.9290 0.6940 0.1250],'LineStyle','none')
    %plot(x1,y1,'bo',x2,y2,'rsquare',x3,y3,'ydiamond')
    %legend('Artic and circum-Arctic','North Atlantic and adjacent seas','North Pacific and adjacent seas')
    %legend('Location','southeast')
    xline(0)
    hold on
    yline(0)
    hold on
    xlabel('Axis 1')
    ylabel('Axis 2')
    hold off
end