%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple function to extract hidden data from LSB coefficients of BMPs.
%
% Arguments:
%   stego [IN] - input image containing message
%
% Return:
%   extracted message
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function msg = bmpExtract(stego)
% Log file
log = fopen('bmpExtract.log', 'w');

% Read stego image
im = imread(stego);

MAX_SIZE_BITS = 32;

cnt = 1;
len_m = zeros(1, 32); % Bits representing size of the embedded message
size_m = 0;
emb_m = []; % Embedded message

% Use the R matrix
r = im(:, :, 1);
[w,h] = size(r);

for i=1:w
    for j=1:h
        color = r(i,j);
        
        if (size_m == 0)
            % Message size not yet caculated
            if (cnt <=  MAX_SIZE_BITS)
                len_m(cnt) = bitget(color, 1);
                cnt = cnt + 1;
                
                if (cnt == MAX_SIZE_BITS + 1)
                    size_m = bi2de(len_m);
                    fprintf(log, 'Got size %d\r\n', size_m);
                    emb_m = zeros(1, size_m);
                    cnt = 1;
                end
            end
        else
            % Read message payload
            if (cnt <= size_m)
                emb_m(cnt) = bitget(color, 1);
                fprintf(log, 'Color(%d, %d) got bit %d: %d\r\n', ...
                    i, j, cnt, emb_m(cnt));
                cnt = cnt + 1;
            else
                break;
            end
        end
        
    end
end

% Convert message to string
emb_m = reshape(emb_m, size_m/8, 8);
msg = zeros(1, size_m/8); % characters in the retrieved message

for k=1:size_m/8
    msg(k) = bi2de(emb_m(k, :));
end

msg = char(msg);

fclose(log);

end