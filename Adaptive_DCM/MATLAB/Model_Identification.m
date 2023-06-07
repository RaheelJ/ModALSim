function dy=Par_Identify(t, y)

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

db(1)=dy(11);
b(1)=y(11);

A_=[a(1) 0 a(2); 0 0 1; a(3) 0 a(4)];
B_=[b(1); 0; 0];
u=10;

dx=A*x+B*u;
dx_=A

