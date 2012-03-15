%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple function to extract hidden data in DCT quatization coefficients.
% (Maximum 4kb of data in 512 x 512 x 8 greyscale images, 512 characters max)
%
% Arguments:
%   img_in [IN] - input image filename containing secret message
%
% Return:
%   extracted message
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out_msg = DataExtract(img_in)
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

% Log file
log_file = fopen('extract_log.txt','w');

% Read input image adn convert to double
image = imread(img_in);

% Get width and heigth
[w, h] = size(image);

% Process inut message
bin_msg = zeros(1, MAX_LEN*8);

cnt = 1;
for i=1:w/8
    for j=1:h/8
        % Work with each 8x8 block
        block = image((i-1)*8+1: i*8, (j-1)*8+1: j*8);
        
        D = dct(reshape(block, 1, 8*8));  % DCT transform
        C = round(D./Qt);   % After quantization
        R = Qt.*C;   % Quantized DCT coefficients
       
        % Extract 1 bit from the last coefficient
        bin_msg(cnt) = (round(R(64)) ~= 0 );
        
        fprintf(log_file, '%d Quantized R(64): %d\n', cnt, round(R(64)));
        
        cnt = cnt + 1;
    end
end

fprintf(log_file, '%d ones', sum(bin_msg(:)==1));

out_msg = bi2de(reshape(bin_msg, MAX_LEN, 8));
num_el = sum(out_msg(:) ~= 0);
out_msg = reshape(char(out_msg(1:num_el)), 1, num_el);

fclose(log_file);

end
