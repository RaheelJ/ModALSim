A=[12, 10, -7; 6, 5, 3; 5, -1, 5];
B=[15, 14, 9];

if(abs(A(1, 1))<abs(A(2, 1)))   % Comparing Elements in 1st Column Before starting operations
    temp=A(1, :);
    temp2=B(1);
    A(1, :)=A(2, :);
    B(1)=B(2);
    A(2, :)=temp;
    B(2)=temp2;
end

if(abs(A(2, 1))<abs(A(3, 1)))
    temp=A(2, :);
    temp2=B(2);
    A(2, :)=A(3, :);
    B(2)=B(3);
    A(3, :)=temp;
    B(3)=temp2;
end

if(abs(A(1, 1))<abs(A(3 , 1)))
    temp=A(1, :);
    temp2=B(1);
    A(1, :)=A(3, :);
    B(1)=B(3);
    A(3, :)=temp;
    B(3)=temp2;
end

factor=A(2, 1)/A(1, 1);
A(2, :)=A(2, :)-factor*A(1, :);
B(2)=B(2)-factor*B(1);
 
factor=A(3, 1)/A(1, 1);
A(3, :)=A(3, :)-factor*A(1, :);
B(3)=B(3)-factor*B(1);

if(abs(A(2, 2))<abs(A(3, 2)))   % Comparison in 2nd Column after 1st step of elimination
    temp=A(2, :);
    temp2=B(2);
    A(2, :)=A(3, :);
    B(2)=B(3);
    A(3, :)=temp;
    B(3)=temp2;
end

factor=A(3, 2)/A(2, 2);
A(3, 2)=A(3, 2)-factor*A(2, 2);
A(3, 3)=A(3, 3)-factor*A(2, 3)
B(3)=B(3)-factor*B(2)
 
x(3)=B(3)/A(3, 3);
 
sum=B(2);
sum=sum-A(2, 3)*x(3);
x(2)=sum/A(2, 2);
 
sum=B(1);
sum=sum-A(1, 3)*x(3);
sum=sum-A(1, 2)*x(2);
x(1)=sum/A(1, 1);
 
X=[x(1); x(2); x(3)]
 
