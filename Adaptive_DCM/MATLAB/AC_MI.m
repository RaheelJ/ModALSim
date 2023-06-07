function dy=AC_MI(t, y, A, B, ut, tu, Am, P)
dy=zeros(11, 1);
dx=zeros(3, 1);         %Derivative of system states
dx_=zeros(3, 1);        %Derivative of estimator states
da=zeros(4, 1);         %Derivative unknown A parameters
db=zeros(1, 1);         %Derivative of unknown B parameters
x=zeros(3, 1);          
x_=zeros(3, 1);
a=zeros(4, 1);
b=zeros(1, 1);

for i=1:3
    dx(i)=dy(i);
    x(i)=y(i);
end

for i=1:3
    dx_(i)=dy(3+i);
    x_(i)=y(3+i);
end

for i=1:4
    da(i)=dy(6+i);
    a(i)=y(6+i);
end

db=dy(11);
b=y(11);

A_=[a(1) 0 a(2); 0 0 1; a(3) 0 a(4)];
B_=[b; 0; 0];
u=interp1(tu, ut, t);

dx=A*x+B*u;                 %System Model
dx_=A_*x+B_*u+Am*(x_-x);    %Estimator Model

Temp1=-P*(x_-x)*x';         %Adaptation law for A parameters
da(1)=Temp1(1, 1);
da(2)=Temp1(1, 3);
da(3)=Temp1(3, 1);
da(4)=Temp1(3, 3);

Temp2=-P*(x_-x)*u;          %Adaptation law for B parameter
db=Temp2(1);

dy(1:3)=dx;
dy(4:6)=dx_;
dy(7:10)=da;
dy(11)=db;

end


