function [SP, SP_raw]=get_survprob(comp_t,bwd,thresh)
%%
%     clear bin_cents edges
    edges=(min(comp_t)-bwd:bwd:max(comp_t))';
%      edges=(min(comp_t):bwd:max(comp_t))';
    for k=2:length(edges)       % calculate bin centers
        bin_cents(k-1,1)=edges(k-1)+(edges(k)-edges(k-1))/2;    
    end
    
   

    [N,edges_r] = histcounts(comp_t,edges,'Normalization','cdf');  N=1-N; N=N'; % get 1-CDF
    %%
    bin_cents(N<0)=[]; N(N<0)=[];
    bin_cents(N<thresh)=[];  N(N<thresh)=[];
    SP_raw=[bin_cents,N];
    
    %% cut the distribution based on when it flattens out
    x=N;
    n = size(N,1);
    f = find([true;diff(x)~=0;true]);
    y = zeros(n,1);    y(f(1:end-1)) = diff(f);  y = cumsum(y(1:n))-(1:n)';
%     if max(y) <= thresh
%         [~, ix]=max(y); prob_thresh=N(ix)
%     else
%         ix=find(y>thresh,1,'last');    prob_thresh=N(ix)
%     end
    [~, ix]=max(y); prob_thresh=N(ix);
    if max(y)>1
        SP=[bin_cents(N>prob_thresh),N(N>prob_thresh)];
    else
        SP=SP_raw;
    end
    

    
    
%     %% cut the distribution based on counts
%     [counts,~] = histcounts(comp_t,edges); counts=counts';
%     ix = find(counts(2:end)>=thresh, 1, 'last' )+1; % find the dwell time cutoff   
%     bin_cents2=bin_cents(1:ix); N2=N(1:ix);
%     SP=[bin_cents2,N2];
    

    

end