clc
close all

%% Start the iterations -- Flower Algorithm 

for u=1:N_iter,

    for i=1:n
          
        
%% Formula: x_i^{t+1}=x_i^t+ L (x_i^t-gbest)
          
          if rand>p,
              
              %Fridge
              
              L_fr=Levy(d_ac);
              j=L_fr<0;
              L_fr(j)=-1;
              j=L_fr>0;
              L_fr(j)=1;
              j=s_fr(:, i)==0;
              s_fr(j, i)=-1;
              j=best_fr==0;
              best_fr(j)=-1;
              ds_fr=L_fr'.*(s_fr(:,i)-best_fr);
              s_fr(:,i)=s_fr(:,i)+ds_fr;
              j=s_fr(:,i)>0;
              s_fr(j, i)=1;
              j=s_fr(:,i)<0;
              s_fr(j, i)=0;
              j=best_fr<0;
              best_fr(j)=0;
              
              
              %AC/Inverter
              L_ac=Levy(d_ac);           %For AC
              j=L_ac<0;
              L_ac(j)=-1;
              j=L_ac>0;
              L_ac(j)=1;
              j=s_ac(:, i)==0;
              s_ac(j, i)=-1;
              j=best_ac==0;
              best_ac(j)=-1;
              ds_ac=L_ac'.*(s_ac(:,i)-best_ac);
              s_ac(:,i)=s_ac(:,i)+ds_ac;
              j=s_ac(:,i)>0;
              s_ac(j, i)=1;
              j=s_ac(:,i)<0;
              s_ac(j, i)=0;
              j=best_ac<0;
              best_ac(j)=0;
                            
              %Water Heater
              L_wh=Levy(d);
              j=L_wh<0;
              L_wh(j)=-1;
              j=L_wh>0;
              L_wh(j)=1;
              j=s_wh(:, i)==0;
              s_wh(j, i)=-1;
              j=best_wh==0;
              best_wh(j)=-1;
              ds_wh=L_wh'.*(s_wh(:,i)-best_wh);
              s_wh(:,i)=s_wh(:,i)+ds_wh;
              j=s_wh(:,i)>0;
              s_wh(j, i)=1;
              j=s_wh(:,i)<0;
              s_wh(j, i)=0;
              j=best_wh<0;
              best_wh(j)=0;
              
              %Tub Heater
              L_th=Levy(d);
              j=L_th<0;
              L_th(j)=0;
              j=L_th>0;
              L_th(j)=1;
              ds_th=L_th'.*abs(s_th(:,i)-best_th);
              s_th(:,i)=s_th(:,i)+ds_th;
              j=s_th(:,i)==2;
              s_th(j, i)=0;
              
              %Dish Washer
              L_dw=Levy(ceil(mso_dw/mu_dw)*ceil(rot_dw/mso_dw));
              dt_dw=L_dw'.*(t_dw(:,i)-tbest_dw);
              t_dw(:,i)=t_dw(:,i)+round(dt_dw);
              j=t_dw(:, i)>Lt_dw;
              t_dw(j, i)=Lt_dw;
              j=t_dw(:, i)<Et_dw;
              t_dw(j, i)=Et_dw;
              u_dw(:, i)=0;
              u_dw(t_dw(:, i), i)=1;
              
                                
              %ESD
              L_esd=Levy(d);
              j=L_esd<0;
              L_esd(j)=-1;
              j=L_esd>0;
              L_esd(j)=1;
              j=s_esd(:, i)==0;
              s_esd(j, i)=-1;
              j=best_esd==0;
              best_esd(j)=-1;
              ds_esd=L_esd'.*(s_esd(:,i)-best_esd);
              s_esd(:,i)=s_esd(:,i)+ds_esd;
              j=s_esd(:,i)>0;
              s_esd(j, i)=1;
              j=s_esd(:,i)<0;
              s_esd(j, i)=0;
              j=s_esd(:, i)==1;
              u_esd(:, i)=0;
              u_esd(j, i)=1;
              j=s_esd(:, i)==0;
              d_esd(:, i)=0;
              d_esd(j, i)=1;
              j=best_esd<0;
              best_esd(j)=0;

              
              %Pool Pump
              L_pp=Levy(4*ceil(mso_pp/mu_pp)*ceil(rot_pp/mso_pp));
              L_pp=L_pp./max(abs(L_pp));
              dt_pp=L_pp'.*(t_pp(:,i)-tbest_pp);
              t_pp(:,i)=t_pp(:,i)+round(dt_pp);
              j=t_pp(:, i)>Lt_pp-mso_pp;
              t_pp(j, i)=Lt_pp-mso_pp;
              j=t_pp(:, i)<Et_pp;
              t_pp(j, i)=Et_pp;
              u_pp(:, i)=0;
              u_pp(t_pp(:, i), i)=1;              
              
              %Stove
              L_st=Levy(ceil(mso_st/mu_st)*ceil(rot_st/mso_st));
              dt_st=L_st'.*(t_st(:,i)-tbest_st);
              t_st(:,i)=t_st(:,i)+round(dt_st);
              j=t_st(:, i)>Lt_st;
              t_st(j, i)=Lt_st;
              j=t_st(:, i)<Et_st;
              t_st(j, i)=Et_st;
              u_st(:, i)=0;
              u_st(t_st(:, i), i)=1;              
              
              %Washer/Dryer
              L_w=Levy(ceil(mso_w/mu_w)*ceil(rot_w/mso_w));
              dt_w=L_w'.*(t_w(:,i)-tbest_w);
              t_w(:,i)=t_w(:,i)+round(dt_w);
              j=t_w(:, i)>Lt_w;
              t_w(j, i)=Lt_w;
              j=t_w(:, i)<Et_w;
              t_w(j, i)=Et_w;
              u_w(:, i)=0;
              u_w(t_w(:, i), i)=1;              
              
              L_d=Levy(ceil(mso_w/mu_w)*ceil(rot_w/mso_w));
              dt_d=L_d'.*(t_d(:,i)-tbest_d);
              t_d(:,i)=t_d(:,i)+round(dt_d);
              j=t_d(:, i)>Lt_w;
              t_d(j, i)=Lt_w;
              j=t_d(:, i)<Et_w;
              t_d(j, i)=Et_w;
              u_d(:, i)=0;
              u_d(t_d(:, i), i)=1;              
              
               
              % Check if the simple limits/bounds are OK
              
              %Fridge
              [s_fr(:, i), Temp_fr(:, i)]=Fridge(s_fr(:, i), Tmax_fr, Tmin_fr, Temp_fr(:, i), taw_ac, T, Et_fr, Lt_fr, OFF_fr, ON_fr, Leak_fr, A_fr);
              
              %AC/Inverter
              [s_ac(:, i), Temp_in(:, i)]=ACI(s_ac(:, i), Tmax_in, Tmin_in, Temp_in(:, i), taw_ac, T, OFF_ac, ON_ac, Leak_ac, A_ac, Tout);
              
              %Water Heater
              [s_wh(:, i), Temp_wh(:, i)]=WHeater(s_wh(:, i), Tmax_wh, Tmin_wh, Temp_wh(:, i), taw, T, Et_wh, Lt_wh, OFF_wh, ON_wh, Leak_wh, A_wh);
              
              %Tube Heater
              [s_th(:, i)]=THeater(s_th(:, i), taw, T, Et_th, Lt_th);
              
              %Dish Washer
              [u_dw(:, i), d_dw(:, i), s_dw(:, i)]=DWasher(u_dw(:, i), d_dw(:, i), taw, T, Et_dw, Lt_dw, rot_dw, mso_dw, mu_dw, md_dw, M_dw);
              
              %ESD
              [u_esd(:, i), d_esd(:, i), a_esd(:, i), s_esd(:, i), C_esd(:, i), delta_esd(:, i)]=ESD(u_esd(:, i), d_esd(:, i), C_esd(:, i), taw, T, Emax_esd, Emin_esd, mu_esd, md_esd, Cc_esd, Cd_esd);
              
              %Pool Pump
              [u_pp(:, i), d_pp(:, i), s_pp(:, i)]=PPump(u_pp(:, i), d_pp(:, i), taw, T, Et_pp, Lt_pp, rot_pp, mso_pp, mu_pp, md_pp, M_pp);
              
              %Stove
              [u_st(:, i), d_st(:, i), s_st(:, i)]=Stove(u_st(:, i), d_st(:, i), taw, T, Et_st, Lt_st, rot_st, mso_st, mu_st, M_st);
    
              %Washer/Dryer
              [u_w(:, i), d_w(:, i), s_w(:, i), u_d(:, i), d_d(:, i), s_d(:, i)]=Washer(u_w(:, i), d_w(:, i), u_d(:, i), d_d(:, i));

              
