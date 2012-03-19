%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple function to hide data in DCT quatization coefficients.
% (Similar to algorithm used by JSTEG)
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

function ret = jpegHide(original, msg, stego)
% Add path to Phil Sallee's JPEG Toolbox library
working_dir = pwd;
addpath(strcat(working_dir, '\..\jpegtbx_1.4\'));

% Log file
log = fopen('jpegHide.log', 'w');

% Read input image
im = jpeg_read(original);

% Get image information - Luminance
lum = im.coef_arrays{im.comp_info(1).component_id};
[w, h] = size(lum);

% Convert message string to binary representation
bin_msg = msg - 0;
bin_msg = reshape(de2bi(bin_msg, 8), 1, length(msg) * 8);
len_m = length(bin_msg);

cnt = 1;
for i=1:w
    for j=1:h
        coef = lum(i,j);
        
        if (cnt <= len_m)
            if (coef ~=0 && coef ~=1 && coef ~= -1)
                % Embed a bit here
                coef = sign(coef) * bitset(abs(coef), 1, bin_msg(cnt));
                
                fprintf(log, 'Coef(%d, %d) before: %d, bit %d: %d after: %d\r\n', ...
                    i, j, lum(i,j), cnt, bin_msg(cnt), coef);
                
                cnt = cnt + 1;
                lum(i,j) = coef;
            end
        end
    end
end

if (cnt == len_m + 1)
    fprintf(log, 'All %d characters embedded\r\n', len_m/8);
    ret = 0;
else
    fprintf(log, 'Embedded %f of %d characters\r\n', cnt/8, len_m/8);
    ret = 1;
end

% Write modified JPEG to output file
jpeg_write(im, stego);

fclose(log);
end