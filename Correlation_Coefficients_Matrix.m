function [Correlation_Coef_Matrix] = Correlation_Coefficients_Matrix(samples_Matrix)
    [L,d]=size(samples_Matrix);
    %%% Estimating the second order moment%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    second_order_moments_matrix=samples_Matrix'*samples_Matrix/L;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%% Calculate the average of closing prices and the standard deviations%%%%
    mean_values=zeros(1,d);
    standard_deviations=zeros(1,d);
    for i=1:d
        mean_values(1,i)=sum(samples_Matrix(:,i))/L;
        standard_deviations(i)=sqrt(second_order_moments_matrix(i,i)-mean_values(1,i)^2);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %%% Calculate the Correlation Coefficients Matrix
    prod_of_means=mean_values'*mean_values; % Outer product to find all the values E[X]*E[Y]
    prod_of_standard_deviations=standard_deviations'*standard_deviations; % Outer product to find all the values sqrt(E[X^2]-E[X]^2)*sqrt(E[Y^2]-E[Y]^2)
    Correlation_Coef_Matrix=(second_order_moments_matrix-prod_of_means)./prod_of_standard_deviations;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

