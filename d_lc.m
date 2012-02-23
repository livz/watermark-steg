%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% D_LC -- detect watermarks using linear correlation                       
%                                                                          
% Arguments:                                                               
%   c -- image                                                                                                          
%   tlc -- detection threshold                                                    
%                                                                         
% Return value:                                                           
%   m -- decoded message (0 or 255), or no watermark (mark is black-white)
%   wr -- watermark reference pattern (used for restoring the original)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [m, wr] = d_lc(c, tlc)
    % Get width, height
    [w, h] = size(c);

    % Reference pattern, (width x height array),
    % randomly generated (rng started from same seed)
    wr = gen_rand(w, h);
       
    % Convert image to double, for arithmetic operations
    c = double(c); 

    % Find the linear correlation between the image and the reference
    % pattern
	lc = sum(sum(c.*wr))/ (w * h);
       
    if (lc > tlc)
        m = 255;
    elseif (lc < -tlc)
        m = 0;
    else
        m = 255;  % no watermark detected
    end    
end