%% If not, then local pollination of neighbor flowers.
% Find random flowers in the neighbourhood.
% Formula: x_i^{t+1}+epsilon*(x_j^t-x_k^t)
        

          else              
      
              %Fridge
              epsilon_fr=round(rand);
              if epsilon_fr==0
                  epsilon_fr=-1;
              end
              JK_fr=randperm(n);
              j=s_fr(:, JK_fr(1))==0;
              s_fr(j, JK_fr(1))=-1;
              j=s_fr(:, JK_fr(2))==0;
              s_fr(j, JK_fr(2))=-1;
              j=s_fr(:, i)==0;
              s_fr(j, i)=-1;
              s_fr(:,i)=s_fr(:,i)+epsilon_fr*(s_fr(:, JK_fr(1))-s_fr(:, JK_fr(2)));
              j=s_fr(:,i)>0;
              s_fr(j, i)=1;
              j=s_fr(:,i)<0;
              s_fr(j, i)=0;
                            
              %AC/Inverter
              epsilon_ac=round(rand);
              if epsilon_ac==0
                  epsilon_ac=-1;
              end
              JK_ac=randperm(n);
              j=s_ac(:, JK_ac(1))==0;
              s_ac(j, JK_ac(1))=-1;
              j=s_ac(:, JK_ac(2))==0;
              s_ac(j, JK_ac(2))=-1;
              j=s_ac(:, i)==0;
              s_ac(j, i)=-1;
              s_ac(:,i)=s_ac(:,i)+epsilon_ac*(s_ac(:, JK_ac(1))-s_ac(:, JK_ac(2)));
              j=s_ac(:,i)>0;
              s_ac(j, i)=1;
              j=s_ac(:,i)<0;
              s_ac(j, i)=0;
              
              %Water Heater
              epsilon_wh=round(rand);
              if epsilon_wh==0
                  epsilon_wh=-1;
              end
              JK_wh=randperm(n);
              j=s_wh(:, JK_wh(1))==0;
              s_wh(j, JK_wh(1))=-1;
              j=s_wh(:, JK_wh(2))==0;
              s_wh(j, JK_wh(2))=-1;
              j=s_wh(:, i)==0;
              s_wh(j, i)=-1;
              s_wh(:,i)=s_wh(:,i)+epsilon_wh*(s_wh(:, JK_wh(1))-s_wh(:, JK_wh(2)));
              j=s_wh(:,i)>0;
              s_wh(j, i)=1;
              j=s_wh(:,i)<0;
              s_wh(j, i)=0;
              
              %Tub Heater
              epsilon_th=round(rand);
              JK_th=randperm(n);
              s_th(:,i)=s_th(:,i)+epsilon_th*abs(s_th(:, JK_th(1))-s_th(:, JK_th(2)));
              j=s_th(:,i)==2;
              s_th(j, i)=0;
              
              %Dish Washer
              epsilon_dw=rand;
              JK_dw=randperm(n);
              t_dw(:,i)=t_dw(:,i)+round(epsilon_dw*(t_dw(:, JK_dw(1))-t_dw(:, JK_dw(2))));
              j=t_dw(:, i)>Lt_dw;
              t_dw(j, i)=Lt_dw;
              j=t_dw(:, i)<Et_dw;
              t_dw(j, i)=Et_dw;
              u_dw(:, i)=0;
              u_dw(t_dw(:, i), i)=1;
              
              %ESD
              epsilon_esd=round(rand);
              if epsilon_esd==0
                  epsilon_esd=-1;
              end
              JK_esd=randperm(n);
              j=s_esd(:, JK_esd(1))==0;
              s_esd(j, JK_esd(1))=-1;
              j=s_esd(:, JK_esd(2))==0;
              s_esd(j, JK_esd(2))=-1;
              j=s_esd(:, i)==0;
              s_esd(j, i)=-1;
              s_esd(:,i)=s_esd(:,i)+epsilon_esd*(s_esd(:, JK_esd(1))-s_esd(:, JK_esd(2)));
              j=s_esd(:,i)>0;
              s_esd(j, i)=1;
              j=s_esd(:,i)<0;
              s_esd(j, i)=0;
              j=s_esd(:, i)==1;
              u_esd(:, i)=0;
              u_esd(j, i)=1;
              j=s_esd(:, i)==0;
              d_esd(:, i)=0;
              d_esd(j, i)=1;
              
                       
              %Pool Pump
              epsilon_pp=rand;
              JK_pp=randperm(n);
              t_pp(:,i)=t_pp(:,i)+round(epsilon_pp*(t_pp(:, JK_dw(1))-t_pp(:, JK_dw(2))));
              j=t_pp(:, i)>Lt_pp-mso_pp;
              t_pp(j, i)=Lt_pp-mso_pp;
              j=t_pp(:, i)<Et_pp;
              t_pp(j, i)=Et_pp;
              u_pp(:, i)=0;
              u_pp(t_pp(:, i), i)=1;
              
              %Stove
              epsilon_st=rand;
              JK_st=randperm(n);
              t_st(:,i)=t_st(:,i)+round(epsilon_st*(t_st(:, JK_dw(1))-t_st(:, JK_dw(2))));
              j=t_st(:, i)>Lt_st;
              t_st(j, i)=Lt_st;
              j=t_st(:, i)<Et_st;
              t_st(j, i)=Et_st;
              u_st(:, i)=0;
              u_st(t_st(:, i), i)=1;
              
              %Washer/Dryer
              epsilon_w=rand;
              JK_w=randperm(n);
              t_w(:,i)=t_w(:,i)+round(epsilon_w*(t_w(:, JK_dw(1))-t_w(:, JK_dw(2))));
              j=t_w(:, i)>Lt_w;
              t_w(j, i)=Lt_w;
              j=t_w(:, i)<Et_w;
              t_w(j, i)=Et_w;
              u_w(:, i)=0;
              u_w(t_w(:, i), i)=1;
              
              epsilon_d=rand;
              JK_d=randperm(n);
              t_d(:,i)=t_d(:,i)+round(epsilon_d*(t_d(:, JK_dw(1))-t_d(:, JK_dw(2))));
              j=t_d(:, i)>Lt_w;
              t_d(j, i)=Lt_w;
              j=t_d(:, i)<Et_w;
              t_d(j, i)=Et_w;
              u_d(:, i)=0;
              u_d(t_d(:, i), i)=1;
              
              % Check if the simple limits/bounds are OK
              
              %Fridge
              [s_fr(:, i), Temp_fr(:, i)]=Fridge(s_fr(:, i), Tmax_fr, Tmin_fr, Temp_fr(:, i), taw_ac, T, Et_fr, Lt_fr, OFF_fr, ON_fr, Leak_fr, A_fr);
              
              %AC/Heater
              [s_ac(:, i), Temp_in(:, i)]=ACI(s_ac(:, i), Tmax_in, Tmin_in, Temp_in(:, i), taw_ac, T, OFF_ac, ON_ac, Leak_ac, A_ac, Tout);
              
              %Water Heater
              [s_wh(:, i), Temp_wh(:, i)]=WHeater(s_wh(:, i), Tmax_wh, Tmin_wh, Temp_wh(:, i), taw, T, Et_wh, Lt_wh, OFF_wh, ON_wh, Leak_wh, A_wh);
              
              %Tube Heater
              [s_th(:, i)]=THeater(s_th(:, i), taw, T, Et_th, Lt_th);
              
              %Dish Washer
              [u_dw(:, i), d_dw(:, i), s_dw(:, i)]=DWasher(u_dw(:, i), d_dw(:, i), taw, T, Et_dw, Lt_dw, rot_dw, mso_dw, mu_dw, md_dw, M_dw);
              
              %ESD
              [u_esd(:, i), d_esd(:, i), a_esd(:, i), s_esd(:, i), C_esd(:, i), delta_esd(:, i)]=ESD(u_esd(:, i), d_esd(:, i), C_esd(:, i), taw, T, Emax_esd, Emin_esd, mu_esd, md_esd, Cc_esd, Cd_esd);
              
              %Pool Pump
              [u_pp(:, i), d_pp(:, i), s_pp(:, i)]=PPump(u_pp(:, i), d_pp(:, i), taw, T, Et_pp, Lt_pp, rot_pp, mso_pp, mu_pp, md_pp, M_pp);
              
              %Stove
              [u_st(:, i), d_st(:, i), s_st(:, i)]=Stove(u_st(:, i), d_st(:, i), taw, T, Et_st, Lt_st, rot_st, mso_st, mu_st, M_st);
    
              %Washer/Dryer
              [u_w(:, i), d_w(:, i), s_w(:, i), u_d(:, i), d_d(:, i), s_d(:, i)]=Washer(u_w(:, i), d_w(:, i), u_d(:, i), d_d(:, i));
              
          end
 
          
 %% Evaluate new solutions
 
          [Fnew, E1_new, E2_new, E3_new, E4_new, E5_new, E6_new, E7_new, E8_new, E9_new, E10_new, E11_new, Po_max, ECo]=J(s_fr(:,i), Temp_fr(:, i), s_ac(:, i), Temp_in(:, i), s_wh(:,i), Temp_wh(:, i), s_dw(:,i), s_esd(:, i), a_esd(:, i), s_pp(:,i), s_st(:,i), s_l(:,i), s_th(:,i), s_w(:, i), s_d(:, i));
          
          % Update the current global best
          if Fnew<=fmin && sum(s_d(:, i))==rot_w && sum(s_pp(:, i))==rot_pp && sum(s_st(:, i))==rot_st && sum(s_dw(:, i))==rot_dw && sum(s_th(:, i))==4
                fmin=Fnew;
                
                %Fridge
                best_fr=s_fr(:,i);
                Tbest_fr=Temp_fr(:, i);
                E_fr=E1_new(1);
                C_fr=E1_new(2);
                
                %AC/Inverter
                best_ac=s_ac(:, i);
                Tbest_in=Temp_in(:, i);
                E_ac=E2_new(1);
                C_ac=E2_new(2);
                
                %Water Heater
                best_wh=s_wh(:,i);
                Tbest_wh=Temp_wh(:, i);
                E_wh=E3_new(1);
                C_wh=E3_new(2);
                
                %Dish Washer
                best_dw=s_dw(:,i);
                ubest_dw=u_dw(:, i);
                dbest_dw=d_dw(:, i);
                E_dw=E4_new(1);
                C_dw=E4_new(2);
                
                %ESD
                best_esd=s_esd(:,i);
                ubest_esd=u_esd(:, i);
                dbest_esd=d_esd(:, i);
                abest_esd=a_esd(:, i);
                Ebest_esd=C_esd(:, i);
                E_esd=E5_new(1);
                Co_esd=E5_new(2);
                
                %Pool Pump
                best_pp=s_pp(:,i);
                ubest_pp=u_pp(:, i);
                dbest_pp=d_pp(:, i);
                E_pp=E6_new(1);
                C_pp=E6_new(2);
                
                %Stove
                best_st=s_st(:,i);
                ubest_st=u_st(:, i);
                dbest_st=d_st(:, i);
                E_st=E7_new(1);
                C_st=E7_new(2);
                
                %Lights
                best_l=s_l(:,i);
                E_l=E8_new(1);
                C_l=E8_new(2);
                
                %Tube Heater
                best_th=s_th(:,i);
                E_th=E9_new(1);
                C_th=E9_new(2);
            
                %Washer/Dryer
                best_w=s_w(:,i);
                ubest_w=u_w(:, i);
                dbest_w=d_w(:, i);
                E_w=E10_new(1);
                C_w=E10_new(2);
                best_d=s_d(:,i);
                ubest_d=u_d(:, i);
                dbest_d=d_d(:, i);
                E_d=E11_new(1);
                C_d=E11_new(2);
                
                %Peak load and emissions cost
                Pbest_max=Po_max;
                ECbest=ECo;
          
          end
          
    end
    
%% Display results every 10 iterations
        if round(u/10)==u/10,   
       
            %fmin and u
            fmin
            u
%             E_gh=2*E_wh;
%             Pem=P_wh*best_wh+P_dw*best_dw+P_pp*best_pp+P_st*best_st+P_l*best_l+P_th*best_th+P_w*best_w+P_d*best_d-P_esd*best_esd;
%             Pem_ac=P_fr*best_fr+P_ac*best_ac;
%             Emission=sum(Pem.*(Rc*Sc'+Rg*Sg'))*(15*1e-3/60)+sum(Pem_ac.*(Rc*Sc_ac'+Rg*Sg_ac'))*(7.5*1e-3/60)+E_gh*Rg
%             ECbest
%             E_total=E_fr+E_ac+E_wh+E_dw+E_pp+E_st+E_l+E_th+E_w+E_d
            E_ac
            C_total=C_fr+C_ac+C_wh+C_dw+C_pp+C_st+C_l+C_th+C_w+C_d
            Pbest_max
        end
        
end


