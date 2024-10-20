function delta = find_delta(S0,K,r,sigma,T)
    d1 = (log(S0/K) + (r+sigma^2/2)*T)/sigma/sqrt(T);
    delta = normcdf(d1) - 1;
end