function [tValues,SValues] = geometric_brownian_motion(S0,T,n,mu,sigma)
    dt = T/(n-1);
    tValues = 0:dt:T;

    Scurrent = S0;
    SValues = zeros(1,n);
    SValues(1) = Scurrent;
    for jj = 1:n-1
        Scurrent = SValues(jj) + mu*SValues(jj)*dt + sigma*SValues(jj)*sqrt(dt)*normrnd(0,1);
        SValues(jj+1) = Scurrent;
    end
end
