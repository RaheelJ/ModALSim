function out=Lagrange_Lin(X, Y, xx)
L(1)=(xx-X(2))/(X(1)-X(2));
L(2)=(xx-X(1))/(X(2)-X(1));
out=Y(1)*L(1)+Y(2)*L(2);
end