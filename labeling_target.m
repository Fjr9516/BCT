function [Yt,acc] = labeling_target(Xs, Xt, Xs_label, Xt_label, S)
C = [0.001 0.01 0.1 1.0 10 100 1000 10000];  
for chsvm = 1 :length(C)
    tmd = ['-s ' num2str(S) ' -c ' num2str(C(chsvm)) ' -B 1 -q'];
    model(chsvm) = train(Xs_label, sparse(double(Xs')),tmd);
    [~,acc, ~] = predict(Xt_label, sparse(double(Xt')), model(chsvm), '-q');
    acc1(chsvm)=acc(1);
end	
[acc,bestsvm_id]=max(acc1);
fprintf(' svm acc=%2.2f %%\n',acc);
model=model(bestsvm_id);
score = model.w * [Xt; ones(1, size(Xt, 2))];%c*nt
[~, C] = max(score, [], 1);%The maximum value of each column

Yt = C';
end