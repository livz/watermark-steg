%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ExtractDCTQWmkFromOneBlock -- extract 4 watermark bits from the
%                                 high-frequency DCT coefficients of
%                                 an 8x8 block
%
%   Arguments:
%     c -- block from which to extract bits (in spatial domain)
%     coefs -- lists of coefficients to use for each bit
%     aQ -- quantization matrix
%
%   Return value:
%     wmkBits -- extracted bits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function wmkBits = ExtractDCTQWmkFromOneBlock(c, coefs, aQ)
% Convert block into dct domain and extract 4 bits
c = dct(c);

wmkBits = zeros(1,4);
for idx = 1: 4
    % Select a set of 7 coefficients from the 28
    % (one frm the 4 disjoint sets)
    Cf = coefs( (idx-1)*7 + 1: 7*idx);
   
    % Extract 1 bit
    wmkBits(idx) = ExtractOneDCTQWmkBit(c, Cf, aQ);
end
end