%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gen_rand -- generates a random pattern, in the form of a width x height array.
%             The pattern is then normalized.
% Arguments:
%  w -- width of the pattern
%  h -- height of the pattern
%
% Return values:
%  wr - generated pattern
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function wr = gen_rand(w, h)
    wr = rand(w, h);
    
    tm = mean2(wr);
    wr = wr-tm;
    
    % Normalized pattern
    st_dev = std2(wr);
    wr = wr/st_dev;
end