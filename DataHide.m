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
ret_code = 0;

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
        % Work with each 8x8 block
        block = image((i-1)*8+1: i*8, (j-1)*8+1: j*8);
        
        D = dct(reshape(block, 1, 8*8));  % DCT transform
          
        % Sequentialy take each secret bit
        secret_bit = bin_msg(cnt);
        
        % ... and embed it in the LSB of first coefficient
        if (secret_bit == 0)
            D(64) = 0;
        end
        
        N = idct(D);    % Inverse DCT transform
       
        % Write compressed block
        im_out((i-1)*8+1: i*8, (j-1)*8+1: j*8) = reshape(N, 8, 8);
        
        cnt = cnt + 1;
    end
end

% Write output to file
imwrite(im_out, img_out);

end
