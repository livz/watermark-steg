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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize internal random number generator
% (same initial state as the embeder; synchronized)
seed = hex2dec('b4d533d');
rng(seed);

% Linear correlation threshold
tlc = 5;

% Read original images
base_im_dir = 'images';
im_files = {'fish', 'jump', 'lena', 'plane', 'sea'};

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
            im_orig((i-1)*8+1: i*8, (j-1)*8+1: j*8) = mod(double(block) - floor(tlc * wm + 0.5), 256);
            
        end
    end

    imwrite(uint8(mark), strcat(base_im_dir, '\', im_files{idx}, '_d_lc_mark.bmp'));
    imwrite(uint8(im_orig), strcat(base_im_dir, '\', im_files{idx}, '_d_lc_restored.bmp'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%-- Concluzii --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Se observa ca se rezolva problema clippingului din E_BLIND, prin
% operatia de modulo 256, care recpereaza bitii originali. 
%
% 2. Se observa o mica variatie a calitatii imaginii recuperate, intre imaginile
% din setul de test (Datorita rotunjirilor din operatiile cu numere double,
% unele imagini originale nu mai pot fi recuperate la fel de fidel).
%
% 3. Atata timp cat pixelii nu fac wrap-around in proportie foarte mare,
% detectorul D_LC functioneaza corect, detectand watermark-ul.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%