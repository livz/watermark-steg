%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple function to hide data in DCT quatization coefficients.
% (Embed 4kb of data in 512 x 512 x 8 greyscale images, 512 characters max)
%
% Arguments:
%   img_in [IN] - input image filename
%   msg [IN] - message string to be hidden
%   img_out [OUT] - output image filename with embedded message
%
% Return:
%   0 if entire message hidden succesfully
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ret_code = DataHide(img_in, msg, img_out)
MAX_LEN = 512;

% standard quantization table
Qt = [16  11  10  16  24  40  51  61 ...
    12  12  14  19  26  58  60  55 ...
    14  13  16  24  40  57  69  56 ...
    14  17  22  29  51  87  80  62 ...
    18  22  37  56  68 109 103  77 ...
    24  35  55  64  81 104 113  92 ...
    49  64  78  87 103 121 120 101 ...
    72  92  95  98 112 100 103 99];

ret_code = 0;

% Log file
log_file = fopen('hide_log.txt','w');

% Read input image
image = imread(img_in);

% Get width and heigth
[w, h] = size(image);

% Output image
im_out = zeros(w, h);

% Process inut message
len_msg = length(msg);
bin_msg = zeros(1, MAX_LEN);

if (len_msg>MAX_LEN)
    % Trim the message to maximum limit
    msg = msg(1:MAX_LEN);
    
    ret_code = 1;
end

% Convert string to binary representation
bin_msg(1:len_msg) = msg - 0;

bin_msg = reshape(de2bi(bin_msg, 8), 1, MAX_LEN * 8);

cnt = 1;
for i=1:w/8
    for j=1:h/8
        block = image((i-1)*8+1: i*8, (j-1)*8+1: j*8);  % 8x8 block
        D = dct(reshape(block, 1, 8*8));  % DCT transform
        C = round(D./Qt);   % After quantization
        R = Qt.*C;   % Quantized DCT coefficients
        
        % Embed 1 bit last  quantized coefficient
        secret_bit = bin_msg(cnt);
        if (secret_bit == 1)
            R(64) = 255;
        else
            R(64) = 0;
        end
        
        fprintf(log_file, '%d Quantized R(64): %d\n', cnt, R(64));
                
        N = idct(R); % Inverse DCT transform
        
        im_out((i-1)*8+1: i*8, (j-1)*8+1: j*8) = reshape(N, 8, 8);
                
        cnt = cnt + 1;
    end
end

fprintf(log_file, '%d ones', sum(bin_msg(:)==1));

% Write output to file
imwrite(uint8(im_out), img_out);

fclose(log_file);

end
