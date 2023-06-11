function [s, Temp]=WHeater(s, Tmax, Tmin, Temp, taw, T, ET, LT, OFF, ON, Leak, A)

for t=1:taw*T

        if t>LT || t<ET
            s(t)=0;
        elseif Temp(t)>Tmax
            s(t)=0;
        elseif Temp(t)<Tmin
            s(t)=1;
        end
    
    Temp(t+1)=Temp(t)+(ON*s(t)-Leak*A(t)-OFF);
end
Temp=(Temp(1:t));
end
