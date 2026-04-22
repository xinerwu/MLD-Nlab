% Figure 3
fig=figure;
set(fig,'WindowStyle','normal');
set(fig,'Units','centimeters','OuterPosition',[1,1,18.4,19.5]);
tiledlayout(2,2,"TileSpacing","tight","Padding","compact");

% panel a
ax1=nexttile;
MLD_dino_plot(ax1,"mean_models.mat");

% panel b
ax2=nexttile;
MLD_PMIP_std(ax2,"mean_models.mat");

% panel c
ax3=nexttile;
MLD_dino_plot(ax3,"mean_models_PMIP3.mat");

% panel d
ax4=nexttile;
MLD_PMIP_std(ax4,"mean_models_PMIP3.mat");

add_panel_label(ax1,'(a)')
add_panel_label(ax2,'(b)')
add_panel_label(ax3,'(c)')
add_panel_label(ax4,'(d)')

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