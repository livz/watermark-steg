%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple function to hide data in LSB coefficients in BMPs.
% (Working for common 24bit depth bmp images)
%
% Arguments:
%   original [IN] - input image filename
%   msg [IN] - message string to be hidden
%   stego [OUT] - output image filename with embedded message
%
% Return:
%   0 if entire message was hidden succesfully
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ret = bmpHide(original, msg, stego)
% Log file
log = fopen('bmpHide.log', 'w');

% Read input image
im = imread(original);

% Convert message string to binary representation
bin_msg = msg - 0;
bin_msg = reshape(de2bi(bin_msg, 8), 1, length(msg) * 8);

% Add message size on 32 bits
MAX_SIZE_BITS = 32;
bin_msg = horzcat(de2bi(length(bin_msg), MAX_SIZE_BITS), bin_msg);

len_m = length(bin_msg);

% Use the R matrix
r = im(:, :, 1);
[w,h] = size(r);

cnt = 1;
for i=1:w
    for j=1:h
        color = r(i,j);
        
        if (cnt <= len_m)
            % Embed a bit here
            color = bitset(color, 1, bin_msg(cnt));
            
            fprintf(log, 'color(%d, %d) before: %d, bit %d: %d after: %d\r\n', ...
                i, j, r(i,j), cnt, bin_msg(cnt), color);
            
            cnt = cnt + 1;
            r(i,j) = color;
        end
    end
end

if (cnt == len_m + 1)
    fprintf(log, 'All %d bits embedded\r\n', len_m);
    ret = 0;
else
    fprintf(log, 'Embedded %d of %d bits\r\n', cnt-1, len_m);
    ret = 1;
end

% Write modified BMP to output file
im(:, :, 1) = r;
imwrite(im, stego);

fclose(log);
end