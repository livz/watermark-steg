%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% E_DCTQ -- embed an authentication mark by quantizing coefficients in the
%           block DCT of an image
% Arguments:
%   base_im_dir -- base folder for images and output files
%   im_files -- array with path of image files
%   seed -- seed for random number generator
%   alpha -- strength parameter / quality factor
%
% Return:
%   no return value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function E_DCTQ_embeder(base_im_dir, im_files, seed, alpha)

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
% (same initial state as the detector; synchronized)
rng(seed);

for idx = 1:length(im_files)
    curr_im = strcat(base_im_dir, '\', im_files{idx}, '.bmp');
    
    im_in = imread(curr_im);
    im_in = double(im_in);
    [w, h] = size(im_in);
    
    % Resulting marked image
    im_out = zeros(w, h);
    
    % Embed 4 bits in the high-frequency DCT coefficients of each 8 x 8
    % block in the image
    total = 0;
    for i=1:w/8
        for j=1:h/8
            % 8x8 block to be embeded in
            block = im_in((i-1)*8+1: i*8, (j-1)*8+1: j*8);
            
            % Generate 4 random bits to embed
            bits = round(rand(1,4));
            
            % Randomize the array of the 28 coefficients
            coefs = coefs(randperm(length(coefs)));
            
            [embeded, out_block] = EmbedDCTQWmkInOneBlock(reshape(block, 1, 8*8), coefs, alpha*Qt, bits);
            total = total + embeded;
            
            % Save to output image
            im_out((i-1)*8+1: i*8, (j-1)*8+1: j*8) = reshape(out_block, 8, 8);
        end
    end
    
    fprintf('Total embeded bits in %s: %d (%2.3f%%) from %d\n', ...
        char(strcat(im_files(idx), '.bmp')), total, total/(4096*4)*100, 4096*4);
    imwrite(uint8(im_out), strcat(base_im_dir, '\', im_files{idx}, '_e_dctq.bmp'));
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%-- Notes --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. The 4 random bits are embedded in the high-frequency DCT coefficients
%    of each 8 x 8 bock of the image. So, as long as the quantzation
%    performed during normal JPEG compression uses smaller steps,
%    the watermark will survive.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%