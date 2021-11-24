addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB = 050
%JOB = 070
%JOB = 115

iAIRSorCRIS = +1; %% AIRS
iAIRSorCRIS = +2; %% Cris LoRes

iTimeStep = JOB;
[kcjac,savestr,outjacname] = driver_put_together_kcarta_jacs(iTimeStep,iAIRSorCRIS);
if ~exist(outjacname)
  disp('saving ....')
  eval(savestr);
else
  fprintf(1,'%s already exists ... not saving the final jacfile \n',outjacname)
end
   

