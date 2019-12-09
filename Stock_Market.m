%%% Author: Konstantinos Nikolakakis, (tested on Matlab R2016a,R2019b)
%%% Estimating the tree structured approximation of the graphical model for the closing price of ten equities. 
%%% Stocks: 'IBM' , 'JNJ', 'Dow', 'KO','PEP', 'PG', 'F', 'ED', 'PFE','DJIA'
%%% The estimated structure is a star graph with the DJIA in the middle as expected and the price of KO (Coca Cola) directly connected to PEP (Pepsi)
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

%%% Consider subsets of the original data set, 100 samples as starting point and increase the samples size with step 500 up to 3000 
% The estimated tree converges to the expected original tree for number of samples greater than 2500
samples_batches=500; 
for k=100:samples_batches:3000
    Correlation_Coef_Matrix_Estimate=Correlation_Coefficients_Matrix(samples(1:k,:));
    [ Tree,Cost ] =  UndirectedMaximumSpanningTree (abs(Correlation_Coef_Matrix_Estimate))
    bg = biograph(Tree,ids); %Requires the bioinformatics toolbox
    get(bg.nodes,'ID')
    view(bg)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
  