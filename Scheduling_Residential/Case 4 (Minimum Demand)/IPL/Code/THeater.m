function [s]=THeater(s, taw, T, ET, LT)

for t=1:taw*T
    
        if t>LT || t<ET
            s(t)=0;
            continue;
        end
        
        if (sum(s(1:t))>=4)
            s(t+1)=0;
        end
end

s=s(1:taw*T);
end
