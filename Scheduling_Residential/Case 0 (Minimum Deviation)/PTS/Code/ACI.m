function [s_ac, Temp]=ACI(s_ac, Tmax, Tmin, Temp, taw, T, OFF_ac, ON_ac, Leak_ac, A, Tout)

for t=1:taw*T
    
    if t>1
    Temp(t)=Temp(t-1)+Leak_ac*A(ceil(t/taw))-ON_ac*s_ac(t)+OFF_ac*(Tout(ceil(t/taw))-Temp(t-1));
    end
    
    if Temp(t)>=Tmax(t)
        s_ac(t+1)=1;
    elseif Temp(t)<=Tmin(t)
        s_ac(t+1)=0;
    end
                            
end
Temp=(Temp(1:t));
s_ac=s_ac(1:t);
end
