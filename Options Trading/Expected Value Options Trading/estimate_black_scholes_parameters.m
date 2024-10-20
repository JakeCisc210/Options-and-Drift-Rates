function black_scholes_params = estimate_black_scholes_parameters(stock_data,spot_price,data_timeframe)


    arguments
        stock_data = struct();
        spot_price = 'Open';
        data_timeframe = 1; % in years
    end

    if strcmpi(spot_price,'Open')
        stock_prices = [stock_data.Open];
    elseif strcmpi(spot_price,'Low')
        stock_prices = [stock_data.Low];
    elseif strcmpi(spot_price,'High')
        stock_prices = [stock_data.High];
    elseif strcmpi(spot_price,'Close')
        stock_prices = [stock_data.Close];
    elseif strcmpi(spot_price,'AdjClose')
        stock_prices = [stock_data.AdjClose];
    else
        error('Wrong Spot Pice Option Selected')
    end

    dS_over_S = diff(stock_prices)./stock_prices(1:(end-1));
    dt = data_timeframe/length(stock_prices); 

    % Metropolis-Hastings MCMC algorithm to estimate mean and std
    data = dS_over_S;
    numIterations = 5000; % Number of MCMC iterations
    burnIn = 1000; % Number of burn-in samples to discard
    mean_samples = zeros(numIterations, 1);
    stdev_samples = zeros(numIterations, 1);

    % Initial guesses
    mean_current = mean(data);
    stdev_current = std(data);

    % Proposals
    mean_proposal_start = 0.08*dt;
    stdev_proposal_start = .2*sqrt(dt);

    % Log-Likelihood function
    log_likelihood = @(mu, sigma) sum(log(normpdf(data, mu, sigma)));

    % Log of Prior distributions
    log_prior_mu = @(mu) log(normpdf(mu, 0.08*dt, .05*dt));
    log_prior_sigma = @(sigma) log(normpdf(sigma, .2*sqrt(dt), .2*sqrt(dt)));

    % MCMC sampling
    for index = 1:numIterations
        % Propose new mu and sigma
        mean_proposal = normrnd(mean_current, mean_proposal_start);
        stdev_proposal = abs(normrnd(stdev_current, stdev_proposal_start)); % sigma must be positive

        % Compute log-likelihoods
        log_likelihood_current = log_likelihood(mean_current, stdev_current);
        log_likelihood_proposal = log_likelihood(mean_proposal, stdev_proposal);

        % Compute log-priors
        log_prior_current = log_prior_mu(mean_current) + log_prior_sigma(stdev_current);
        log_prior_proposal = log_prior_mu(mean_proposal) + log_prior_sigma(stdev_proposal);

        % Compute acceptance ratio
        log_acceptance_ratio = (log_likelihood_proposal + log_prior_proposal) - ...
            (log_likelihood_current + log_prior_current);

        % Accept or reject
        if log(rand) < log_acceptance_ratio
            mean_current = mean_proposal;
            stdev_current = stdev_proposal;
        end

        % Store samples
        mean_samples(index) = mean_current;
        stdev_samples(index) = stdev_current;
    end

    % Discard burn-in samples
    mean_samples = mean_samples(burnIn+1:end);
    stdev_samples = stdev_samples(burnIn+1:end);

    % Estimate parameters (posterior mean)
    mean_estimate = mean(mean_samples);
    stdev_estimate = mean(stdev_samples);

    mean_samples = sort(mean_samples);
    mean_interval = [mean_samples(floor(length(mean_samples)/20)) mean_samples(ceil(19*length(mean_samples)/20))]; % 95% Interval

    stdev_samples = sort(stdev_samples);
    stdev_interval = [stdev_samples(floor(length(stdev_samples)/20)) stdev_samples(ceil(19*length(stdev_samples)/20))]; % 95% Interva

    black_scholes_params.best_mu = mean_estimate/dt;
    black_scholes_params.best_sigma = stdev_estimate/sqrt(dt);

    black_scholes_params.mu_interval = mean_interval/dt;
    black_scholes_params.sigma_interval = stdev_interval/sqrt(dt);

    black_scholes_params.mu_min = black_scholes_params.mu_interval(1);
    black_scholes_params.mu_max = black_scholes_params.mu_interval(2);
    black_scholes_params.sigma_min = black_scholes_params.sigma_interval(1);
    black_scholes_params.sigma_max = black_scholes_params.sigma_interval(2);
end