%%% Estimate the average number of mismatched edges for a fixed value of q by using k number of (noisy) samples through runs=100 independent runs
%Requires: Synthetic Samples noisy, the number of samples k, the value of
%cross-over probability q, the adjacency matrix of the original Tree G, the values of N and d
%Returns: The estimated number of mismatched edges
function [average_error] = Monte_Carlo_Iterations_Stock_Market(N,d,q,runs,samples,k,Tree)
    error=0;
    parfor iter=1:runs
        noise=ones(N-1,d); %Initialize the noise
        noise(q*ones(N-1,d)>rand(N-1,d))=-1; % Generate the noise
        noisy=noise.*samples; % Add noise to the data set
        Correlation_Coef_Matrix_Estimate_noisy=Correlation_Coefficients_Matrix(noisy(1:k,:)); % Find the correlation matrix
        [Tree_noisy,Cost] =  UndirectedMaximumSpanningTree(abs(Correlation_Coef_Matrix_Estimate_noisy)); %Estimate the tree structure
        error = error+nnz(Tree-Tree_noisy)/4;  %Count the number of mismatched edges. Division by 4 is considered because of the symmetric property of the adjacency matrix and because two tree differ by even number of edges only. 
    end
    average_error=error/runs;
end

