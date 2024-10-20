function adjustable_bachelier_diagram()
    arguments
    end
    
    % Figure + Axis Set Up
    myFigure = uifigure('Name','Moneyline for Adjusted Money Density','Position',[200 75 1200 670]);
    myAxes = uiaxes(myFigure,'Position',[50 100 1100 500]);
    myAxes.FontSize = 20; myAxes.FontWeight = 'bold'; myAxes.LineWidth = 2; 
    myAxes.Title.String = 'Payoff vs. S(T)';
    myAxes.Subtitle.String = 'Bachelier Distribution';
    myAxes.XAxis.Label.String = 'S(T)'; myAxes.YAxis.Label.String = 'Payoff';
    myAxes.NextPlot = 'add'; % hold on equivalent for UI Axes

    % Adding the Sliders
    uilabel(myFigure,'Text','Option Price','Position',[775 65 100 50],'FontSize',16,'FontWeight','bold');
    option_price_slider = uislider(myFigure,'Position',[730 70 200 50],...
        'Limits',[0,10],'Value',5,'MajorTicks',...
        0:10);
      
    expectation_value_label = uilabel(myFigure,'Text','Slide to Fill','Position',[200 450 300 50],'FontSize',16,'FontWeight','bold');
       
    option_price_slider.ValueChangedFcn = @(inputSlider,event) option_price_callback(inputSlider,myAxes,expectation_value_label);
end
    
    

function option_price_callback(inputSlider,axes_handle,ev_label)
    cla(axes_handle)

    mu = 100;
    sigma = 10;
    prob_S = @(T) exp(-power(T-mu,2)/2/power(sigma,2)); % Bachelier Distribution

    K = 100;
    c = inputSlider.Value;
    option_payoff = @(T) max(0,T-K)-c;

    expected_value = @(T) prob_S(T).*option_payoff(T);

    plot(axes_handle,1:150,40*prob_S(1:150),'Color',[0 0 0],'LineStyle','--','LineWidth',2) % Kentucky Windage with "Normalization"
    plot(axes_handle,1:150,option_payoff(1:150),'Color',[0 0 0],'LineWidth',2)
    plot(axes_handle,1:150,expected_value(1:150),'Color',[0 0 0])

    % Shade In Expected Value Areas

    % Negative Expectation
    xReds = horzcat((mu-3*sigma):.001:(K+c),flip((mu-3*sigma):.001:(K+c)));
    yReds = horzcat(expected_value((mu-3*sigma):.001:(K+c)),zeros(1,length((mu-3*sigma):.001:(K+c))));
    neg_patch = patch(axes_handle,xReds,yReds,[255,114,118]/255);

    % Positive Expectation
    xGreens = horzcat((K+c):.001:(mu+3*sigma),flip((K+c):.001:(mu+3*sigma)));
    yGreens = horzcat(expected_value((K+c):.001:(mu+3*sigma)),zeros(1,length((K+c):.001:(mu+3*sigma))));
    pos_patch = patch(axes_handle,xGreens,yGreens,[144,238,144]/255);

    legend(axes_handle,{'Probability','Option Payoff','','Negative Expecation','Positive Expectation'})
    neg_patch.LineWidth = 1/2;
    pos_patch.LineWidth = 1/2;

    real_normalization = 1/sqrt(2*pi)/sigma;
    expectation_value = integral(@(T) real_normalization*expected_value(T),mu-5*sigma,mu+5*sigma);

    ev_label.Text = sprintf('Expected Value: %.2g',expectation_value);

end

% TODO: Waitbar for when it's loading 

% Textbox to display option price

% Way for users to directly input option price