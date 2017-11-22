function depth = findDepth(disp, calib)

% Need to take min with 500 because disparity contains 0 values
depth = calib.f * calib.baseline ./ disp.disparity; 
depth = min(depth, 4000); 


end 