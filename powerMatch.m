function electronics = powerMatch(events)

data3 = load('data3_dist.mat');
names = fieldnames(data3);
num_dists = length(names);
num_events = length(events);
electronics = cell(num_events, 1);

for i = 1:num_events
    event = events{i};
    meanPower = mean(event);
    event(event < 0.3 * meanPower) = [];
%     meanPower = mean(event);
%     varPower = var(event);
%     varPower = abs(varPower) ^ 0.5;
    
%     relatedEntropy = cell(num_dists, 2);
    Dmax = 0;
    
    tbl = tabulate(event);
    try
        tbl(tbl(:,3)==0,:)=[];
        tbl_len = size(tbl,1);
    catch
        continue;
    end
    
    
    for j = 1 : num_dists
        
        D = 0;
        for k = 1 : tbl_len
            pr = pdf(eval(['data3.', names{j}]), tbl(k,1));
            if(pr == 0)
                D = D + 0;
            else
                D = D + pr * log(pr / (tbl(k,3)/100));
            end
        end
%         relatedEntropy{j, 1} = names{j};
%         relatedEntropy{j, 2} = D;
        
        if(Dmax < D)
            Dmax = D;
            electronics{i} = names{j};
        end
    end
    
    
end

end