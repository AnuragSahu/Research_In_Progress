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

[F,inliers] = estimateFundamental_RANSAC(matchedPoints1, matchedPoints2,5,100);
%F = computeFundamentalMatrixRANSAC(matchedPoints1, matchedPoints2,50);

F
m1 = matchedPoints1(inliers,:).Location;
m2 = matchedPoints2(inliers,:).Location;
[zer_row1,zer_col1] = size(m1);
[zer_row2,zer_col2] = size(m2);
zer = zeros(zer_row1,1);
m1 = [m1,zer].';
zer = zeros(zer_row2,1);
m2 = [m2,zer].';

%figure;showMatchedFeatures(Image_1, Image_2, matchedPoints1(inliers,:).Location, matchedPoints2(inliers,:).Location,'montage');
E = EssentialMatrixFromFundamentalMatrix(F,K);
%[R,Sb] = decomposeEssentialMatrix(E, matchedPoints1(inliers,:).Location, matchedPoints2(inliers,:).Location,K);
[Rotatn,trnslation] = decomposeEssentialMatrix(E, m1,m2,K);
disp(Rotatn);
disp(trnslation);

%==========================================================================
% In this part of code we do the 3 part where we do the Linear 
% Triangulation to estimate the 3d position of each corresponding 
% point and visualize the 3d scene.
%==========================================================================

P1 = K * [eye(3), [0; 0; 0]];
P2 = K * [Rotatn, trnslation];

%points1 = algebraicTriangulation(m1, m2, P1, P2);
%points1 = LinearTriangulation(K, eye(3),[0; 0; 0].', Rotatn, trnslation.', m1, m2);
points1 = LinearTriangulation(P1, P2, matchedPoints1(inliers,:).Location, matchedPoints2(inliers,:).Location);

%=============================Step 4c==================================
% Finding the two camera centers to compare the reconstructed
% 3D points from the above two algorithms...
[u,s,v] = svd(P1);
center1 = v(:,end);
center1 = center1(1:3) ./ center1(4);
[u,s,v] = svd(P2);
center2 = v(:,end);
center2 = center2(1:3) ./ center2(4);
% to display the centers and reconstructed points...
% for linear triangulation method
figure
title('3D Reconstruction with Linear Triangulation Method')
plot3(points1(:,1),points1(:,2),points1(:,3),'ok');
%plot3(points1(1,:),points1(2,:),points1(3,:),'ok');
hold on
plot3(center1(1),center1(2),center1(3),'Xb');
plot3(center2(1),center2(2),center2(3),'Xr');
legend('Reconstructed Points','Camera Center1','Camera Center2')
axis equal
