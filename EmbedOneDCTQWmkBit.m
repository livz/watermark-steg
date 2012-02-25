%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   EmbedOneDCTQWmkBit -- embed one bit in a block
%
%   Arguments:
%     C -- DCT of block in which to embed bit 
%     Co -- DCT of original version of block, before any bits were embedded
%     coefs -- list of 7 coefficients to use for this bit
%     aQ -- quantization matrix
%     b -- desired value of bit
%
%   Return value:
%      ret -- 0 if the block already decodes to the given bit value, 1 otherwise
%      C -- changed dct of the block
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ret, C] = EmbedOneDCTQWmkBit(C, Co, coefs, aQ, b)
% Divide each of the DCT coefficients by its corresponding quantization
% factor, and round to the nearest integer
Ci = floor(C(coefs)./(aQ(coefs))+0.5);

% Find the current bit value represented by these coefficients
% (xor together the LSB of each resulting Ci)
be = 0;
for i = 1: 7
    be = xor(be, (Ci(i) & 1));
end
%fprintf('\nb=%d be=%d\n', b, be);

if (be ~= b)
    % Flip the least-significant bit (LSB) of one of the Ci values.
    
    bestFlipError = 999;
    bestI = -1;
    bestFlippedCi = -1;
    for i = 1: 7
        % Find the Ci value that results in the smallest error when its
        % lsb is flipped
        j = coefs(i);
        
        % Find what the new value of Ci[j] would be if we flip the lsb.
        % We'll flip the lsb by either adding or subtracting 1, depending
        % on whether the unquantized value is greater than or less than
        % the current quantized value, respectively.  This yields the
        % value of aQ[j]*flippedCi that is closest to Co[j].
        if (Co(j) < aQ(j)*Ci(i))
            flippedCi = Ci(i) - 1;
        else
            flippedCi = Ci(i) + 1;
        end
        
        % Find the magnitude of the error that would result from replacing
        % Ci(j) with flippedCi
        flipError = abs(aQ(j) * flippedCi - Co(j));
        
        if (i==1 || flipError < bestFlipError)
            bestI = i;
            bestFlipError = flipError;
            bestFlippedCi = flippedCi;
        end
    end
    
    % Flip selected Ci
    Ci(bestI) = bestFlippedCi;
end

C(coefs) = aQ(coefs) .* Ci;
ret = (be ~= b);
end