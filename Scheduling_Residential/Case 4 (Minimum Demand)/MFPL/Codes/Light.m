function L=Light(Lo, Lr, A, taw, T)

L=zeros(1, taw*T);

for t=1:taw*T

    if(Lr(ceil(t/taw)))*(1+A(ceil(t/taw)))>Lo(ceil(t/taw))
        L(t)=ceil(Lr(ceil(t/taw))*(1+A(ceil(t/taw)))-Lo(ceil(t/taw)));
    else
       L(t)=0;
    end
end

end

    