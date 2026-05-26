% Figure 3
fig=figure;
set(fig,'WindowStyle','normal');
set(fig,'Units','centimeters','OuterPosition',[1,1,16,24]);
tiledlayout(3,2,"TileSpacing","tight","Padding","compact");

% panel a
ax1=nexttile;
MLD_dino_plot(ax1,"mean_models.mat");

% panel b
ax2=nexttile;
MLD_PMIP_std(ax2,"mean_models.mat");
clim([0 800])

% panel c
ax3=nexttile;
MLD_dino_plot(ax3,"mean_models_PMIP3.mat");

% panel d
ax4=nexttile;
MLD_PMIP_std(ax4,"mean_models_PMIP3.mat");
clim([0 800])

% panel e
ax5=nexttile;
SIanom_dino_plot(ax5,"SImean_models.mat");

% panel f
ax6=nexttile;
MLD_PMIP_std(ax6,"SImean_models.mat");
%clim([0 800])

add_panel_label(ax1,'(a)')
add_panel_label(ax2,'(b)')
add_panel_label(ax3,'(c)')
add_panel_label(ax4,'(d)')
add_panel_label(ax5,'(e)')
add_panel_label(ax6,'(f)')

exportgraphics(fig, './plots/revised/Fig3.pdf','ContentType','vector');

function add_panel_label(ax, letter)
    text(ax, 0.02, 0.98, letter, ...
         'Units', 'normalized', ...
         'FontSize', 14, 'FontWeight', 'bold', ...
         'VerticalAlignment', 'top', ...
         'HorizontalAlignment', 'left', ...
         'BackgroundColor', 'white', ...     % optional: makes it readable on dark plots
         'EdgeColor', 'none', ...           % optional: thin black border
         'Margin', 2);
end