addpath /asl/matlib/aslutil/
addpath /asl/matlib/h4tools
addpath /asl/matlib/rtptools
%addpath /home/sergio/MATLABCODE
%addpath /home/sergio/MATLABCODE/UTILITY/

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB = 256

translate2834to2645_addCFCjacs_cld
