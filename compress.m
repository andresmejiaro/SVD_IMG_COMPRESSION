%--------------------------------------------------------------------------
%
%        fotocomp Compression of an image in jpg format
% 
% This function writes an image in jpg format, that must be in the default Matlab directory
% or either include the complete path to locate it, and shows in the screen the compressed
% image. It also returns the matrices U, sigma, and V in a reduced format for further manipulation
% The arguments of the function are the following:
%  
%      1 - Name of the jpg folder that contains the image, within simple quotation marks.
%      2 - Numbre of singular values of the ouput.
%      
% The function reads the image and converts it in an array of size mxnx3,
% namely 3 matrices with size m x n each, containing the information of the pixels in a RGB color
% (red, green & blue) in int8 format.
% The integers are converted to double precision to compute the svd of each of these three matrices,
% to choose the right columns according to the selected singular values.
% After this, it recosntructs the matrix m x n x 3 from the matrices of the svd, takes them to int8 format,
% and shows the compressed image.
% The output is
%
%       1- Matrix UC of size m x p with the first p left singular vectors.
%       2- Matrix sigmaC of size p x 3, whose rows are the largest p singylar values of each color.
%          In order to recover de matrix sigma of the svd, just use the command diag.
%       3- Matrix VC of size n x p, containing the first p right singular
% 
% 
% Programa escrito por Alfonso Cama�o
% Para Universidad Carlos III de Madrid
% Enero 2011
%
%--------------------------------------------------------------------------


function [UC, sigmaC, VC, img1] = compress(imjpg, p)

% Check that the arguments are appropriate: imjpg must be a string and p a positive real number.

        
    if not (isreal(p) & (p > 0))
        disp('THE NUMBER OF SINGULAR VALUES MUST BE POSITIVE');
        UC = '???';
        sigmaC = '???';
        VC = '???';
        return;
    end;
    
    p = int16(p);
    
    foto = imread(imjpg,'jpg');
    res = size(foto);
    resmin = min(res(1:2));
    
    if res < p
        disp('THE NUMBER OF SINGULAR VALUES OF THE COMPRESSION MUST BE');
        disp('COMPATIBLE WITH THE IMAGE RESOLUTUION');
        UC = '???';
        sigmaC = '???';
        VC = '???';
        return;
    end;

% For the SVD, the array must contain integers

%   f2 = double(foto) + 1; 
   f2 = double(foto); 
   
   for k = 1:3
   
        [U(:,:,k), sigma(:,:,k), V(:,:,k)] = svd(f2(:,:,k));
        
   end;
   
   for k = 1:3
   
        f2r(:, :, k) = U(:, 1:p, k) * sigma(1:p, 1:p, k) * V(:, 1:p, k)';
        
   end;
   img1=uint8(round(f2r));
   %image(uint8(round(f2r - 1)))
   image(uint8(round(f2r)))
   
   for j = 1:3
       
        for k = 1:p
       
            sigmaC(k, j) = sigma(k, k, j);
       
        end;
        
   end;
   
   UC = U;
   
   VC = V;
   
   
   clear k j f2r U V sigma f2; 
    
end
