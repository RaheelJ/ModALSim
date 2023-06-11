function [s, Temp]=Fridge(s, Tmax, Tmin, Temp, taw, T, ET, LT, OFF, ON, Leak, A)

for t=1:taw*T

    if t>1
    Temp(t)=Temp(t-1)+(Leak*A(ceil(t/taw))-ON*s(t)+OFF);
    end
    
    if t>LT || t<ET
        s(t+1)=0;
    elseif Temp(t)>=Tmax
        s(t+1)=1;
    elseif Temp(t)<=Tmin
        s(t+1)=0;
    end
    
end
Temp=(Temp(1:t));
s=s(1:t);
end
