function [ff] = SampleCost(c,data)

X = data;
% alpha = 2300;       % moderate bandwidth constraint：适度的带宽约束/惩罚因子
alpha = fix(c(1));       % moderate bandwidth constraint：适度的带宽约束/惩罚因子
tau = 0;          % noise-tolerance (no strict fidelity enforcement)：噪声容限（没有严格的保真度执行）
K = fix(c(2));              % modes：分解的模态数
% K = 10;              % modes：分解的模态数
DC = 0;             % no DC part imposed：无直流部分
init = 1;           % initialize omegas uniformly  ：omegas的均匀初始化
tol = 1e-7;     
%--------------- Run actual VMD code:数据进行vmd分解---------------------------
[u, u_hat, omega] = VMD(X, alpha, tau, K, DC, init, tol);
dim = 2;   %   dim：嵌入维数(一般取1或者2)
tau = 1;   %下采样延迟时间（在默认值为1的情况下，用户可以忽略此项）
for i = 1:K
	x=u(i,:);%
    r = 0.2*std(x);  %   r：相似容限( 通常取0.1*Std(data)~0.25*Std(data) )
    fitness(i,:) = SampleEntropy( dim, r, x, tau );
end
[ff] = min(fitness);
end


