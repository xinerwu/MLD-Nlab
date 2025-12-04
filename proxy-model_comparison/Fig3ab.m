% Figure 3
fig=figure;
set(fig,'WindowStyle','normal');
set(fig,'Units','centimeters','OuterPosition',[1,1,18.4,11.5]);
tiledlayout(1,2,"TileSpacing","tight","Padding","compact");

% panel a
ax1=nexttile;
MLD_dino_plot(ax1);

% panel b
ax2=nexttile;
MLD_PMIP_std(ax2);

add_panel_label(ax1,'a')
add_panel_label(ax2,'b')

exportgraphics(fig, './plots/Fig3x.pdf','ContentType','vector');

function add_panel_label(ax, letter)
    text(ax, 0.02, 0.98, letter, ...
         'Units', 'normalized', ...
         'FontSize', 14, 'FontWeight', 'bold', ...
         'VerticalAlignment', 'top', ...
         'HorizontalAlignment', 'left', ...
         'BackgroundColor', 'white', ...     % optional: makes it readable on dark plots
         'EdgeColor', 'black', ...           % optional: thin black border
         'Margin', 2);
end