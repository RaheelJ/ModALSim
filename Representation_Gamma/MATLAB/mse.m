%MSE plots for comparison of the Nakagami-lognormal
%distribution fnl(x), the KG-distribution fKG(x) and the distribution given
%in the paper fNx(x)

clear;
home;
clc;

m=2;
alpha=4;
x=linspace(0,6,1000);

for B=1:.5:2

   
    lambda = sqrt(psi(1,B));
    u = psi(B)+log(alpha);
    %u = (10*log10(u));
%Nakagami-lognormal distribution pdf

for i = 1:length(x)
fun = @(y) ((x(i).^((2*m) - 1)).*exp(-(m.*(x(i).^2))./y).*exp(-((log(y)-u).^2)/(2*lambda^2)))./((y.^m).*y);
temp(i) = integral(fun,0,Inf);
end
  fnl=  (2*(m^m)).*temp./(gamma(m).*sqrt(2*pi).*lambda);

for N=1:14;
%For the proposed PDF
%ti is abcissa and wi is the weighting factor
[t w]=hermquad(N); %To get the Hermite weights and abcissas

for i = 1:length(x)
    
    a = cumsum((2*(m^m).*(w).*exp((-m*((sqrt(2)*lambda.*t)+u))))/(gamma(m)*sqrt(pi)));
    b = cumsum(m.*exp((-((sqrt(2).*lambda*t)+u))));
    C = sqrt(pi)./(cumsum(w));
    
    fNX(i) = C(N).* a(N).*(x(i).^(2*m-1)).*exp(-(b(N).*(x(i)^2)));
    
end


temp1 = (fNX - fnl).^2;
temp2(N) = (1/length(x)).*sum(temp1);

end
    
   %plot(([1:14]),(temp2),'r--x');
   semilogy(1:14,-temp2,'r-x'); 
   hold on;
   grid on;
end
hold off;