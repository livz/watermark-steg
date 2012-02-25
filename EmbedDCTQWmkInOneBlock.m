% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  EmbedDCTQWmkInOneBlock -- embed 4 bits in a block
%
%  Arguments:
%    c -- block in which to embed (in spatial domain)
%    coefs -- lists of coefficients to use for the four bits
%    aQ -- quantization matrix
%    wmkBits -- array of four bits to embed
%
%  Return value:
%    ret -- how many bits were actually embedded
%    c -- modified block
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ret, c] = EmbedDCTQWmkInOneBlock(c, coefs, aQ, wmkBits)
% Save dct of the original unmodified block (for further comparisons)
Co = dct(c);

% Embed four bits into this block, then quantize and clip to eight bit
% values.  Repeat up to 10 times or until all the bits are correctly
% embedded.
numIterationsLeft = 10;
notDone = 1;
while(notDone && numIterationsLeft > 0)
    notDone = 0;
    
    % Convert the block into the DCT domain,
    c = dct(c);
         
    ret = 0;
    % Embed four bits into the block
    for idx = 1: 4
        % Embed 1 watermark bit
        bit = wmkBits(idx);
        
        % Select a set of 7 coefficients from the 28
        % (the 4 sets must be disjoint)
        Cf = coefs( (idx-1)*7 + 1: 7*idx);
        
        [bitWasFlipped, c] = EmbedOneDCTQWmkBit(c, Co, Cf, aQ, bit);
        
        if (bitWasFlipped)
            notDone = 1;
        else
            ret = ret + 1;
        end
    end
    
    % Convert the block back to the spatial domain
    c = idct(c);
    
    % Clip and round to 8 bit integer
    c = clipRound(c);
    
    numIterationsLeft = numIterationsLeft - 1;
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%-- Notes -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. In theory, this algorithm should always succeed in embedding all bits. 
%    In practice, however, a few bits will be corrupted when the image is
%    converted back to the spatial domain, and each pixel is clipped and
%    rounded to an 8-bit value. To compensate for this, the embedder is run 
%    more than once on the image (10 times)
%
% 2. The percent of bits successfuly embeded is reflected in the first 
%    output parameter.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%