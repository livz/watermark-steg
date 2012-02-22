%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% D_LC -- detect watermarks using linear correlation                       
%                                                                          
% Arguments:                                                               
%   c -- image                                                                                                          
%   tlc -- detection threshold                                                    
%                                                                         
% Return value:                                                           
%   decoded message (0 or 1)  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function m = d_lc(c, tlc)
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
        m = 1;
    elseif (lc < -tlc)
        m = 0;
    else
        m = 0;
    end
end