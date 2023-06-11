function [u, d, s]=Stove(u, d, taw, T, ET, LT, rot, mso, mu, M)

s=zeros(1, taw*T+1);
%This is done because u(t) and d(t) changes s(t) unlike Temp(t) in
%temperature control devices, so initialization is necessary otherwise
%pre-stored values can cause problem.

for t=1:taw*T
    
        if t>LT || t<ET
            s(t)=0;
            u(t)=0;
            d(t)=0;
            continue;
        end
        
        if t>1 && u(t)==1 && s(t-1)==1
            u(t)=0;
        elseif t>1 && d(t)==1 && s(t-1)==0
            d(t)=0;
        end
        
        if t>1 && u(t)==1 && d(t)==1
            d(t)=0;
            s(t)=s(t-1);
            u(t)=0;
        elseif u(t)==1
            s(t)=1;
        elseif d(t)==1
            s(t)=0;
        elseif t>1
            s(t)=s(t-1);
        end
        
        if(sum(s)>=rot)
            u(t+1)=0;
            d(t+1)=1;
        elseif (sum(s)<rot && t>=LT-mso)
            u(t+1)=1;
            d(t+1)=0;
        else
            d(t+1)=0;
        end
        
        if(t>mso)
            if(sum(s(t-mso:t))>mso+M*(1-u(t-mso)))
            s(t)=0;
            d(t)=1;
            end
        end
        
        if(t>=mu)
            if(sum(u(t-mu+1:t))>s(t))
                u(t)=0;
                d(t)=0;
                s(t)=1;
            end
        end
        
%         if(t>=md)
%             if(sum(d(t-md+1:t))>1-s(t))
%                 u(t)=0;
%                 d(t)=0;
%                 s(t)=1;
%             end
%         end
        
end
u=u(1:taw*T);
d=d(1:taw*T);
s=s(1:taw*T);
end
