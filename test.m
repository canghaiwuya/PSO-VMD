clc
clear 
fs=12000;%采样频率
Ts=1/fs;%采样周期
L=1028;%采样点数
t=(0:L-1)*Ts;%时间序列
STA=1; %采样起始位置
%----------------导入内圈故障的数据-----------------------------------------
load 105.mat
X = X105_DE_time(1:L)'; %这里可以选取DE(驱动端加速度)、FE(风扇端加速度)、BA(基座加速度)，直接更改变量名，挑选一种即可。
%--------- some sample parameters forVMD：对于VMD样品参数进行设置---------------
alpha = 306;       % moderate bandwidth constraint：适度的带宽约束/惩罚因子
tau = 0;          % noise-tolerance (no strict fidelity enforcement)：噪声容限（没有严格的保真度执行）
K = 4;              % modes：分解的模态数，可以自行设置，这里以8为例。
DC = 0;             % no DC part imposed：无直流部分
init = 1;           % initialize omegas uniformly  ：omegas的均匀初始化
tol = 1e-7;        
%--------------- Run actual VMD code:数据进行vmd分解---------------------------
[VMD_components, u_hat, omega] = VMD(X, alpha, tau, K, DC, init, tol); %其中u为分解得到的IMF分量


% 绘制分解出来的VMD分量
figure();
num_components = size(VMD_components, 1);
x_axis = 1:length(X);

subplot(num_components+1, 1, 1);
plot(x_axis, X);
xlim([1 length(X)]);
title('轴承内圈故障直径0.007英寸, 原始信号');

for i = 1:num_components
    subplot(num_components+1, 1, i+1);
    plot(x_axis, VMD_components(i, :));
    title(['IMF',num2str(i)]);
    xlim([1 length(X)]);
end



