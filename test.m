%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test the embeders and decoders
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read images and mark
base_im_dir = 'images';
im_files = {'fish', 'jump', 'lena', 'plane', 'sea'};
mark = strcat(base_im_dir, '\', 'mark.bmp');

% Possible test sequence:
%  - E_MOD embeder (op 1)
%  - D_LC detector (op 2)
%  - E_DCTQ embeder (op 3)
%  - simulate compression (alpha smaller) on DCTQ output (op 5)
%  - D_DCTQ detector (op 4)
%  - simulate compression (alpha greater) on DCTQ output (op 5)
%  - D_DCTQ detector (op 4)
%  ...

test_op = 4;
switch test_op
    case 1  % Test the E_MOD embeder
        % RNG seed
        seed = hex2dec('b4d533d');
        
        % Strength factor
        alpha = 5;
        
        % Corresponding images with mark embeded will be generated in the base
        % folder, with _e_mod suffix
        E_MOD_embeder(base_im_dir, im_files, mark, seed, alpha);
    case 2  % Test the D_LC detector
        % RNG seed
        seed = hex2dec('b4d533d');
        
        % Strength factor
        alpha = 5;
        
        % Linear correlation threshold
        tlc = 5;
        
        % Will generate mark extracted from every image, and the resulting original
        % after extraction
        D_LC_detector(base_im_dir, im_files, seed, alpha, tlc);        
    case 3  % Test the E_DCTQ embeder
        % RNG seed
        seed = hex2dec('dc7533d');
        
        % Strength parameter / quality factor
        alpha = 0.3; 
     
        % Will generate marked image with _e_dctq suffix and will compress
        % them afterwards (_e_dctq_comp suffix)
        E_DCTQ_embeder(base_im_dir, im_files, seed, alpha)
    case 4  % Test the D_DCTQ detector
        % RNG seed
        seed = hex2dec('dc7533d');
        
        % Strength parameter / quality factor
        alpha = 0.3;

        % Threshold of matching bits
        tm = 80;
        
        % Run the detector 2 times, first on watermaked images
        im_files_w = strcat(im_files, '_e_dctq');
        D_DCTQ_detector(base_im_dir, im_files_w, seed, alpha, tm);
        
        % ... and then on watermarked and compressed images
        im_files_c = strcat(im_files, '_e_dctq_comp');
        D_DCTQ_detector(base_im_dir, im_files_c, seed, alpha, tm);
    case 5  % Simulate JPEG compression on E_DCTQ results
        % Compress output images from E_DCTQ embeder
        im_files_w = strcat(im_files, '_e_dctq');
        
        % Scale factor (smaller or greater than alpha from E_DCTQ
        alpha = 0.6;
        
        compressJPEG(base_im_dir, im_files_w, alpha)        
end
fprintf('Done\n');