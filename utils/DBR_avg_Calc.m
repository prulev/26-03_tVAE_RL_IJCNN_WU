function [DBR, DBR_AVG]=DBR_avg_Calc(Predict,True,opt)
DBR_AVG = zeros(1,size(Predict,1));
for index= 1:size(Predict,1)
  if length(Predict) < 6000
    PreSeg{1} = Predict(index,:)';
    TrueSeg{1} = True(index,:)';
  else
    PreSeg = dbr_segment(Predict(index,:)',3000,1500);
    TrueSeg = dbr_segment(True(index,:)',3000,1500);
  end
  %% DBR acquire
  DBR = cellfun(@(x,y) dbr_acq(x,y,opt),TrueSeg,PreSeg,'UniformOutput',0);
  DBR_AVG(1,index) = mean(cell2mat(DBR));
end
DBR = nanmean(DBR_AVG);
end

function Data_frame=dbr_segment(data,window,shift)
%% segment neural data
% shift<window!!!
Data_frame = {};
for index = 1:shift:size(data,1)-window+shift-1
    if index+window-1<size(data,1)
        Data_frame{1,(index-1)/shift+1} = data(index:index+window-1,1);
    else
        Data_frame{1,(index-1)/shift+1} = data(index:end,1);
    end
end

end

function dbr = dbr_acq(spk_train,uvec,opt)
opt.DTCorrelation = 1;
%% compute ks statistics
for index=1:10
    [ Z, U, xAxis, KSSorted, tmp(index) ] = computeKSStats( spk_train, uvec* opt.sampleRate, opt );
end
ks = mean(tmp);
dbr = ks*sqrt(sum(spk_train))/1.36;
end
