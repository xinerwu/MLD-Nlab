function MLD_PMIP_std(ax,data)
axes(ax);
% Plot model standard deviation
cmap=cmocean('matter',8);
%figure;
%set(gcf, 'Position', [100, 100, 400, 440]);
m_proj('Lambert Conformal Conic','lat',[47 85],'long',[-65 15],'rect','on')

load(data,"stdmodels","x","y")
h=m_pcolor(x,y,stdmodels);
m_grid('tickdir','out','fontsize',6,'linest','none','xtick',[],'ytick',[]);%('linest','none','xticklabels',[],'xtick',[],'yticklabels',[],'ytick',[],'fontsize',5); %('box','on','tickdir','in','ytick',(2|[0 40]));
m_coast('color','k');
colormap(ax,cmap);
C=colorbar;
C.Location = "southoutside";
C.Title.String = 'Standard deviation';
C.Title.FontSize = 8;
C.FontSize = 6;
%exportgraphics(gcf, './plots/model-std.png','ContentType','vector');
end