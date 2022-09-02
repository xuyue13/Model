% 处理ECMWF的模式预测数据
% 数据：季度预测数据，月均
% 获取某月的预测气象数据（风速、辐照值），并插值成对应分辨率并保存

% nctoolbox已经添加到matlab的环境变量中；先运行setup程序
setup_nctoolbox;

% 定义所需的年份和月份
year_forcast = '2023'; % 预测的年份
month_forcast = '02'; % 预测的月份
filename = strcat('A5L08010000',month_forcast,'______1');

%% 读取.grib数据
filepath = strcat('D:\ECMWF数据下载方式\MARS数据\7month_forcast每月预测数据\',filename);

gribInfo2 = ncdataset(filepath);
gribInfo2.variables
lon_04 = gribInfo2.data('lon');
lat_04 = gribInfo2.data('lat');
wnd10 = gribInfo2.data('10_metre_wind_speed_surface'); % 季度的月均预测只提供10m的风速数据
ssrd = gribInfo2.data('Surface_solar_radiation_downwards_surface');
tp = gribInfo2.data('Total_precipitation_surface');
time = gribInfo2.data('time');
[LAT_04, LON_04] = meshgrid(lat_04, lon_04);

% 上述数据的维度是时间×纬度×经度，需要转换维度为经度×纬度×时间
wnd10_rerange = permute(wnd10,[3,2,1]);
ssrd_rerange = permute(ssrd,[3,2,1]);
tp_rerange = permute(tp,[3,2,1]);

%% 作图看看
figure;
contourf(LON_04, LAT_04, ssrd_rerange(:,:,1)); axis equal; axis tight;
hold on 
ChinaL = shaperead('bou2_4l.shp');
bou2_4lx = [ChinaL(:).X];
bou2_4ly = [ChinaL(:).Y];
plot(bou2_4lx,bou2_4ly,'k','linewidth',1.5);

gribInfo = ncgeodataset(filepath);
ssrd_set = gribInfo.geovariable('Surface_solar_radiation_downwards_surface');
ssrd_set.attributes

%% 插值到0.125°的矩阵大小
load('latlon_0125.mat'); 

% 风速插值
F_chazhi = scatteredInterpolant(double(LON_04(1:end)'), double(LAT_04(1:end)'), double(wnd10_rerange(1:end)'));
dataPredict = F_chazhi(double(LON_0125), double(LAT_0125)); % 预测风速的插值结果
    % 存储为预测矩阵
save(strcat('10m_wind_forcast_',year_forcast,month_forcast,'.mat'), 'dataPredict');

% 辐射插值
F_chazhi = scatteredInterpolant(double(LON_04(1:end)'), double(LAT_04(1:end)'), double(ssrd_rerange(1:end)'));
dataPredict = F_chazhi(double(LON_0125), double(LAT_0125)); % 预测辐射的插值结果
    % 存储为预测矩阵
save(strcat('solar_forcast_',year_forcast,month_forcast,'.mat'), 'dataPredict');

%% 作图看看
figure;
contourf(LON_0125, LAT_0125, dataPredict); axis equal; axis tight;
hold on 
ChinaL = shaperead('bou2_4l.shp');
bou2_4lx = [ChinaL(:).X];
bou2_4ly = [ChinaL(:).Y];
plot(bou2_4lx,bou2_4ly,'k','linewidth',1.5);

















































