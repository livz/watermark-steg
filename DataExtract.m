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

% Read input image adn convert to double
image = imread(img_in);

% Get width and heigth
[w, h] = size(image);

% Process inut message
out_msg = zeros(1, MAX_LEN*8);

cnt = 1;
for i=1:w/8
    for j=1:h/8
        % Work with each 8x8 block
        block = image((i-1)*8+1: i*8, (j-1)*8+1: j*8);
        
        D = dct(reshape(block, 1, 8*8));  % DCT transform
        
        % Sequentialy get each secret bit
        
        out_msg(cnt) = (round(D(64)) ~= 0);
              
        cnt = cnt + 1;
    end
end

ones = sum(out_msg(:)~=1)

end
