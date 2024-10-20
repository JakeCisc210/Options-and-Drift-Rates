function results = geometric_parameters(SValues,dt)
    arguments
        SValues = [3 4 5 6 7];
        dt = 1;
    end
    
    n = length(SValues);
    dS_over_S = diff(SValues)./SValues(1:end-1);

    x_bar = mean(dS_over_S)./dt;
    s = std(dS_over_S)./sqrt(dt);
    p_value = .95; % For confidence intervals
    z = norminv((1+p_value)/2);

    mean_interval = [x_bar-z*s/sqrt(n), x_bar+z*s/sqrt(n)];
    stdev_interval =  [sqrt((n-1)/chi2inv((1+p_value)/2,n-1)) sqrt((n-1)/chi2inv((1-p_value)/2,n-1))].*s;

    precision_level = .001;
    mean_interval = round(mean_interval,-log10(precision_level));
    stdev_interval = round(stdev_interval,-log10(precision_level));

    mean_range = mean_interval(1):precision_level:mean_interval(2);
    stdev_range = stdev_interval(1):precision_level:stdev_interval(2);

    lowest_chi_square_value = inf;
    best_mu = nan;
    best_sigma = nan;

    for ii = 1:length(mean_range)
        for jj = 1:length(stdev_range)
            mu = mean_range(ii);
            sigma = stdev_range(jj);
            z_score_set = (dS_over_S-mu)/sigma;
            chi_square_value = compare_with_standard_normal(z_score_set);
            if chi_square_value < lowest_chi_square_value
                best_mu = mu;
                best_sigma = sigma;
                lowest_chi_square_value = chi_square_value;
            end
        end
    end

    results.mu_interval = mean_interval;
    results.sigma_interval = stdev_interval;
    results.mu = best_mu;
    results.sigma = best_sigma;