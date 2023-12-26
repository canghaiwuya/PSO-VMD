%% 样本熵函数
function sampEn = SampleEntropy( dim, r, data, tau )
%   注意：这个样本熵函数是在Kijoon Lee的基础上做的修改
%   样本熵算法的提出者：Richman J s，Moorman J R. Physiological time-seriesanalysis using approximate entropy and sample entropy[J. American Journal of Physiology Heart &. Circula-tory Physiology，2000，278(6):2039-2049.
%   计算给定时间序列数据的样本熵
%   样本熵在概念上类似于近似熵，但有以下区别：
%       1）样本熵不计算自匹配，通过在最后一步取对数，避免了可能出现的log(0)问题；
%       2）样本熵不像近似熵那样依赖数据的长度。
%   dim：嵌入维数(一般取1或者2)
%   r：相似容限( 通常取0.1*Std(data)~0.25*Std(data) )
%   data：时间序列数据，data须为1xN的矩阵
%   tau：下采样延迟时间（在默认值为1的情况下，用户可以忽略此项）

if nargin < 4, tau = 1; end
if tau > 1, data = downsample(data, tau); end
 
N = length(data);
result = zeros(1,2);
 
for m = dim:dim+1
    Bi = zeros(N-m+1,1);
    dataMat = zeros(N-m+1,m);
    
    % 设置数据矩阵，构造成m维的矢量
    for i = 1:N-m+1
        dataMat(i,:) = data(1,i:i+m-1);
    end
    
    % 利用距离计算相似模式数
    for j = 1:N-m+1
        % 计算切比雪夫距离，不包括自匹配情况
        dist = max(abs(dataMat - repmat(dataMat(j,:),N-m+1,1)),[],2);
        % 统计dist小于等于r的数目
        D = (dist <= r);
        % 不包括自匹配情况
        Bi(j,1) = (sum(D)-1)/(N-m);
    end
 
    % 求所有Bi的均值
    result(m-dim+1) = sum(Bi)/(N-m+1);
	
end
    % 计算得到的样本熵值
    sampEn = -log(result(2)/result(1));
	
end
