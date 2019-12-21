function out=style_transfer(name, img, example, nLevel, show_example) 
  im_in=im2double(imread(sprintf('../data/Inputs/imgs/%s.png', img)));
  im_ex=im2double(imread(sprintf('../data/Examples/imgs/%s.png', example)));

  mask_in=im2double(imread(sprintf('../data/Inputs/masks/%s.png', img)));

  bg_ex=im2double(imread(sprintf('../data/Examples/bgs/%s.jpg', example)));

  e_0 = 1e-4;
  gain_max = 2.8;
  gain_min = 0.9;

  % Replace the input background with example.
  im_in = change_background(im_in, bg_ex, mask_in);

  out = zeros(size(im_in));
  for ch = 1 : 3
    % Disabled mask-based Laplacian for now.
    pyr_in = laplacian_pyramid(im_in(:,:,ch), nLevel);
    pyr_ex = laplacian_pyramid(im_ex(:,:,ch), nLevel);

    pyr_out = pyr_ex;

    for i = 1 : nLevel-1
      sigma = 2*2^(i+1);

      l_in = pyr_in{i};
      l_ex = pyr_ex{i};
      e_in = imfilter(l_in.^2, fspecial('gaussian', 5*[sigma sigma], sigma));
      e_ex = imfilter(l_ex.^2, fspecial('gaussian', 5*[sigma sigma], sigma));
      gain = (e_ex./(e_in+e_0)).^0.5;

      % Clamping gain maps
      gain(gain>gain_max)=gain_max;
      gain(gain<gain_min)=gain_min;
      l_new = l_in.*gain;

      pyr_out{i} = l_new; 
    end

  out(:,:,ch) = reconstruct(pyr_out);
  end
  out = mask_in.*out + (1-mask_in).*bg_ex;
  if show_example
    imwrite([im_in im_ex out], sprintf('%s.jpg', name), 'Quality', 100); 
  else
    imwrite([im_in out], sprintf('%s.jpg', name), 'Quality', 100); 
  end


  
function output=bin_alpha(input) 
    output=input;
    output(output<0.5)=0;
    output(output>=0.5)=1;
    se = strel('disk', 71);  
    output = imdilate(output,se);

    % Add a small number to avoid crazy
    eps=1e-2;
    output = output + eps;


function output=change_background(img, bg, mask)
  output = mask.*img + (1-mask).*bg;