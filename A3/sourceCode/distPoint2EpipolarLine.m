function error = distPoint2EpipolarLine(F,p1,p2)
% distPoint2EpipolarLine  Compute the point-to-epipolar-line distance
%
%   Input:
%   - F(3,3): Fundamental matrix
%   - p1(3,NumPoints): homogeneous coords of the observed points in image 1
%   - p2(3,NumPoints): homogeneous coords of the observed points in image 2
%
%   Output:
%   - cost: sum of squared distance from points to epipolar lines
%           normalized by the number of point coordinates

NumPoints = size(p1,2);

homog_points = [p1, p2];
epi_lines = [F.'*p2, F*p1];

denom = epi_lines(1,:).^2 + epi_lines(2,:).^2;
cost = sqrt((sum(epi_lines.*homog_points,1).^2)./denom );
%TODO: IS ' CORRECT?
error = sum(reshape(cost,NumPoints,2),2)';
end

function E = EssentialMatrixFromFundamentalMatrix(F,K)
%% EssentialMatrixFromFundamentalMatrix
% Use the camera calibration matrix to esimate the Essential matrix
% Inputs:
%     K - size (3 x 3) camera calibration (intrinsics) matrix
%     F - size (3 x 3) fundamental matrix from EstimateFundamentalMatrix
% Outputs:
%     E - size (3 x 3) Essential matrix with singular values (1,1,0)


E1 = transpose(K)*F*K;

[U,~,V] = svd(E1);

E = U*[1 0 0; 0 1 0; 0 0 0]*V';

% d=det(E);
% if d<0; E(:,1)=-E(:,1); d=-d; end
% E=(d^(-1/3))*E;

end


