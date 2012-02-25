%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ExtractOneDCTQWmkBit -- extract one watermark bit from the high-frequency
%                           DCT coefficients of an 8x8 block
%
%   Arguments:
%     C -- DCT of block
%     coefs -- list of seven coefficients to use for this bit
%     aQ -- quantization matrix
%
%   Return value:
%     value of bit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function bit = ExtractOneDCTQWmkBit(C, coefs, aQ)
% Find the quantization factor multiples, Ci
Ci = floor(C(coefs)./(aQ(coefs))+0.5);

% Find the bit value
bit = 0;
for i = 1: 7
    bit = bit ^ (Ci(i) & 1);
end
end