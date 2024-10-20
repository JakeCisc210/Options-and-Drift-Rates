function [chi_square_value,degree_fredom] = compare_with_standard_normal(data_set)

    % Chi Square Test by Binning Data Set in Groups of 10
    % Thus, Data Set should a number of values divisible by 10
    
    arguments
        data_set = randn(1,1000);
    end
    
    sorted_data_set = sort(data_set);
    group_barriers = sorted_data_set(10:10:length(data_set));
    cdf_values = horzcat(0,cdf('Normal',group_barriers,0,1),1);
    
    chi_square_value = 0;
    observed = 10;
    for ii = 1:length(cdf_values)-1
        expected = length(data_set)*(cdf_values(ii+1)-cdf_values(ii));
        chi_square_value = chi_square_value + power(expected-observed,2)/expected;
    end
    degree_fredom = length(data_set)-1;
end