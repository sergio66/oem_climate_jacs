function params = set_up_dnn(iHidden,iNN,nLayerFeatures,nChannelsBand)

% params = struct();
% params.tau_fc1_W = dlarray(initWeights(hidden, nLayerFeatures));
% params.tau_fc1_b = dlarray(zeros(hidden,1,'single'));
% params.tau_fc2_W = dlarray(initWeights(hidden, hidden));
% params.tau_fc2_b = dlarray(zeros(hidden,1,'single'));
% params.tau_fc3_W = dlarray(initWeights(nChannelsBand, hidden));
% params.tau_fc3_b = dlarray(zeros(nChannelsBand,1,'single'));

params = struct();
if iHidden == 2
  hidden1 = iNN;
  hidden2 = iNN;

  params.tau_fc1_W = dlarray(initWeights(hidden1, nLayerFeatures));
  params.tau_fc1_b = dlarray(zeros(hidden1,1,'single'));
  params.tau_fc2_W = dlarray(initWeights(hidden2, hidden1));
  params.tau_fc2_b = dlarray(zeros(hidden2,1,'single'));
  params.tau_fc3_W = dlarray(initWeights(nChannelsBand, hidden2));
  params.tau_fc3_b = dlarray(zeros(nChannelsBand,1,'single'));

elseif iHidden == 3
  hidden1 = iNN;
  hidden2 = iNN;
  hidden3 = iNN;

  params.tau_fc1_W = dlarray(initWeights(hidden1, nLayerFeatures));
  params.tau_fc1_b = dlarray(zeros(hidden1,1,'single'));
  params.tau_fc2_W = dlarray(initWeights(hidden2, hidden1));
  params.tau_fc2_b = dlarray(zeros(hidden2,1,'single'));
  params.tau_fc3_W = dlarray(initWeights(hidden3, hidden2));
  params.tau_fc3_b = dlarray(zeros(hidden3,1,'single'));
  params.tau_fc4_W = dlarray(initWeights(nChannelsBand, hidden3));
  params.tau_fc4_b = dlarray(zeros(nChannelsBand,1,'single'));

elseif iHidden == 4
  hidden1 = iNN;
  hidden2 = iNN;
  hidden3 = iNN;
  hidden4 = iNN;

  params.tau_fc1_W = dlarray(initWeights(hidden1, nLayerFeatures));
  params.tau_fc1_b = dlarray(zeros(hidden1,1,'single'));
  params.tau_fc2_W = dlarray(initWeights(hidden2, hidden1));
  params.tau_fc2_b = dlarray(zeros(hidden2,1,'single'));
  params.tau_fc3_W = dlarray(initWeights(hidden3, hidden2));
  params.tau_fc3_b = dlarray(zeros(hidden3,1,'single'));
  params.tau_fc4_W = dlarray(initWeights(hidden4, hidden3));
  params.tau_fc4_b = dlarray(zeros(hidden3,1,'single'));
  params.tau_fc5_W = dlarray(initWeights(nChannelsBand, hidden4));
  params.tau_fc5_b = dlarray(zeros(nChannelsBand,1,'single'));

else
  error('iHidden = 2,3,4 only')
end
