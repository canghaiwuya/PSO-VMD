%%
function [ff] = EnvelopeCost(c,data)

X = data;
% alpha = 2300;       % moderate bandwidth constraint：适度的带宽约束/惩罚因子
alpha = fix(c(1));       % moderate bandwidth constraint：适度的带宽约束/惩罚因子
K = fix(c(2));              % modes：分解的模态数


tau = 0;          % noise-tolerance (no strict fidelity enforcement)：噪声容限（没有严格的保真度执行）
% K = 10;              % modes：分解的模态数
DC = 0;             % no DC part imposed：无直流部分
init = 1;           % initialize omegas uniformly  ：omegas的均匀初始化
tol = 1e-7;     
%--------------- Run actual VMD code:数据进行vmd分解---------------------------
[u, u_hat, omega] = VMD(X, alpha, tau, K, DC, init, tol);
for i = 1:K
	xx= abs(hilbert(u(i,:))); %最小包络熵计算公式！
	xxx = xx/sum(xx);
    ssum=0;
	for ii = 1:size(xxx,2)
		bb = xxx(1,ii)*log(xxx(1,ii));
        ssum=ssum+bb;
    end
    fitness(i,:) = -ssum;
end
[ff] = min(fitness);
end


