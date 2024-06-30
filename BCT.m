function [Z,P] = BCT(Xs,Xt,Ys,Yt0,options)
if nargin < 5
    error('Algorithm parameters should be set!');
end
if ~isfield(options,'k')
    options.k = 100;
end
if ~isfield(options,'alpha')
    options.alpha = 1;
end
if ~isfield(options,'alpha')
    options.beta = 0.1;
end
if ~isfield(options,'lambda')
    options.lambda = 0.1;
end
if ~isfield(options,'ker')
    options.ker = 'primal';
end
if ~isfield(options,'gamma')
    options.gamma = 1.0;
end
if ~isfield(options,'us')
    options.us = 0.2;
end
if ~isfield(options,'Tin')
    options.Tin = 5;
end
k      = options.k;
alpha  = options.alpha;
beta   = options.beta;
lambda = options.lambda;
ker    = options.ker;
gamma  = options.gamma;
us     = options.us;
ut     = 1-us;
T      = options.Tin;

%fprintf('MCFA:  data=%s  k=%d  alpha=%f beta=%f lambda=%f\n',data,k,alpha,beta,lambda);

% Set predefined variables
X = [Xs,Xt];
X = X*diag(sparse(1./sqrt(sum(X.^2))));
[m,n] = size(X);
ns = size(Xs,2);
nt = size(Xt,2);
C = length(unique(Ys));

% Construct MMD matrix
e = [1/ns*ones(ns,1);-1/nt*ones(nt,1)];
M = e*e'*C;
if ~isempty(Yt0) && length(Yt0)==nt
    for c = reshape(unique(Ys),1,C)
        e = zeros(n,1);
        e(Ys==c) = 1/length(find(Ys==c));
        e(ns+find(Yt0==c)) = -1/length(find(Yt0==c));
        e(isinf(e)) = 0;
        M = M + e*e';
    end
end
M = M/norm(M,'fro');

% Construct centering matrix
H = eye(n)-1/(n)*ones(n,n);

mu     = 0.1;
rho    = 1.01;
max_mu = 10^6;
Zs     = zeros(nt,ns);
Zt     = zeros(ns,nt);
Ls     = zeros(nt,ns);
Lt     = zeros(ns,nt);
Y1     = zeros(nt,ns);
Y2     = zeros(ns,nt);

% Bilateral Co-Transfer: BCT
if strcmp(ker,'primal')
    for t = 1:T
        % Construct munual matrix
        ZS = [eye(ns) -Zs'; -Zs Zs*Zs'];
        ZT = [Zt*Zt' -Zt; -Zt' eye(nt)];

        % Update P
        Q = alpha*X*M*X'+X*(us*ZS+ut*ZT)*X'+lambda*eye(m);
        [P,~] = eigs(Q+1e-9*eye(m),X*H*X',k,'SM');
        
        % Update Zs, Ls
        Zs = (2*us*Xt'*P*P'*Xt+mu *eye(nt))\(2*us*Xt'*P*P'*Xs+mu*(Ls-Y1/mu));
        
        ta = beta/mu ;
        temp_Zs = Zs+Y1/mu ;
        Ls = max(0,temp_Zs-ta )+min(0,temp_Zs+ta );
%         temp_Zs = Zs +Y1/mu ;
%         [U01,S01,V01] = svd(temp_Zs ,'econ');
%         S01 = diag(S01);
%         svp = length(find(S01>ta));
%         if svp >= 1
%             S01 = S01(1:svp)-ta;
%         else
%             svp = 1;
%             S01 = 0;    
%         end
%         Ls = U01(:,1:svp)*diag(S01)*V01(:,1:svp)';
        
        % Update Zt, Lt
        Zt = (2*ut*Xs'*P*P'*Xs+mu *eye(ns))\(2*ut*Xs'*P*P'*Xt+mu*(Lt-Y2/mu));

        temp_Zt = Zt +Y2/mu ;
        [U01,S01,V01] = svd(temp_Zt ,'econ');
        S01 = diag(S01);
        svp = length(find(S01>ta));
        if svp >= 1
            S01 = S01(1:svp)-ta;
        else
            svp = 1;
            S01 = 0;    
        end
        Lt = U01(:,1:svp)*diag(S01)*V01(:,1:svp)';
        
        % updating Y2
        Y1 = Y1+mu *(Zs-Ls);
        Y2 = Y2+mu *(Zt-Lt);

        % updating mu
        mu = min(rho*mu ,max_mu);   
        
        ObjectValue(t) = trace(P'*Q*P)+beta*(norm(Zs,1)+nuclear_norm(Zt));
        ObjectZs(t) =norm(Zs-Ls,Inf);
        ObjectZt(t) =norm(Zt-Lt,Inf);
    end
    plot(1:length(ObjectValue),ObjectValue)
    plot(1:length(ObjectValue),ObjectZs)
    plot(1:length(ObjectValue),ObjectZt)
    Z = P'*X;
else
    for t = 1:T
        K = kernel(ker,X,[],gamma);
        Ks = kernel(ker,X,Xs,gamma);
        Kt = kernel(ker,X,Xt,gamma);
        % Construct munual matrix
        ZS = [eye(ns) -Zs'; -Zs Zs*Zs'];
        ZT = [Zt*Zt' -Zt; -Zt' eye(nt)];

        % Update P
        Q = alpha*K*M*K'+K*(us*ZS+ut*ZT)*K'+lambda*eye(n);
        [P,~] = eigs(Q+1e-9*eye(n),K*H*K',k,'SM');
        %Phi=X\P;
        % Update Zs, Ls
        Zs = (2*Kt'*P*P'*Kt+mu *eye(nt))\(2*Kt'*P*P'*Ks+mu*(Ls-Y1/mu));

        ta = beta/mu ;
        temp_Zs = Zs+Y1/mu ;
        Ls = max(0,temp_Zs-ta )+min(0,temp_Zs+ta );
    %         temp_Zs = Zs +Y1/mu ;
    %         [U01,S01,V01] = svd(temp_Zs ,'econ');
    %         S01 = diag(S01);
    %         svp = length(find(S01>ta));
    %         if svp >= 1
    %             S01 = S01(1:svp)-ta;
    %         else
    %             svp = 1;
    %             S01 = 0;    
    %         end
    %         Ls = U01(:,1:svp)*diag(S01)*V01(:,1:svp)';

        % Update Zt, Lt
        Zt = (2*Ks'*P*P'*Ks+mu *eye(ns))\(2*Ks'*P*P'*Kt+mu*(Lt-Y2/mu));

        temp_Zt = Zt +Y2/mu ;
        [U01,S01,V01] = svd(temp_Zt ,'econ');
        S01 = diag(S01);
        svp = length(find(S01>ta));
        if svp >= 1
            S01 = S01(1:svp)-ta;
        else
            svp = 1;
            S01 = 0;    
        end
        Lt = U01(:,1:svp)*diag(S01)*V01(:,1:svp)';

        % updating Y2
        Y1 = Y1+mu *(Zs-Ls);
        Y2 = Y2+mu *(Zt-Lt);

        % updating mu
        mu = min(rho*mu ,max_mu);   

        ObjectValue(t) = trace(P'*Q*P)+beta*(norm(Zs,1)+nuclear_norm(Zt));
    end
    Z = P'*K;
end
plot(1:length(ObjectValue),ObjectValue);                                 
% Z = P'*X;
%fprintf('Algorithm MCFA terminated!!!\n\n');
end

function a=nuclear_norm(Y)
[~,S,~]=svd(Y);
S=diag(S);
a=sum(S);
end
