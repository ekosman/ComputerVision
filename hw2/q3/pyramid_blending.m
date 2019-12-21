function out = pyramid_blending(left, right, nLevel) 
  [h, w, nch] = size(left);
  
  mask = [ones(h, w/2) zeros(h, w/2)];
  
  gr = gaussian_pyramid(mask, nLevel);
  
  out = zeros(size(left));
  
  for ch = 1 : nch
    la = laplacian_pyramid(left(:,:,ch), nLevel);
    lb = laplacian_pyramid(right(:,:,ch), nLevel);
    pyr_out = {};

    for i = 1 : nLevel
      pyr_out{i} = gr{i}.*la{i} + (1 - gr{i}).*lb{i};
    end
    out(:,:,ch) = reconstruct(pyr_out);
  end
  
  imwrite(out, sprintf('%d_levels.jpg', nLevel), 'Quality', 100); 