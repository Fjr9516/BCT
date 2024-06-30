function  [W,Z,E] = RDALR(Xs,Xt,alpha,beta)
[d,ns] = size(Xs); nt = size(Xt,2);
max_mu = 10^10;
mu = 10^-7;
rho = 1.2;
convergence = 10^-6;
% ----------------------------------------------
%               Initialization
% ----------------------------------------------
J = zeros(d,ns);
E = zeros(d,ns);
Z = zeros(nt,ns);

Y = zeros(nt,ns);
U = zeros(d,ns);
V = zeros(d,ns);

W = eye(d,d);
% ------------------------------------------------
%                   Main Loop
% ------------------------------------------------
for iter = 1:10 
    
    % updating F
    ta = 1/mu;
    temp_F = Z+Y/mu;
    [U01,S01,V01] = svd(temp_F,'econ');
    S01 = diag(S01);
    svp = length(find(S01>ta));
    if svp >= 1
        S01 = S01(1:svp)-ta;
    else
        svp = 1;
        S01 = 0;    
    end
    F = U01(:,1:svp)*diag(S01)*V01(:,1:svp)';      
    
    % updating W
    if iter>1
    W = ((J+Xt*Z+E)*Xs'-(U+V)*Xs'*(1/mu))/(Xs*Xs');
    end
    
    % updating Z
    Z = (eye(nt)+Xt'*Xt)\(Xt'*(W*Xs-E)+(1/mu)*(Xt'*V-Y)+F);
    
    % updating J
    taa = beta/mu;
    temp_J = W*Xs+U/mu;
    [U01,S01,V01] = svd(temp_J,'econ');
    S01 = diag(S01);
    svp = length(find(S01>taa));
    if svp >= 1
        S01 = S01(1:svp)-taa;
    else
        svp = 1;
        S01 = 0;    
    end
    J = U01(:,1:svp)*diag(S01)*V01(:,1:svp)';
    
    % updating E
    the2 = alpha/mu;
    temp_E = W*Xs-Xt*Z+V/mu;
    E = max(0,temp_E-the2)+min(0,temp_E+the2);    
    
    % updating Y1, Y2, Y3
    Y = Y+mu*(Z-F);
    U = U+mu*(W*Xs-J);
    V = V+mu*(W*Xs-Xt*Z-E);
    
    % updating mu
    mu = min(rho*mu,max_mu);
    
    % checking convergence
    leq1 = norm(Z-F,Inf);
    leq2 = norm(W*Xs-J,Inf);
    leq3 = norm(W*Xs-Xt*Z-E,Inf);
    if iter > 2
         if leq1<convergence && leq2<convergence && leq3<convergence
              break
         end
     end      
end

end
