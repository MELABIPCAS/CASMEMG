# Project Overview

### Data Source
The data used in this project is sourced from the CASMEMG database. To access the data, you need to submit a license agreement at [http://casme.psych.ac.cn.e5](http://casme.psych.ac.cn.e5).
Temporal annotations for 380 samples presented in `380_sorted.xlsx`.

### Methodology
This project implements the baseline method for EMG-based facial expression interval detection using the CASMEMG dataset. The methodology and parameters used for the detection process are outlined as follows:

### Parameter Exploration
We conducted 900 iterations to explore the parameters involved in the algorithm. This process identified the optimal parameter combination:

- **$W_L$** = 60
- **$S_L$** = 30
- **$k$** = 1
- **$S_n$** = 5
- **$W_f$** = 2
- **$W_b$** = 6

The script for finding the best parameter combination is located in the `findBestParameter` directory.

### Necessary functions 
All the necessary functions are listed in `functions` .
