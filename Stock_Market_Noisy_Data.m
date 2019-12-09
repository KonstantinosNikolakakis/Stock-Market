%%% Author: Konstantinos Nikolakakis, (Matlab R2016a,R2019b)
%%% Estimating the tree structured approximation of the graphical model for the closing price of ten equities. 
%%% Stocks: 'IBM' , 'JNJ', 'Dow', 'KO','PEP', 'PG', 'F', 'ED', 'PFE','DJIA'
%%% Synthetic noise is generated and added to the the trend of each stock. By increasing the number of samples the structure can be recovered efficiently from noisy data as well. 
%%% The simulations support the paper "Learning Tree Structures from Noisy Data", AiStats 2019

close all;
clc;
clear all;

load('stock_market_data.mat')% Closing prices of ten equites, data have been gathered from https://finance.yahoo.com/
[N,d]=size(data); % N is the number of closing prices, d=10 is the number of equities 

%%% Setting the trend for each stock: if the daily price increases (compared to the closing price of the previous day) the corresponding value is +1 otherwise it is -1.  
samples=-ones(N-1,d);
for i=2:1:N
    samples(i-1,(data(i-1,:)<data(i,:)))=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Calculate the Correlation Coefficients Matrix
Correlation_Coef_Matrix_Estimate=Correlation_Coefficients_Matrix(samples);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Find the estimated tree structure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ Tree,Cost ] =  UndirectedMaximumSpanningTree (abs(Correlation_Coef_Matrix_Estimate))
ids = {'IBM' , 'JNJ', 'Dow', 'KO','PEP', 'PG', 'F', 'ED', 'PFE','DJIA'};
bg = biograph(Tree,ids); %Requires the bioinformatics toolbox
get(bg.nodes,'ID')
view(bg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Generate noise and estimate the structure from the noisy data %%%
samples_batches=200; 
runs=100; % Monte-Carlo averaging
qstep=0.01; %Step size of the cross-over probability
qmax=0.5; % Maximum value of the cross-over probability
Average_Error_Matrix=zeros(length(samples_batches:samples_batches:N),length(0:qstep:qmax)); %Initialize the matrix of the average number of mismatched edges
samples_batch_counter=0; 
for k=samples_batches:samples_batches:N   % Estimate the structure for data-sets with different size 
    samples_batch_counter=samples_batch_counter+1;
    qcounter=0;
    for q=0:qstep:qmax %Estimate the structure for different values of the cross-over probability
        qcounter=qcounter+1;
        average_number_of_mismatched_edges=Monte_Carlo_Iterations_Stock_Market(N,d,q,runs,samples,k,Tree); % Monte Carlo iterations
        Average_Error_Matrix(samples_batch_counter,qcounter)=average_number_of_mismatched_edges; % Store the error values
    end
end

visual_representation_of_average_error(N,d,samples_batches,qstep,qmax,Average_Error_Matrix) % 3D plot