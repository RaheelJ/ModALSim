%the built-in incomplete gamma integral function gives some odd values.
%Instead just use the formula Capacity = integral (B*log(1+x)*fNy) instead
%of the FNy function. Nakagami lognormal is not included in this yet.

clear;
home;
clc;

sigma = 4.5;
N=15;
m=2;
alpha=4;
BW=1;
[t w]=hermquad(N);



P=0.1:0.5:10;

 
 expression = zeros(N,length(P));
for q = 1:3
    lambda = exp((log(10)/10)*sigma);
    [B u] = getBeta(sigma,alpha);
    a = ((2*(m^m).*(w).*exp((-m*((sqrt(2)*lambda.*t)+u))))/(gamma(m)*sqrt(pi)))
    b = (m.*exp((-((sqrt(2).*lambda*t)+u))))
    C = sqrt(pi)./((w))
    
     for i=1:N
        
          fun = @(x) (log2(1+((x.^2).*P))).*(C(i)./(2.*(P.^m))).*(a(i).*((x.^2).*P).^(m-1)).*exp((-(b(i).*((x.^2)))));
            Q = integral(fun,0,Inf,'ArrayValued',true);
            expression(i,:) = BW.*Q;
    end
    
    ChCap = sum(expression,1);


    h =(log((u^2)/sqrt(lambda^2 + u^2)));
    s = (sqrt(log(1 + ((lambda^2)/u^2))));
 
    mean = (10/log(10))*(exp(h + ((s^2)/2)));
    
    sd = (10/log(10))*((exp(h + ((s^2)/2)))*sqrt( exp(s^2)-1));

     for i=1:length(P)
    
%     fun = @(x,y) log2(1+(P(i).*(y.^2))).*((P(i).*(y.^2)).^(m-1)).*(1./(x.^m)).*(exp(-m.*(P(i).*y.^2)./x)).*(1./x).*exp( (- ((x) - mean ).^2) ./(2*sd^2));
    fun = @(x,y) log2(1+(P(i).*(y.^2))).*((P(i).*(y.^2)).^(m-1)).*(1./(x.^m)).*(exp(-m.*(P(i).*y.^2)./x)).*(1./x).*exp( (- ((x) - mean ).^2) ./(2*sd^2));
    
    Q(i) = integral2(fun,0,Inf,0,Inf);
    end
    FN2 = BW.*(m^m).*((10/log(10))./(sqrt(2*pi)*sd*gamma(m))).*Q;

    gamma_lognormal = FN2.* ChCap(length(P)/2)/FN2(length(P)/2); %normalizing amplitude
    
plot(-(10/log(10)).*log(P),ChCap, 'r-x',-(10/log(10)).*log(P),(gamma_lognormal),'b--')
hold on;
grid on;
xlabel('Unfaded SNR (P)');
ylabel('Channel Capacity');

    if (q==1)
    sigma =12;
    end
    if (q==2)
    sigma = 8;
    end
end
    hold off;