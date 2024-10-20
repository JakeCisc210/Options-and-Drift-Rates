function [expected_value,variance] = black_scholes_expected_value(spot_price,mu,sigma,time_to_expiration,option_type,option_price,strike_price,opt)
    % NOT Time Discounted
    arguments
        spot_price = 305;
        mu = .09;
        sigma = .21;
        time_to_expiration = 3/52;
        option_type = 'Call';
        option_price = 4.95;
        strike_price = 320;
        opt.max_price = 600;
    end

    S0 = spot_price;
    T = time_to_expiration;
    K = strike_price;

    % Probability Density of Spot Price at Expiration
    % As per Black Scholes 
    prob_density = @(S) exp(-power(log(S/S0)-(mu+sigma^2/2)*T,2)/2/(sigma*sqrt(T))^2)/sqrt(2*pi)/(sigma*sqrt(T))./S;

    if strcmpi(option_type,'Call')
        expected_value = integral(@(S) prob_density(S).*(max(S-K,0)-option_price),0,opt.max_price);
        variance = integral(@(S) prob_density(S).*(max(S-K,0)-option_price-expected_value).^2,0,opt.max_price);
    elseif strcmpi(option_type,'Put')
        expected_value = integral(@(S) prob_density(S).*(max(K-S,0)-option_price),0,opt.max_price);
        variance = integral(@(S) prob_density(S).*(max(K-S,0)-option_price-expected_value).^2,0,opt.max_price);
    else
        error('Incorrect Option Type')
    end

end