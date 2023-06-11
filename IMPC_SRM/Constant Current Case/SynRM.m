function dx=SynRM(t, x, V1, V2, V3, tv, R, Lq, Ld, J, T, B, P)

% x(1)=iq
% x(2)=id
% x(3)=wr
% x(4)=theta

Va=V1;
Vb=V2;
Vc=V3;

% Va=interp1(tv, V1, t);
% Vb=interp1(tv, V2, t);
% Vc=interp1(tv, V3, t);

dx=zeros(4, 1);
dx(1)=-(R/Lq)*x(1)-(Ld/Lq)*x(2)*x(3)+(2/(3*Lq))*(-sin(x(3)*t)*Va-sin(x(3)*t-2*pi/3)*Vb-sin(x(3)*t+2*pi/3)*Vc);
dx(2)=(Lq/Ld)*x(1)*x(3)-(R/Ld)*x(2)+(2/(3*Ld))*(cos(x(3)*t)*Va+cos(x(3)*t-2*pi/3)*Vb+cos(x(3)*t+2*pi/3)*Vc);
% dx(1)=-(R/Lq)*x(1)-(Ld/Lq)*x(2)*x(3)+(2/(3*Lq))*(-sin(x(4))*Va-sin(x(4)-2*pi/3)*Vb-sin(x(4)+2*pi/3)*Vc);
% dx(2)=(Lq/Ld)*x(1)*x(3)-(R/Ld)*x(2)+(2/(3*Ld))*(cos(x(4))*Va+cos(x(4)-2*pi/3)*Vb+cos(x(4)+2*pi/3)*Vc);
dx(3)=(1.5*P/J)*(Ld-Lq)*x(1)*x(2)-(T/J)-(B/J);
dx(4)=x(3);

end

