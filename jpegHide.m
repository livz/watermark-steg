%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple function to hide data in DCT quatization coefficients.
%
% Arguments:
%   original [IN] - input image filename
%   msg [IN] - message string to be hidden
%   stego [OUT] - output image filename with embedded message
%
% Return:
%   0 if entire message hidden succesfully
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ret = jpegHide(original, msg, stego)
% Standard discrete cosine transform matrix.
dct_matrix = dctmtx(8);

% DCT and Inverse DCT block function
dct = @(block) dct_matrix * block.data * dct_matrix';
idct = @(block) dct_matrix' * block.data * dct_matrix;

% Read input image
in_img = imread(original, 'jpg');

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
y = blockproc(y, [8 8], dct, ...
    'PadPartialBlocks', true, 'PadMethod', 'symmetric') .* q_max;
cb = blockproc(cb, [8 8], dct, ...
    'PadPartialBlocks', true, 'PadMethod', 'symmetric') .* q_max;
cr = blockproc(cr, [8 8], dct, ...
    'PadPartialBlocks', true, 'PadMethod', 'symmetric') .* q_max;

% Quantize DCT coefficients
% q_y = q_y * 0.2;
% q_c = q_c * 0.2;
% y = blockproc(y, [8 8], @(block) round(round(block.data) ./ q_y));
% cb = blockproc(cb, [8 8], @(block) round(round(block.data) ./ q_c));
% cr = blockproc(cr, [8 8], @(block) round(round(block.data) ./ q_c));

% Convert message string to binary representation
bin_msg = msg - 0;
bin_msg = reshape(de2bi(bin_msg, 8), 1, length(msg) * 8);

% Embed binary messge
[w, h] = size(y);

cnt = length(msg);
for i=1:w/8
    for j=1:h/8
        % block is already 8x8 after padding from dct above
        block = y((i-1)*8+1: i*8, (j-1)*8+1: j*8);
       % block = round(reshape(block, 1, 64));
        
        for k=1:64
            if (block(k)>1 && (cnt > 0))
                %block(k) = block(k)-10;%bitset(block(k), 1, bin_msg(cnt));
                cnt = cnt - 1;
            end
        end
        
        if ((i==1) && (j==1))
            reshape(round(block),8,8)
            reshape(block,8,8)
            %block(1,1) = 11;
        end
        % save back to y
        y((i-1)*8+1: i*8, (j-1)*8+1: j*8) = reshape(block, 8, 8);
    end
end

if (cnt > 0)
    ret = 1;
    fprintf('Not all bits of the message embeded.\n');
else
    ret = 0;
    fprintf('All %d bits embedded.\n', length(msg));
end

% Dequantize DCT coefficients
%  y = blockproc(y, [8 8], @(block) block.data .* q_y);
%  cb = blockproc(cb, [8 8], @(block) block.data .* q_c);
%  cr = blockproc(cr, [8 8], @(block) block.data .* q_c);

% Inverse discrete cosine transform
y = blockproc(y ./ q_max, [8 8], idct);
cb = blockproc(cb ./ q_max, [8 8], idct);
cr = blockproc(cr ./ q_max, [8 8], idct);

% Concatenate the channels to get the resulting image.
result_img = ycbcr2rgb(cat(3, y, cb, cr));
imwrite(result_img, stego, 'jpg');

end