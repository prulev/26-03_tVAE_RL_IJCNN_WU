function [batchInput,batchM1_truth,batchActions,batchTrials,opt] = DataLoader_tVAE(data,opt)
if strcmp(opt.Mode,'train')
    if (opt.DataLoaderCursor == 1) % shuffle when all trials have been trained once
        opt.trainTrials = opt.trainTrials(randperm(opt.NumberOfTrainTrials));
    end
    start = opt.DataLoaderCursor;
    stop = min(opt.NumberOfTrainTrials, opt.DataLoaderCursor+opt.batchSize-1);
    opt.DataLoaderCursor = mod(stop,opt.NumberOfTrainTrials)+1; % move the cursor forward
    trialIndexes = opt.trainTrials(start:stop);
elseif strcmp(opt.Mode,'test')
    trialIndexes = opt.testTrials;
elseif strcmp(opt.Mode,'all')
    trialIndexes = 1:opt.NumberOfTrainTrials;
end
timeIndexes = cell2mat(arrayfun(@(x) find(data.Trials==x), trialIndexes, 'UniformOutput', false));
timeIndexes = unique(timeIndexes + (-opt.historyLength:0)')';
padding = 200-mod((length(timeIndexes)-100), 200)+1;
timeIndexes = [timeIndexes timeIndexes(end)+(1:padding)];
batchInput    = data.mPFC(:,timeIndexes);
batchM1_truth = data.M1(:,timeIndexes);
batchActions  = data.movements(timeIndexes);
batchTrials   = data.Trials(timeIndexes);
end
