clear all;   close all;   clc;

% Loading the Avialable K matrix
K = [558.7087, 0.0, 310.3210; 0.0, 558.2827, 240.2395; 0.0, 0.0, 1.0];

% Loading the Avialable Images
Image_1 = rgb2gray(imread('img1.png'));
Image_2 = rgb2gray(imread('img2.png'));

%==========================================================================
% Feature Extraction and Matching Part (Part 1)
%==========================================================================

% detecting SURF Feature using Inbuild methods
points1 = detectSURFFeatures(Image_1);
points2 = detectSURFFeatures(Image_2);

% Extracting Valid Points from images
[features1,valid_points1] = extractFeatures(Image_1, points1);
[features2,valid_points2] = extractFeatures(Image_2, points2);

% Matching the Pairs of features
indexPairs = matchFeatures(features1,features2);

% Mapping the featured points on images
matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

% Show the Matched features
figure;showMatchedFeatures(Image_1, Image_2, matchedPoints1, matchedPoints2,'montage');

%==========================================================================
% Motion estimation (Part 2)
%==========================================================================

% Finding the Fundamental Matrix with the normalized Coordinates under the
% RANSAC Scheme
[F,inliers] = estimateFundamental_RANSAC(matchedPoints1, matchedPoints2,0.5,10000);

% Showing the F matrix for Delivery
disp("F matrix : ")
disp(F);

% Extracting the points which lies in liers only.
m1 = matchedPoints1(inliers,:).Location;
m2 = matchedPoints2(inliers,:).Location;
[zer_row1,zer_col1] = size(m1);
[zer_row2,zer_col2] = size(m2);
zer = zeros(zer_row1,1);
m1 = [m1,zer].';
zer = zeros(zer_row2,1);
m2 = [m2,zer].';

% Calculating Essential Matrix from Fundamental Matrix
E = EssentialMatrixFromFundamentalMatrix(F,K);

% Decomposing the Essential matrix into Rotations and Translation Matrix
[Rotatn,trnslation] = decomposeEssentialMatrix(E, m1,m2,K);

%Displaying the Rotation and Translation matrix for Delivery
disp("Rotation Matrix :");
disp(Rotatn);
disp("Translation Matrix :")
disp(trnslation);

%==========================================================================
% Triangularisation and Visulisation (part 3)
%==========================================================================

% Finding the projection matrices from estimated Rotation and Translation
P1 = K * [eye(3), [0; 0; 0]];
P2 = K * [Rotatn, trnslation];

% Triangulating the Projections
points1 = LinearTriangulation(P1, P2, matchedPoints1(inliers,:).Location, matchedPoints2(inliers,:).Location);

% Finding the Camera 1 Center 
[u,s,v] = svd(P1);
center1 = v(:,end);
center1 = center1(1:3) ./ center1(4);

% Finding the camera 2 center
[u,s,v] = svd(P2);
center2 = v(:,end);
center2 = center2(1:3) ./ center2(4);

% Final Visualisation Part
figure
title('3D Reconstruction with Linear Triangulation Method')
plot3(points1(:,1),points1(:,2),points1(:,3),'ob');
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Z Axis');
grid on;
hold on;
title("Blue First Camera | Reb Second Camera")
plot3(center1(1),center1(2),center1(3),'.b');
plot3(center2(1),center2(2),center2(3),'.r');
axis equal
cameraPyramid(eye(3),center1,'b')
cameraPyramid(Rotatn,center2,'r');