function [u, d, a, s, E, delta]=ESD(u, d, E, taw, T, Emax, Emin, mu, md, Cc, Cd)

a(:, :)=zeros(96, 1);
a(7*4+1:7*4+4)=0.1*ones(4, 1);
a(8*4+1:8*4+4)=0.5*ones(4, 1);
a(9*4+1:9*4+4)=1.4*ones(4, 1);
a(10*4+1:10*4+4)=2.2*ones(4, 1);
a(11*4+1:11*4+4)=2.7*ones(4, 1);
a(12*4+1:12*4+4)=2.85*ones(4, 1);
a(13*4+1:13*4+4)=2.85*ones(4, 1);
a(14*4+1:14*4+4)=2.75*ones(4, 1);
a(15*4+1:15*4+4)=2.5*ones(4, 1);
a(16*4+1:16*4+4)=2.2*ones(4, 1);
a(17*4+1:17*4+4)=1.5*ones(4, 1);
a(18*4+1:18*4+4)=0.8*ones(4, 1);
a(19*4+1:19*4+4)=0.3*ones(4, 1);

s=zeros(1, taw*T);
for t=1:taw*T

        if t>1 && u(t)==1 && s(t-1)==1
            u(t)=0;
        elseif t>1 && d(t)==1 && s(t-1)==0
            d(t)=0;
        end
        
        if u(t)==1 && d(t)==1
            d(t)=0;
            s(t)=1;
        elseif u(t)==1
            s(t)=1;
        elseif d(t)==1
            s(t)=0;
        elseif t>1
            s(t)=s(t-1);
        end
        
        if(t>=mu)
            if(sum(u(t-mu+1:t))>s(t))
                u(t)=0;
                d(t)=0;
                s(t)=1;
            end
        end
        
        if(t>=md)
            if(sum(d(t-md+1:t))>1-s(t))
                u(t)=0;
                d(t)=0;
                s(t)=0;
            end
        end

        
        if E(t)>=Emax
            a(t)=0;
        elseif E(t)<=Emin
            u(t)=0;
            if s(t)==1
                s(t)=0;
                d(t)=1;
            end
        end
            
        E(t+1)=E(t)+(a(t)*Cc-s(t)*Cd);
end

delta=E(2:taw*T+1)-E(1:taw*T);
delta=[0; delta(2:taw*T)];
E=E(1:taw*T);
d=d(1:taw*T);
u=u(1:taw*T);
a=a(1:taw*T);
end

