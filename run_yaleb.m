clc;clear;
srcStr = {1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5};
tgtStr = {2,3,4,5,1,3,4,5,1,2,4,5,1,2,3,5,1,2,3,4};
load('data\YaleB.mat');
dataset={Y1_data,Y2_data,Y3_data,Y4_data,Y5_data};
labelset={Y1_label,Y2_label,Y3_label,Y4_label,Y5_label};

options.k      = 100;          % subspace base dimension
options.ker    = 'primal';     % kernel type, default='linear' options: linear, primal 
options.gamma  = 1;            % the parameter for kernel
T      = 10;                   % #iterations, default=10
options.Tin    = 10;           % #iterations, default=10

options.alpha  = 1;            % the parameter for mutual
options.beta   = 0.1;          % the parameter for regular term of Zs and Zt
options.lambda = 0.1;          % the parameter for regular term of P
options.us = 0.2;

classifier = 1; %1:NN 2:SVM

result = [];
for iData = 3:20
    fea = dataset{srcStr{iData}}';
    Xs = fea;
    fea = dataset{tgtStr{iData}}';
    Xt = fea;
    % Feature Normalization
%     fea=fea./repmat(sum(fea,2),1,size(fea,2));
    % Sample Normalization
    fea=fea./repmat(sum(fea,1),size(fea,1),1);
    %z-score
    fea=zscore(fea',1)';
    %normr
    fea=normr(fea')';
    Xs = fea;
    Ys = labelset{srcStr{iData}};
 
    fea = dataset{tgtStr{iData}}';
    % Feature Normalization
%     fea=fea./repmat(sum(fea,2),1,size(fea,2));
    % Sample Normalization
    fea=fea./repmat(sum(fea,1),size(fea,1),1);
    %z-score
    fea=zscore(fea',1)';
    %normr
    fea=normr(fea')';
    Xt = fea;
    Yt = labelset{tgtStr{iData}};
    
    % Evaluation
    if classifier == 1
    % 1NN evaluation
    mdl =ClassificationKNN.fit(Xs',Ys,'NumNeighbors',1);
    Cls= predict(mdl,Xt');
    acc = length(find(Cls==Yt))/length(Yt); fprintf('NN=%0.4f\n',acc);
    else
    % evaluation by SVM
    S=0;
    Cls = labeling_target(Xs,Xt,Ys,Yt,S); 
    end
    
    % Evaluation
    % parameter adjust
 
    alpha_all   = 10;%[ 0.1,1,10];%0.3:1;10;%
    beta_all    = 1;%[ 0.1,1,10];%0.3:1;1;%
    lambda_all  = 0.1;%[ 0.1,1,10];%0.1:0.3:1;
    for pari = 1:length(alpha_all)
        for parj = 1:length(beta_all)
            for park = 1:length(lambda_all)
                for usid=1%:6
                    %us_all=0:0.2:1;
                    %options.us=us_all(usid);
            options.alpha  = alpha_all(pari);
            options.beta   = beta_all(parj);
            options.lambda = lambda_all(park);
%             fprintf('Adjust parameter !! \n\n\n'); 
    Cls = [];
    Acc = []; 
    for t = 1:T
        %fprintf('==============================Iteration [%d]==============================\n',t);
        [Z,P] = BCT(Xs,Xt,Ys,Cls,options);
        Z  = Z*diag(sparse(1./sqrt(sum(Z.^2))));
        Zs = Z(:,1:size(Xs,2));
        Zt = Z(:,size(Xs,2)+1:end);
        
        if classifier == 1
        % 1NN evaluation
        mdl =ClassificationKNN.fit(Zs',Ys,'NumNeighbors',1);
        Cls= predict(mdl,Zt');
        acc = length(find(Cls==Yt))/length(Yt); fprintf('BCT+NN=%0.4f,',acc);
        else
        % evaluation by SVM
        [Cls,acc] = labeling_target(Zs,Zt,Ys,Yt,S); 
        end
        
        Acc = [Acc;acc];
    end
        Acc_par(pari,parj,park)     = acc(1);
%         Acc_par_max(pari,parj,park) = max(Acc);
          %Acc_par(usid) = acc(1);
                end
            end
        end
    end
    Acc_par
%     Acc_par_max
    
    result = [result;Acc(end)];
    fprintf('\n\n\n');
 
end

