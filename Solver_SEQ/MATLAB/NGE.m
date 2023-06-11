 factor=A(2, 1)/A(1, 1);
 A(2, 1)=A(2, 1)-factor*A(1, 1);
 A(2, 2)=A(2, 2)-factor*A(1, 2);
 A(2, 3)=A(2, 3)-factor*A(1, 3);
 B(2)=B(2)-factor*B(1);
 
 factor=A(3, 1)/A(1, 1);
 A(3, 1)=A(3, 1)-factor*A(1, 1);
 A(3, 2)=A(3, 2)-factor*A(1, 2);
 A(3, 3)=A(3, 3)-factor*A(1, 3);
 B(3)=B(3)-factor*B(1);
 
 factor=A(3, 2)/A(2, 2);
 A(3, 2)=A(3, 2)-factor*A(2, 2);
 A(3, 3)=A(3, 3)-factor*A(2, 3);
 B(3)=B(3)-factor*B(2);  
 
 x(3)=B(3)/A(3, 3);
 
 sum=B(2);
 sum=sum-A(2, 3)*X(3);
 x(2)=sum/A(2, 2);
 
 sum=B(1);
 sum=sum-A(1, 3)*X(3);
 sum=sum-A(1, 2)*X(2);
 x(1)=sum/A(1, 1);
 
 X=[x(1); x(2); x(3)]