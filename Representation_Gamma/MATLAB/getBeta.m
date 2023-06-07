%pdf plots for comparison of the Nakagami-lognormal
%distribution fnl(x), the KG-distribution fKG(x) and the distribution given
%in the paper fNx(x)

function [x, u] = getBeta(sigma,alpha)

B=0.01:.0001:10;
lambda = (log(10)/10)*sigma;

for i=1:length(B)

    difference = psi(1,B(i)) - lambda^2;
    
%     if (abs(difference) == 0)
%         B
%         break;
%     end
%     
    if (abs(difference) < 0.01)
        x=B(i);
    end
    
end
u = psi(x) + log(alpha);