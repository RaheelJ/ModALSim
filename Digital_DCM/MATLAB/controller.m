function u_k=controller(e, u, k, num, den)
u_k=-den(2)*u(k-1)+num(1)*e(k)+num(2)*e(k-1);
end

