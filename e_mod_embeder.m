%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Technique similar with the spatial embeder from Lab 1
% ( main difference: the formula for computing each pixel of the watermaked
% image (formula (11.4) ))
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

    % Iterate through every 64x64 block from input image
    % (dimensions equal to those of the mark)
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Se observa un zgomot perceptibil, denumit de autor 'salt-and-pepper noise'
% (cand valoarea unui pixel se da peste cap datorita operatiei modulo 256 din 
% embederul e_mod),
% dar care poate fi tolerat daca se are in vedere ca folosind aceasta metoda 
% de autentificare, imaginea originala va fi recuperata complet din acest 
% 'erasable watermark', iar imaginea marcata are doar scop demonstrativ, de
% prezentare, si eventual de protectie a originalului
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Zgomotul este mult mai puternic:
%   a. In cazul in care imaginile sunt alb-negru, (pixeli cu valori spre extreme, 
%       spre 0 sau 255) 
%   b. Daca histograma este uniforma(nu se mai poate face corect detectia, din
%      cauza operatiei modulo 256, care produce tot o distributie uniforma. 
%      (11.1, experiment 2))
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%