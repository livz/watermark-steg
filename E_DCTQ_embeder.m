%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% E_DCTQ -- embed an authentication mark by quantizing coefficients in the
%           block DCT of an image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

image1 = imread('images\lena.bmp');

% Get size of the original image
[w, h] = size(image1);  % 512 x 512

% Allocate space for the marked image
image2 = zeros(w, h);

% DCT Coefficients used to embed a semi-fragile watermark 
coefs = [                  15 ...
                        22 23 ...
                     29 30 31 ...
                  36 37 38 39 ...
               43 44 45 46 47 ...
            50 51 52 53 54 55 ...
         57 58 59 60 61 62 63];
  
% Quantization table    
Qt = [16  11  10  16  24  40  51  61 ...
      12  12  14  19  26  58  60  55 ...
      14  13  16  24  40  57  69  56 ... 
      14  17  22  29  51  87  80  62 ...
      18  22  37  56  68 109 103  77 ...
      24  35  55  64  81 104 113  92 ...
      49  64  78  87 103 121 120 101 ...
      72  92  95  98 112 100 103 99];

% Initialize internal random number generator
% (same initial state as the embeder; synchronized)
seed = hex2dec('b4d533d');
rng(seed);

% Strength parameter / quality factor
alpha = 0.03;

% Embed 4 bits in the high-frequency DCT coefficients of each 8 x 8
% block in the image
for i=1:w/8
    for j=1:h/8
        % 8x8 block to be embeded in
        block = image1((i-1)*8+1: i*8, (j-1)*8+1: j*8);
        
        % Generate 4 random bits to embed
        bits = round(rand(1,4));
        
        % Randomize the array of the 28 coefficients
        coefs = coefs(randperm(length(coefs)));
        
        out_block = EmbedDCTQWmkInOneBlock(reshape(block, 1, 8*8), coefs, alpha*Qt, bits); 
        
        % Save to output image
        image2((i-1)*8+1: i*8, (j-1)*8+1: j*8) = reshape(out_block, 8, 8);
    end
end
imwrite(uint8(image2), 'images\lena_e_dctq.bmp');