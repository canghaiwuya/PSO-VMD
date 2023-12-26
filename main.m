%% 以最小包络熵或最小样本熵为目标函数，采用PSO算法优化VMD，求取VMD最佳的两个参数
clear 
clc
addpath(genpath(pwd))
load 105.mat
D=2;             % 优化变量数目
lb = [100 3];
ub = [2500 10];
dim = 2;
Max_iter=15;       % 最大迭代数目
SearchAgents_no=15;       % 种群规模
xz = 1;  %xz=1 or 2, 选择1，以最小包络熵为适应度函数，选择2，以最小样本熵为适应度函数。
if xz == 1  
    fobj=@EnvelopeCost;
else
    fobj=@SampleCost;
end

da = X105_DE_time(6001:7000); %这里选取105的DEtime数据
[gBestScore,gBest,cg_curve]=PSO(SearchAgents_no,Max_iter,lb,ub,dim,fobj,da);

%画适应度函数图
figure
plot(cg_curve,'Color',[0.9 0.5 0.1],'Marker','>','LineStyle','--','linewidth',1);

title('超参数寻优曲线')
xlabel('迭代步数');
ylabel('自适应函数最小包络熵优化');
legend('PSO优化VMD超参数模态分量个数K和惩罚因子α')
display(['最优惩罚因子α值：模态分量分解数K值', num2str(round(gBest))]);  %输出最佳位置
display(['The best optimal value of 最小包络熵 found by pso is : ', num2str(gBestScore)]);  %输出最佳适应度值
