clear all;
close all;
clc;

K = [558.7087, 0.0, 310.3210; 0.0, 558.2827, 240.2395; 0.0, 0.0, 1.0];

Image_1 = rgb2gray(imread('img1.png'));
Image_2 = rgb2gray(imread('img2.png'));

points1 = detectSURFFeatures(Image_1);
points2 = detectSURFFeatures(Image_2);

[features1,valid_points1] = extractFeatures(Image_1, points1);
[features2,valid_points2] = extractFeatures(Image_2, points2);

indexPairs = matchFeatures(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

%figure;showMatchedFeatures(Image_1, Image_2, matchedPoints1, matchedPoints2,'montage');

[F,inliers] = estimateFundamental_RANSAC(matchedPoints1, matchedPoints2,0.5,100);

F
m1 = matchedPoints1(inliers,:).Location;
m2 = matchedPoints2(inliers,:).Location;
[zer_row1,zer_col1] = size(m1);
[zer_row2,zer_col2] = size(m2);
zer = zeros(zer_row1,1);
m1 = [m1,zer].';
zer = zeros(zer_row2,1);
m2 = [m2,zer].';

% figure;showMatchedFeatures(Image_1, Image_2, matchedPoints1(inliers,:).Location, matchedPoints2(inliers,:).Location,'montage');
E = EssentialMatrixFromFundamentalMatrix(F,K);
%[R,Sb] = decomposeEssentialMatrix(E, matchedPoints1(inliers,:).Location, matchedPoints2(inliers,:).Location,K);
[Rotatn,trnslation] = decomposeEssentialMatrix(E, m1,m2,K)

%==========================================================================
% In this part of code we do the 3 part where we do the Linear 
% Triangulation to estimate the 3d position of each corresponding 
% point and visualize the 3d scene.
%==========================================================================


% Define the matrices W and Z as in the Hartley & Zisserman book
W = [0, -1, 0; 1, 0, 0; 0, 0, 1];
Z = [0, 1, 0; -1, 0, 0; 0, 0, 0];

% Perform an SVD of the essential matrix
[U, D, V] = svd(E, 0);


% Translation guess(es)
t_guess = U(:,3);

% Rotation guess(es)
R_guess_1 = U * W * V';
R_guess_1 = R_guess_1 * sign(det(R_guess_1)) * sign(det(K));
R_guess_2 = U * W' * V';
R_guess_2 = R_guess_2 * sign(det(R_guess_2)) * sign(det(K));

% Initialize the projection matrices for the 4 solutions.
P1 = K * [eye(3), [0; 0; 0]];
P21 = K * [R_guess_1, t_guess];

points1 = algebraicTriangulation(m1, m2, P1, P21);

[x1_,x2_] = opt_tri(P1, P21, m1,m2,F,zer_col2);
points2 = algebraicTriangulation(x1_, x2_, P1, P21);

