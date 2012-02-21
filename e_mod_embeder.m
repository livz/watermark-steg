% Technique similar with the spatial embeder from Lab 1
% ( main difference: the formula for computing each pixel of the watermaked
% image (formula (11.4) ))

% Test image is 512 x 512 x 8 (width x height x bpp)
%   ==> 64 block (64x64 each)
% Mark to be embeded: 64 x 64 x 1 (black or white 64x64 image)

% Read original image 
im_in = imread('images/jump.bmp');
[w, h] = size(im_in);

% Read mark
im_mark = imread('images/mark.bmp');

% Resulting marked image
im_out = zeros(w, h);

% Initialize internal random number generator
seed = hex2dec('b4d533d');
rng(seed);

% Strength factor
alpha = 5;

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

imwrite(uint8(im_out), 'out_mod_add.bmp');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Se observa un zgomot perceptibil, denumit de autor 'salt-and-pepper noise'
% (cand valoarea unui pixel se da peste cap datorita operatiei modulo 256 din 
% embederul e_mod),
% dar care poate fi tolerat daca se are in vedere ca folosind aceasta metoda 
% de autentificare, imaginea originala va fi recuperata complet din acest 
% 'erasable watermark', iar imaginea marcata are doar scop demonstrativ, de
% prezentare, si eventual de protectie a originalului
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%