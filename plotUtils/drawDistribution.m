function [ax1,ax2,im1,im2] = drawDistribution(range_x, range_y, img_size, tmp, value, map_rest, map_press, pos)

grid_rest = zeros(img_size,img_size);
rest_index = find(tmp==1);
for i=1:length(rest_index)
  img_x = value(rest_index(i),1);
  img_y = value(rest_index(i),2);

  img_x = floor( img_size*(img_x-range_x(1)) / (range_x(2)-range_x(1)) );
  img_y = floor( img_size*(img_y-range_y(1)) / (range_y(2)-range_y(1)) );

  if img_x > img_size || img_y > img_size || img_x < 1 || img_y < 1
    continue
  end

  grid_rest(img_y,img_x) = 1;
end

grid_press = zeros(img_size,img_size);
press_index = find(tmp>1);
for i=1:length(press_index)
  img_x = value(press_index(i),1);
  img_y = value(press_index(i),2);

  img_x = floor( img_size*(img_x-range_x(1)) / (range_x(2)-range_x(1)) );
  img_y = floor( img_size*(img_y-range_y(1)) / (range_y(2)-range_y(1)) );

  if img_x > img_size || img_y > img_size || img_x < 1 || img_y < 1
    continue
  end

  grid_press(img_y,img_x) = 1;
end

img_rest = imgaussfilt(grid_rest,15);
img_press = imgaussfilt(grid_press,15);

ax1 = axes('Position',pos);
im1 = imagesc(range_x, range_y, img_press);
hold on
colormap(ax1,map_press);
set(gca,'YDir','normal') 
set(gca, 'TickLabelInterpreter', 'latex')
xlabel('PC1', 'Interpreter','latex')
ylabel('PC2', 'Interpreter','latex')
% box off
ax = gca;
im1.AlphaData = img_press>ax.CLim(2)/6;

ax2 = axes('Position',pos);
im2 = imagesc(range_x, range_y, img_rest);
colormap(ax2,map_rest);
set(gca,'YDir','normal')
box off
ax = gca;
% im2.AlphaData = img_rest/sum(sum(img_rest))>img_press/sum(sum(img_press)) & img_rest>ax.CLim(2)/6;
im2.AlphaData = im1.AlphaData==0 & img_rest>ax.CLim(2)/6;

linkaxes([ax1,ax2]);
ax2.Visible = 'off';
ax2.XTick = [];
ax2.YTick = [];
ax1.Visible = 'off';
ax1.XTick = [];
ax1.YTick = [];

end

