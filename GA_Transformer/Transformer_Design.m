clear
clc
% Specifications of Transformer RMS values are given
Vprim=220
Vsec=500
Isec=10
f=50;
Bm=1.8;
Ac=26
J=3.5
FF=0.4

% Calulation of required parameters for optimization 
w=2*pi*f;
Vp=sqrt(2)*Vprim;
Vs=sqrt(2)*Vsec;
Is=sqrt(2)*Isec;
TR=Vs/Vp;
Ip=Is*TR;
Iprim=Ip/sqrt(2)
Np=ceil(10000*Vp/(w*Ac*Bm))
Ns=ceil(Np*TR)
Acp=Iprim/(100*J)
Acp=Np*Acp;
Acs=Isec/(100*J)
Acs=Ns*Acs;
Aw=(1/FF)*(Acs+Acp)
% Setting the range of a & h 
a=1:(Ac-1)/20:Ac;
h=1:(power(Aw, 0.58)-1)/20:power(Aw, 0.58);

% Number of iterations
for x=1:20
    % Generation of Off Springs
    for y=1:20
        ao(y)=(a(y)+a(y+1))/2;
        ho(y)=(h(y)+h(y+1))/2;
    end
    ao(21)=a(21);
    ho(21)=h(21);
    % Mutation
    for z=1:2
        p=randi([1, 21]);
        q=randi([1, 21]);
        r=randi([1, 21]);
        ao(r)=(a(p)+a(q))/2;
        ho(r)=(h(p)+h(r))/2;
    end
    % Calculation of d and b for parents and off springs
    d=Ac./a;
    b=Aw./h;
    do=Ac./ao;
    bo=Aw./ho;
    % Calculation of Volumes and Weights for Parents
    for s=1:21
        for t=1:21
    Vc(s, t)=2*(h(t)+0.4)*a(s)*d(s)+2*(a(s)+b(t)+0.2)*(a(s)*d(s));
    Vcu(s, t)=2*h(t)*b(t)*(a(s)+d(s)+0.8)+pi*b(t)*b(t)*h(t);
        end
    end
    Wc=(Vc).*(7650/1000000);
    Wcu=(Vcu.*FF).*(8960/1000000);
    W=Wc+Wcu;
    % Calculation of Volumes and Weights for off springs
    for s=1:21
        for t=1:21
    Vco(s, t)=2*(ho(t)+0.4)*ao(s)*do(s)+2*(ao(s)+bo(t)+0.2)*(ao(s)*do(s));
    Vcuo(s, t)=2*ho(t)*bo(t)*(ao(s)+do(s)+0.8)+pi*bo(t)*bo(t)*ho(t);
        end
    end
    Wco=(Vco).*(7650/1000000);
    Wcuo=(Vcuo.*FF).*(8960/1000000);
    Wo=Wco+Wcuo;
    % Comparing for fitness
    for s=1:21
        [k, l]=min(W(:, s));
        [m, n]=min(Wo(:, s));
        if(k>m)
            h(s)=ho(s);
            b(s)=bo(s);
            a(s)=ao(n);
            d(s)=do(n);
    end
    end
end

% Showing the Results
[m, n]=min(min(W));
Wm=m
hm=h(n)
bm=b(n)
[x, y]=min(W(:, n));
am=a(y)
dm=d(y)
Vcm=2*(hm+0.4)*am*dm+2*(am+bm+0.2)*(am*dm)
Vcum=2*hm*bm*(am+dm+0.8)+pi*bm*bm*hm

        

    


