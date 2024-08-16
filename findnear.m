function closestValue = findnear(a,b)
differences = abs(a - b);

% 找到绝对差最小值的索引
[~, minIndex] = min(differences);

% 提取最接近的值
closestValue = a(minIndex);

% 输出最接近的值

end 