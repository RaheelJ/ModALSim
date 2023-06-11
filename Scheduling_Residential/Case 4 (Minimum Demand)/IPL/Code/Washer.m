function [u_w, d_w, s_w, u_d, d_d, s_d]=Washer(u_w, d_w, u_d, d_d)

taw=4;
T=24;

s_w=zeros(1, taw*T+1);
Et_w=64;
Lt_w=92;
rot_w=8;
mso_w=8;
mu_w=8;
md_w=4;
M_w=500;

s_d=zeros(1, taw*T+1);
mu_d=8;
md_d=4;
d_wd=12;        %Parameter of coordination

%This is done because u(t) and d(t) changes s(t) unlike Temp(t) in
%temperature control devices, so initialization is necessary otherwise
%pre-stored values can cause problem.

for t=1:taw*T
    
        if t>Lt_w || t<Et_w
            s_w(t)=0;
            u_w(t)=0;
            d_w(t)=0;
            s_d(t)=0;
            u_d(t)=0;
            d_d(t)=0;
            continue;
        end


%%        
        if t>1 && u_w(t)==1 && s_w(t-1)==1
            u_w(t)=0;
        elseif t>1 && d_w(t)==1 && s_w(t-1)==0
            d_w(t)=0;
        end
        
        if t>1 && u_w(t)==1 && d_w(t)==1
            d_w(t)=0;
            s_w(t)=s(t-1);
            u_w(t)=0;
        elseif u_w(t)==1
            s_w(t)=1;
        elseif d_w(t)==1
            s_w(t)=0;
        elseif t>1
            s_w(t)=s_w(t-1);
        end
        
        if(sum(s_w)>=rot_w)
            u_w(t+1)=0;
            d_w(t+1)=1;
        elseif (sum(s_w)<rot_w && t>=Lt_w-2*mso_w)
            u_w(t+1)=1;
            d_w(t+1)=0;
            u_d(t+1)=0;
            d_d(t+1)=0;
        else
            d_w(t+1)=0;
        end
        
        if(t>mso_w)
            if(sum(s_w(t-mso_w:t))>mso_w+M_w*(1-u_w(t-mso_w)))
            s_w(t)=0;
            d_w(t)=1;
            end
        end
        
        if(t>=mu_w)
            if(sum(u_w(t-mu_w+1:t))>s_w(t))
                s_w(t)=1;
                d_w(t)=0;
                u_w(t)=0;
            end
        end
        
        if(t>=md_w)
            if(sum(d_w(t-md_w+1:t))>1-s_w(t))
                s_w(t)=0;
                d_w(t)=0;
                u_w(t)=0;
            end
        end

        
%%
        if t>1 && u_d(t)==1 && s_d(t-1)==1
            u_d(t)=0;
        elseif t>1 && d_d(t)==1 && s_d(t-1)==0
            d_d(t)=0;
        end
        
        if t>1 && u_d(t)==1 && d_d(t)==1
            d_d(t)=0;
            s_d(t)=s(t-1);
            u_d(t)=0;
        elseif u_d(t)==1
            s_d(t)=1;
        elseif d_d(t)==1
            s_d(t)=0;
        elseif t>1
            s_d(t)=s_d(t-1);
        end

        if(t>=mu_d)
            if(sum(u_d(t-mu_d+1:t))>s_d(t))
                s_d(t)=1;
                d_d(t)=0;
                u_d(t)=0;
            end
        end
        
        if(t>=md_d)
            if(sum(d_d(t-md_d+1:t))>1-s_d(t))
                s_d(t)=0;
                d_d(t)=0;
                u_d(t)=0;
            end
        end
    
                       
        if t>1 && s_w(t)+s_d(t)>1 && s_d(t-1)==1
            u_w(t)=0;
            d_w(t)=0;
            s_w(t)=0;
        elseif t>1 && s_w(t)+s_d(t)>1 && s_w(t-1)==1
            u_d(t)=0;
            d_d(t)=0;
            s_d(t)=0;
        elseif sum(s_w)>sum(s_d) && s_w(t)+s_d(t)>1
            u_w(t)=0;
            d_w(t)=0;
            s_w(t)=0;
        elseif sum(s_w)<sum(s_d) && s_w(t)+s_d(t)>1
            u_d(t)=0;
            d_d(t)=0;
            s_d(t)=0;
        elseif sum(s_w)==sum(s_d) && s_w(t)+s_d(t)>1
            u_d(t)=0;
            d_d(t)=0;
            s_d(t)=0;
        end
        
               
        
%%

%Keep operation time after t=1
        if (sum(s_w)>sum(s_d) && sum(s_d)<rot_w && t>=Lt_w-mso_w)
            u_d(t+1)=1;
            d_d(t+1)=0;
            u_w(t+1)=0;
            d_w(t+1)=0;
        elseif sum(s_w)>sum(s_d)
            d_w(t+1)=1;
            u_w(t+1)=0;
            d_d(t+1)=0;
        elseif sum(s_w)<sum(s_d) 
            d_d(t+1)=1;
            u_d(t+1)=0;
            d_w(t+1)=0;
        elseif sum(s_w)==sum(s_d) && s_d(t)==1
            d_d(t+1)=1;
            u_d(t+1)=0;
            d_w(t+1)=0;
        elseif sum(s_w)==sum(s_d) && s_w(t)==1
            d_w(t+1)=1;
            u_w(t+1)=0;
            d_d(t+1)=0;
        elseif sum(s_w)>=rot_w && sum(s_w)==sum(s_d) && s_w(t)==0 && s_d(t)==0
            d_w(t+1)=0;
            u_w(t+1)=0;
            d_d(t+1)=0;
            u_d(t+1)=0;
        elseif  sum(s_w)==sum(s_d) 
            d_d(t+1)=1;
            u_d(t+1)=0;
            d_w(t+1)=0;
        end

        if t>d_wd && s_d(t)>sum(s_w(t-d_wd:t-1))
            u_d(t)=0;
            d_d(t)=0;
            s_d(t)=0;
            u_d(t+1)=0;
            d_d(t+1)=0;
        end

end

u_w=u_w(1:taw*T);
d_w=d_w(1:taw*T);
s_w=s_w(1:taw*T);


u_d=u_d(1:taw*T);
d_d=d_d(1:taw*T);
s_d=s_d(1:taw*T);

end