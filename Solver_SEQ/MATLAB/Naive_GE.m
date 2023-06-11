    for k=1:2
        for i=k+1:3
            factor=A(i, k)/A(k, k);
            for j=k:3
                A(i, j)=A(i, j)-factor*A(k, j);
            end
            B(i)=B(i)-factor*B(k);
        end
    end
    X(3)=B(3)/A(3, 3);
    for i=2:-1:1
        sum=B(i);
        for j=3:-1:i+1
            sum=sum-A(i, j)*X(j);
        end
        X(i)=sum/A(i, i);
    end
