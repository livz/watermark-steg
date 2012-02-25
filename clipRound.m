%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   clipRound -- clip and round a real value to an 8-bit integer
%
%   Arguments:
%     v -- real value
%
%   Return value:
%     clipped and rounded value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function iv = clipRound(v)
if(v < 0)
    iv = 0;
elseif( v > 255 )
    iv = 255;
else
    iv = uint8(floor(v + 0.5));
end
end