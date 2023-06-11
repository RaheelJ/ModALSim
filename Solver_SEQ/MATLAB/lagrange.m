function out=lagrange(x, y, n, xx)
    sum=0;
    for i=1:n+1
        product=y(i);
        for j=1:n+1
            if(i~=j)
                product=product*(xx-x(j))/(x(i)-x(j));
            end
        end
        sum=sum+product;
    end
    out=sum;
end
    