function run_YaleB_othermethods()
clc;clear;
srcStr = {1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5};
tgtStr = {2,3,4,5,1,3,4,5,1,2,4,5,1,2,3,5,1,2,3,4};
load('data\YaleB.mat');
addpath('liblinear-2.1/matlab');
dataset={Y1_data,Y2_data,Y3_data,Y4_data,Y5_data};
labelset={Y1_label,Y2_label,Y3_label,Y4_label,Y5_label};

options.k      = 100;          % subspace base dimension
options.ker    = 'primal';     % kernel type, default='linear' options: linear, primal 
options.gamma  = 1;            % the parameter for kernel
T      = 6;                   % #iterations, default=10
options.Tin    = 10;            % #iterations, default=10

options.alpha  = 1;          % the parameter for mutual
options.beta   = 0.1;            % the parameter for regular term of Zs and Zt
options.lambda = 0.1;            % the parameter for regular term of P
options.us = 0.2;

classifier = 1; %1:NN 2:SVM

result = [];
for iData = 3:20
    fea = dataset{srcStr{iData}}';
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
    acc(iData) = length(find(Cls==Yt))/length(Yt); fprintf('NN=%0.4f\n',acc(iData)*100);
    else
    % Evaluation by SVM
    S=0;
    Cls = labeling_target(Xs,Xt,Ys,Yt,S); 
    end
    
%---------------------------------------------------------------------    
%     %CORAL
%     Xs=Xs';
%     Xt=Xt';
%     cov_source = cov(Xs) + eye(size(Xs, 2));
%     cov_target = cov(Xt) + eye(size(Xt, 2));
%     A_coral = cov_source^(-1/2)*cov_target^(1/2);
%     Sim_coral = Xs * A_coral * Xt';
%     accy_coral(iData)= SVM_Accuracy(Xs, A_coral, Yt, Sim_coral, Ys);
%     accy_coral
    
%     %LDADA
%     S.Xs=Xs;
%     S.Ys=Ys;
%     TT.Xt=Xt;
%     TT.Yt=Yt;
%     opt.nclasses=length(unique(Ys));opt.ldada.maxiter=10;opt.ldada.verbose=0;opt.ldada.predictor='ldada';
%     [Xs, Xt, Ys, Yt,~] = hl_ldada(S, TT, opt);
%     [~, C] = max(Xt, [], 1); C = C';
%     acc_ldada(iData) = normAcc(Yt, C)
    
    % JDA evaluation
    Cls = [];
    Acc = [];
    for t = 1:T
        fprintf('==============================Iteration [%d]==============================\n',t);
        [Z,A] = JDA(Xs,Xt,Ys,Cls,options);
        Z = Z*diag(sparse(1./sqrt(sum(Z.^2))));
        Zs = Z(:,1:size(Xs,2));
        Zt = Z(:,size(Xs,2)+1:end);

        Cls = knnclassify(Zt',Zs',Ys,1);
        acc = length(find(Cls==Yt))/length(Yt); fprintf('JDA+NN=%0.4f\n',acc);
    
        Acc = [Acc;acc(1)];
    end
    
    result = [result;Acc(end)];
    fprintf('\n\n\n');
    
    %DSTL
    alpha_all= 0.01;%[0.01,0.1,1,10];
    beta_all= 0.01;%[0.01,0.1,1,10];
    lambda_all= 1;%[0.01,0.1,1,10];
    for ia=1:length(alpha_all)
        for ib=1:length(beta_all)
            for il=1:length(lambda_all)
                alpha=alpha_all(ia);
                beta=beta_all(ib);
                lambda=lambda_all(il);
    P = TSL_LRSR(Xs,Xt,Ys,alpha,beta,lambda);
    Zs = P'*Xs;
    Zt = P'*Xt; 
    Zs = Zs./repmat(sqrt(sum(Zs.^2)),[size(Zs,1) 1]); 
    Zt  = Zt ./repmat(sqrt(sum(Zt.^2)),[size(Zt,1) 1]); 
    mdl =ClassificationKNN.fit(Zs',Ys,'NumNeighbors',1);
    Cls= predict(mdl,Zt');
    acc1(ia,ib,il) = length(find(Cls==Yt))/length(Yt); %fprintf('DSTL NN=%0.4f\n',acc);
            end
        end
    end
    Acc=max(max(max(acc1)))
    
%     %SA
%     [Xss,~,~] = princomp(Xs');
%     [Xtt,~,~] = princomp(Xt');
%     Ps = Xss(:,1:options.k);
%     Pt = Xtt(:,1:options.k);
%     
%     [~,acc(iData),~,~] = Subspace_Alignment(Xs',Xt',Ys,Yt,Ps,Pt);
%     acc

    %JGSA
    options.T = 2;
    options.mu = 1;
    Yt0 = Cls;
    [Zs, Zt, A, Att] = JGSA(Xs, Xt, Ys, Yt0, Yt, options);
    Cls = knnclassify(Zt',Zs',Ys,1); 
    acc = length(find(Cls==Yt))/length(Yt); 
    results(iData) =acc
%---------------------------------------------------------------------
end
mean(results)
end

function res = SVM_Accuracy (trainset, M,testlabelsref,Sim,trainlabels)
Sim_Trn = trainset * M *  trainset';
index = [1:1:size(Sim,1)]';
Sim = [[1:1:size(Sim,2)]' Sim'];
Sim_Trn = [index Sim_Trn ];

C = [0.001 0.01 0.1 1.0 10 100 1000 10000];
for i = 1 :size(C,2)
    model(i) = svmtrain(trainlabels, Sim_Trn, sprintf('-t 4 -c %d -v 2 -q',C(i)));
end
[val indx]=max(model);
CVal = C(indx);
model = svmtrain(trainlabels, Sim_Trn, sprintf('-t 4 -c %d -q',CVal));
[predicted_label, accuracy, decision_values] = svmpredict(testlabelsref, Sim, model);
res = accuracy(1,1);
end

