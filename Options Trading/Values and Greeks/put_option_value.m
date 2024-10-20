function c = put_option_value(S0,K,T,sigma,r)
    arguments
        S0 = 100;    % Current Asset Price
        K = 110;     % Strike Price
        T = 3;       % Time to Expiration
        sigma = .12;  % Volatility
        r = .05;     % Risk Free Rate
    end

    d_plus = (log(S0/K)+(r+power(sigma,2)/2)*T)/sqrt(T)/sigma;
    d_minus = d_plus - sigma*sqrt(T);

    c = K*exp(-r*T)*normcdf(-d_minus)-S0*normcdf(-d_plus);
end