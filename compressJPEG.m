%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulate default JPEG compression behaviour, using DCT quantization and
% standard quantization table.
%
% Arguments:
%   base_im_dir -- base folder for images and output files
%   im_files -- array with path of image files
%   alpha -- scale compression factor to be applied
%
% Return:
%   no return value. Output compressed files are wirten in the base_dir,
%   with '_comp' suffiex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function compressJPEG(base_im_dir, im_files, alpha)
% standard quantization table
Qt = [16  11  10  16  24  40  51  61 ...
    12  12  14  19  26  58  60  55 ...
    14  13  16  24  40  57  69  56 ...
    14  17  22  29  51  87  80  62 ...
    18  22  37  56  68 109 103  77 ...
    24  35  55  64  81 104 113  92 ...
    49  64  78  87 103 121 120 101 ...
    72  92  95  98 112 100 103 99];

for idx = 1:length(im_files)
    curr_im = strcat(base_im_dir, '\', im_files{idx}, '.bmp');
    
    im_in = imread(curr_im);
    im_in = double(im_in);
    [w, h] = size(im_in);
    
    % Resulting compressed image
    im_out = zeros(w, h);
    
    for i=1:w/8
        for j=1:h/8
            % work with each 8x8 block
            block = im_in((i-1)*8+1: i*8, (j-1)*8+1: j*8);
            
            D = dct(reshape(block, 1, 8*8)); % DCT transform
            C = round(D./(alpha*Qt));   % After quantization
            R = alpha*Qt.*C;   % Reconstructed after compression
            N = idct(R);    % Inverse DCT transform
            
            % Difference after compression by quantization
            % delta = reshape(abs(N-double(block)), 8, 8)
            
            % Write compressed block
            im_out((i-1)*8+1: i*8, (j-1)*8+1: j*8) = reshape(N, 8, 8);
        end
    end
    
    % Compressed image after embeding watermark
    imwrite(uint8(im_out), strcat(base_im_dir, '\', im_files{idx}, '_comp.bmp'));
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%-- Notes --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Compression quality 'q' versus scale factor 'alpha':
%       alpha -- standard quantization matrix multiplier
%       q -- quality level in [1..100] range, where 1 means poorest image
%       quality and highest compression, and 100 means best quality and
%       lowest compression.
%              alpha = (100-q)/50,     for 50<q<=100
%              alpha = 50/q,           for 1<=q<=50
%
%       So for alpha=0.3 as in the exemples, that means a compression
%       of up to 85% quality, not less, will still allow recognition of the
%       watermark.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%