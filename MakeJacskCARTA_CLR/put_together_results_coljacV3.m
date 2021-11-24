addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil
addpath //home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath //home/sergio/MATLABCODE/TIME

iAIRSorCRIS = 1; %% AIRS
iAIRSorCRIS = 2; %% CRIS

disp('make sure AnomSym is correct symbolic link (AIRS vs CRIS!!!!) ret to continue'); pause
disp('make sure AnomSym is correct symbolic link (AIRS vs CRIS!!!!) ret to continue'); pause
disp('make sure AnomSym is correct symbolic link (AIRS vs CRIS!!!!) ret to continue'); pause

if iAIRSorCRIS == 1
  iMaxLatbin = 40;
  put_together_results_coljacV3_airs
elseif iAIRSorCRIS == 2
  iMaxLatbin = 39;
  iMaxLatbin = 38;
  put_together_results_coljacV3_cris
end
