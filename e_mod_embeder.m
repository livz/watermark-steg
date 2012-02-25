%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Technique similar with the spatial embeder from Lab 1
% ( main difference: the formula for computing each pixel of the watermaked
% image (formula (11.4)) - modulo addition instead of clipping ) 
%
% Test images are 512 x 512 x 8 (width x height x bpp), colored and greyscale
%   ==> 64 block (64x64 each)
% Mark to be embeded: 64 x 64 x 1 (1 bit colors, 64x64 image)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize internal random number generator
% (same initial state as the detector; synchronized)
seed = hex2dec('b4d533d');
rng(seed);

% Strength factor
alpha = 5;

% Read original images
base_im_dir = 'images';
im_files = {'fish', 'jump', 'lena', 'plane', 'sea'};

for idx = 1:length(im_files)
    curr_im = strcat(base_im_dir, '\', im_files{idx}, '.bmp');
    
    im_in = imread(curr_im);
    [w, h] = size(im_in);

    % Read mark
    im_mark = imread(strcat(base_im_dir, '\', 'mark.bmp'));

    % Resulting marked image
    im_out = zeros(w, h);

    % Iterate through every 64x64 blocks from input image
    for i=1:w/8
        for j=1:h/8   
            % bit to be embeded 
            bit = im_mark(i, j);

            % 8x8 block to be embeded in
            block = im_in((i-1)*8+1: i*8, (j-1)*8+1: j*8);    

            % compute marked block
            block_m = e_mod(block, bit, alpha);

            % save block into output image
            im_out((i-1)*8+1: i*8, (j-1)*8+1: j*8) = uint8(block_m);
        end
    end

    imwrite(uint8(im_out), strcat(base_im_dir, '\', im_files{idx}, '_e_mod.bmp'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%-- Notes --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. A perceptible noise (so-called 'salt-and-pepper' noise) cand be
%    observed. This corresponds to the case where the value of a pixel
%    wraps-around, because of the modulor 256 adition from e_mod embeder.
%    This can be tolerated if we take into account that using this method
%    of authentication, the original image could be restored completely
%     (theoreticaly) -- 'erasable watermark'. The marked image has only
%     demonstrative purpose.
%
% 2. The noise is stronger when:
%   a. original images are black-and-white, with pixels having values close
%      to extremes (towards 0 or 255)
%   b. if the histogram of the image is flat (The detection cannot be made
%      accurately because of the modulo 256 operation, that produces also
%      a normal distribution. More details is 11.1, experiment 2).
%   c. We see that the noise varies with the histogram of the image, and
%      grately depends if it's a colored or black-white image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%