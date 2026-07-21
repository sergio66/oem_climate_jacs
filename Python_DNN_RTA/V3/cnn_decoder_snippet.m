%% cnn_decoder_snippet.m

%% see https://cs231n.github.io/
%% https://yangxiaozhou.github.io/data/2020/09/24/intro-to-cnn.html

% UNVERIFIED (no MATLAB available to test here) -- more experimental than
% the earlier scripts. Given your truncation-floor check already showed
% the LINEAR PCA basis captures the spectrum to 0.086 K, this is unlikely
% to fix the 0.5 K plateau on its own (that was diagnosed as a data-
% density problem). Worth trying as a genuine alternative, not a fix for
% the specific issue you're chasing right now.
%
% Idea: instead of trunk -> nPCA_BT coefficients -> FIXED linear PCA
% decoder -> nChannels, do trunk -> small latent -> TRAINABLE CNN decoder
% -> nChannels directly. Trained with MSE against raw BT (not PCA coeffs),
% since the decoder is no longer constrained to PCA's linear subspace.
%
% Decoder architecture: dense projection to a short "seed" sequence, then
% repeated (upsample x2 + conv) blocks to grow it to nChannels. This
% upsample-then-conv pattern is used instead of transposed convolution
% because it avoids relying on dltranspconv, which I'm less confident
% about the exact API/behavior for without being able to test it.

%% ---- decoder-specific parameters (add these to your params struct) ----
nLatent   = 32;          % trunk output width feeding the decoder
seedLen   = 20;          % initial sequence length before upsampling
seedChan  = 64;          % channels at the seed stage
upFactor  = 2;           % upsample factor per block
nUpBlocks = ceil(log2(nChannels/seedLen) / log2(upFactor));  % blocks needed to reach ~nChannels

params.dec_seed_W = dlarray(initWeights(seedLen*seedChan, nLatent));
params.dec_seed_b = dlarray(zeros(seedLen*seedChan,1,'single'));

for b = 1:nUpBlocks
    inCh  = seedChan;                 % keep channel count constant through the stack for simplicity
    outCh = seedChan;
    params.(sprintf('dec_conv%d_W',b)) = dlarray(initConvWeights(5, inCh, outCh));
    params.(sprintf('dec_conv%d_b',b)) = dlarray(zeros(outCh,1,'single'));
end

% final 1x1-style conv to collapse channels -> 1 (the spectrum itself)
params.dec_out_W = dlarray(initConvWeights(5, seedChan, 1));
params.dec_out_b = dlarray(zeros(1,1,'single'));

%% ---- decoder forward pass ----
function bt = cnnDecoder(params, latent, nUpBlocks, upFactor, seedLen, seedChan, nChannelsTarget)
    % latent: dlarray, format 'CB' (nLatent x batch)
    batchSize = size(latent, 2);

    h = relu(fullyconnect(latent, params.dec_seed_W, params.dec_seed_b));  % (seedLen*seedChan x batch)
    h = stripdims(h);
    h = reshape(h, seedLen, seedChan, batchSize);   % (spatial x channels x batch)
    h = dlarray(h, 'SCB');

    for b = 1:nUpBlocks
        % nearest-neighbor upsample along the spatial dim
        h = stripdims(h);
        h = repelem(h, upFactor, 1, 1);
        h = dlarray(h, 'SCB');
        % smooth with a conv after upsampling (avoids checkerboard artifacts)
        h = dlconv(h, params.(sprintf('dec_conv%d_W',b)), params.(sprintf('dec_conv%d_b',b)), 'Padding','same');
        h = relu(h);
    end

    % collapse to a single output channel = the spectrum
    h = dlconv(h, params.dec_out_W, params.dec_out_b, 'Padding','same');  % (spatial x 1 x batch)

    % trim/pad spatial length to exactly nChannelsTarget (upsampling by
    % powers of 2 won't land exactly on nChannels in general)
    h = stripdims(h);
    h = squeeze(h);                      % (spatial x batch)
    if size(h,1) >= nChannelsTarget
        h = h(1:nChannelsTarget, :);
    else
        error('Upsampled length %d < target %d channels -- add another up-block.', size(h,1), nChannelsTarget);
    end
    bt = dlarray(h, 'CB');               % (nChannels x batch)
end

%% ---- full forward pass: trunk -> latent -> CNN decoder ----
function Y = forwardWithCNNDecoder(params, X, iHidden, nUpBlocks, upFactor, seedLen, seedChan, nChannelsTarget)
    % X -> ... -> trunk output = latent (nLatent x batch), same trunk as before
    latent = forwardMLP(params, X, iHidden);   % reuse your existing trunk; make its output width = nLatent
    Y = cnnDecoder(params, latent, nUpBlocks, upFactor, seedLen, seedChan, nChannelsTarget);
end

%% ---- loss: now directly against raw BT, not PCA coefficients ----
function [loss, grads] = modelGradientsCNNDecoder(params, X, btTarget, iHidden, nUpBlocks, upFactor, seedLen, seedChan, nChannelsTarget)
    btPred = forwardWithCNNDecoder(params, X, iHidden, nUpBlocks, upFactor, seedLen, seedChan, nChannelsTarget);
    loss = mean((btPred - btTarget).^2, 'all');
    grads = dlgradient(loss, params);
end

% Training loop call site changes to:
%   Yb = dlarray(single(btRaw(batchIdx,:))', 'CB');   % raw BT, not PCA coeffs
%   [loss, grads] = dlfeval(@modelGradientsCNNDecoder, params, Xb, Yb, iHidden, ...
%                            nUpBlocks, upFactor, seedLen, seedChan, nChannels);
