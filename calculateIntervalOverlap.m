function [n1, a1, proportion_above_0_5, mean_diff_1, se_1, rmse_1, mean_diff_2, se_2, rmse_2] = calculateIntervalOverlap(matrix)
    % 读取数据
    fs=1000;
    GT_Start = matrix(:, 1)/fs;
    GT_End = matrix(:, 2)/fs;
    Pred_Start = matrix(:, 3)/fs;
    Pred_End = matrix(:, 4)/fs;

    % 计算prediction为0的数目n1
    n1 = sum(Pred_Start == 0 & Pred_End == 0);
    
    % 去掉prediction为0的行
    valid_idx = ~(Pred_Start == 0 & Pred_End == 0);
    GT_Start = GT_Start(valid_idx);
    GT_End = GT_End(valid_idx);
    Pred_Start = Pred_Start(valid_idx);
    Pred_End = Pred_End(valid_idx);

    % 计算区间重叠率
    overlap_ratios = arrayfun(@(gs, ge, ps, pe) interval_overlap_ratio([gs, ge], [ps, pe]), GT_Start, GT_End, Pred_Start, Pred_End);

    % 计算重叠率的平均值a1
    a1 = mean(overlap_ratios);
    
    % 计算重叠率大于0.5的比例（除以380）
    proportion_above_0_5 = sum(overlap_ratios > 0.5) / 380;

    % 计算第三列对于第一列的差异均值、SE和RMSE
    diff_1 = abs(Pred_Start - GT_Start);
    mean_diff_1 = mean(diff_1);
    se_1 = std(diff_1) / sqrt(length(diff_1));
    rmse_1 = sqrt(mean(diff_1.^2));

    % 计算第四列对应第二列的差异均值、SE和RMSE
    diff_2 = abs(Pred_End - GT_End);
    mean_diff_2 = mean(diff_2);
    se_2 = std(diff_2) / sqrt(length(diff_2));
    rmse_2 = sqrt(mean(diff_2.^2));

end

