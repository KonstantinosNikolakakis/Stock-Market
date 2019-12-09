%%% 3D Plots of the average error of mismatched edges between the original and the estimated tree
% Requires: The error matrix Average_Error_Matrix, the maximum value and
% the step-size of q (qmax, qstep), the number of samples' batches and the dimensions of the data set [N,d]
function visual_representation_of_average_error(N,d,samples_batches,qstep,qmax,Average_Error_Matrix)
    points=ceil(N/samples_batches)-1;
    [x,y]=meshgrid(0.00:qstep:qmax,1:1:points);
    figure
    mesh(y,x,Average_Error_Matrix)
    xlabel('Number of samples $n\times 200$','Interpreter','latex')
    zlabel('Number of incorrect edges','Interpreter','latex')
    ylabel('Cross-over probability $q$','Interpreter','latex')
    xlim([1 points])
    ylim([0 qmax])
    zlim([0 d])
    colorbar
end

