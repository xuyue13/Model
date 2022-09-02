% nctoolbox已经添加到matlab的环境变量中；先运行setup程序
setup_nctoolbox;

% 读取.grib数据
% filepath = 'D:\ECMWF数据下载方式\MARS数据\target.grib';
filepath = 'D:\ECMWF数据下载方式\MARS数据\A1D08240000082718001';

gribInfo2 = ncdataset(filepath);
gribInfo2.variables
lon = gribInfo2.data('lon');
lat = gribInfo2.data('lat');
T2m = gribInfo2.data('2_metre_temperature_surface');
time = gribInfo2.data('time');
[LAT, LON] = meshgrid(lat, lon);

%% 重新书写数据和出图
% T2m_rerange = zeros(length(lon), length(lat), length(time));
% for i = 1 : length(lon)
%     for j = 1 : length(lat)
%         for k = 1 : length(time)
%             T2m_rerange(i,j,k) = T2m(k,j,i);
%         end
%     end
% end
T2m_rerange = permute(T2m,[3,2,1]); % 置换数组维度

figure;
contourf(LON, LAT, T2m_rerange(:,:,1)); axis equal; axis tight;
hold on 
ChinaL = shaperead('bou2_4l.shp');
bou2_4lx = [ChinaL(:).X];
bou2_4ly = [ChinaL(:).Y];
plot(bou2_4lx,bou2_4ly,'k','linewidth',1.5);
%% 类似的读取方式
gribInfo = ncgeodataset(filepath);
gribInfo.variables
% 经纬度
lon_set = gribInfo.geovariable('lon');
lat_set = gribInfo.geovariable('lat');
lon_data = lon_set.data(:);
lat_data = lat_set.data(:);
[LAT_set, LON_set] = meshgrid(lat_data, lon_data);
% 气温数据
T2m_set = gribInfo.geovariable('2_metre_temperature_surface');
T2m_data = T2m_set.data(:);
T2m_set.attributes









