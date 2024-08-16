function overlap_ratio = interval_overlap_ratio(interval1, interval2)
    start1 = interval1(1);
    end1 = interval1(2);
    start2 = interval2(1);
    end2 = interval2(2);

    overlap_start = max(start1, start2);
    overlap_end = min(end1, end2);
    overlap = max(0, overlap_end - overlap_start);
    
    length1 = end1 - start1;
    length2 = end2 - start2;
    
    overlap_ratio = overlap / min(length1, length2);
end