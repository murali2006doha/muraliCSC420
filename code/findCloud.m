function [ptc, ptc_rs] = findCloud(imname, imset)

disparityRange = [-6 10];   %parameter for matlab disparity function
    patch_size = 15;    %parameter for matlab disparity function
    
%get left and right of current imageid 
        left_imdata = getData(imname, imset, 'left');
        left_img = rgb2gray(double(left_imdata.im)/255);
        right_imdata = getData(imname, imset, 'right');
        right_img = rgb2gray(double(right_imdata.im)/255);
        
%find the disparity between left and right image
        disp = disparity(left_img,right_img,'BlockSize',patch_size,'DisparityRange',disparityRange);

% disp = getDisparity(imset, imname);

% disp = getData(imname, imset, 'disp');
calib = getData(imname, imset, 'calib');

depth = findDepth(disp, calib);
[Y, X] = size(depth);

px = calib.K(1, 3);
py = calib.K(2, 3);

cloud = zeros(Y, X, 3);
for ix = 1:X
    for iy = 1:Y
       cloud(iy, ix, :) = findXY(iy, ix, depth(iy, ix), py, px, calib.f);
    end
end
cloud = single(cloud);
ptc = pointCloud(cloud); %convert to point cloud format
ptc_rs = pointCloud(reshape(cloud,[size(cloud,1)*size(cloud,2) 3]));

end