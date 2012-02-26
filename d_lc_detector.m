%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script uses the d_lc detector to detect the watermark and to retrieve 
% the documents maked by e_mod embeder
%
% Input test images are obtained from the output of e_mod embeder.
%
% 2 detection problems are discvered in Experiment 2 from 11.1.3:
%    - original images whose pixels have values close to extremes of the
%      allowable range (0..255)
%    - original images with relatively flat histograms
%
% Arguments:
%   base_im_dir -- base folder for images and output files
%   im_files -- array with path of image files
%   seed -- seed for random number generator
%   alpha -- strength factor
%   tlc -- linear correlation threshold
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function D_LC_detector(base_im_dir, im_files, seed, alpha, tlc)
% Initialize internal random number generator
% (same initial state as the embeder; synchronized)
rng(seed);

for idx = 1:length(im_files)
    curr_im = strcat(base_im_dir, '\', im_files{idx}, '_e_mod.bmp');
    
    im_in = imread(curr_im);
    [w, h] = size(im_in);

    % Allocate space for mark
    mark = zeros(64, 64);
    
    % Allocate space for reconstructing the original
    im_orig = zeros(w, h);

    % Iterate through every 64x64 block from input image
    % (dimensions equal to those of the mark)
    for i=1:w/8
        for j=1:h/8   
            % 8x8 block from marked image
            block = im_in((i-1)*8+1: i*8, (j-1)*8+1: j*8);    

            % detect marked bit
            [bit, wm] = d_lc(block, tlc);

            % save bit in the mark
            mark(i,j) = bit;
            
            % try to reconstruct original image
            im_orig((i-1)*8+1: i*8, (j-1)*8+1: j*8) = mod(double(block) - floor(alpha * wm + 0.5), 256);
            
        end
    end

    imwrite(uint8(mark), strcat(base_im_dir, '\', im_files{idx}, '_d_lc_mark.bmp'));
    imwrite(uint8(im_orig), strcat(base_im_dir, '\', im_files{idx}, '_d_lc_restored.bmp'));
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%-- Notes --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. The clipping problem from E_BLIND algorithm is solved by the modulo
%    256 addition, that restores entirely the original bits.
%
% 2. There is a small difference between the recovered images and the
%    originals, because of the round operations and working with doubles. 
%    Some images cannot be restored with the same fidelity. 
%
% 3. As long as a small percent of pixels wrap around, the D_LC detector
%    works correctly and detect the watermark.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%