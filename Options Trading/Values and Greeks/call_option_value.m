function c = call_option_value(S0,K,T,sigma,r)
    arguments
        S0 = 90;    % Current Asset Price
        K = 105;     % Strike Price
        T = 7;       % Time to Expiration
        sigma = .17;  % Volatility
        r = .06;     % Risk Free Rate
    end

    d_plus = (log(S0/K)+(r+power(sigma,2)/2)*T)/sqrt(T)/sigma;
    d_minus = d_plus - sigma*sqrt(T);

    c = S0*normcdf(d_plus)-K*exp(-r*T)*normcdf(d_minus);
end