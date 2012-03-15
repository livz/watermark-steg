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

% Log file
fileID = fopen('hide_log.txt','w');

% Read input image
image = double(imread(img_in));

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

ones = sum(bin_msg(:)==1);

cnt = 1;
for i=1:w/8
    for j=1:h/8
        % Work with each 8x8 block
        block = image((i-1)*8+1: i*8, (j-1)*8+1: j*8);
        
        D = dct(reshape(block, 1, 8*8));  % DCT transform
        
        % Sequentialy take each secret bit
        secret_bit = bin_msg(cnt);
        
        % ... and embed it in the LSB of first coefficient
        D(1) = bitset(round(D(1)), 1, secret_bit);
                
        fprintf(fileID,'%d D(1)=%d\n', cnt, D(1));
        
        N = idct(D);    % Inverse DCT transform
        
        % Write compressed block
        im_out((i-1)*8+1: i*8, (j-1)*8+1: j*8) = reshape(N, 8, 8);
        
        cnt = cnt + 1;
    end
end

delta = uint8(image)-uint8(im_out);
sum(delta(:) ~= 0)


% Write output to file
imwrite(uint8(im_out), img_out);

fclose(fileID);

end
