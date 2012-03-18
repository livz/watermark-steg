%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple function to extract hidden data from DCT quatization coefficients.
%
% Arguments:
%   stego [IN] - input image containing message
%
% Return:
%   extracted message
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function msg = jpegExtract(stego)
% Standard discrete cosine transform matrix.
dct_matrix = dctmtx(8);

% DCT and Inverse DCT block function
dct = @(block) dct_matrix * block.data * dct_matrix';

% Read inut image
in_img = imread(stego, 'jpg');

% RGB to YCbCr
ycc = rgb2ycbcr(im2double(in_img));
y = ycc(:, :, 1);
cb = ycc(:, :, 2);
cr = ycc(:, :, 3);

% Luminance quantization table
q_y = ...
    [16 11 10 16 124 140 151 161;
    12 12 14 19 126 158 160 155;
    14 13 16 24 140 157 169 156;
    14 17 22 29 151 187 180 162;
    18 22 37 56 168 109 103 177;
    24 35 55 64 181 104 113 192;
    49 64 78 87 103 121 120 101;
    72 92 95 98 112 100 103 199];

% Chrominance quantization table
q_c = ...
    [17 18 24 47 99 99 99 99;
    18 21 26 66 99 99 99 99;
    24 26 56 99 99 99 99 99;
    47 66 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99];

% Discrete cosine transform, with scaling before quantization.
q_max = 255;
y = blockproc(y, [8 8], dct) .* q_max;

% Dequantize DCT coefficients
%y = blockproc(y, [8 8], @(block_struct) block_struct.data .* q_y);

% Extract binary message from y
[w, h] = size(y);

for i=1:w/8
    for j=1:h/8
        % block is already 8x8 after padding from dct above
        block = y((i-1)*8+1: i*8, (j-1)*8+1: j*8);
        block = (reshape(block, 1, 64));
        
        if ((i==1) && (j==1))
            reshape(block,8,8)
        end
    end
end

end