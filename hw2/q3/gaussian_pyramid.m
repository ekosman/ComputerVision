function pyramids = gaussian_pyramid(input, nLevel)
  Ih = input;
  pyramids = {Ih};
  sigma = 1; 

  for i = 2 : nLevel
    Il = imfilter(Ih, fspecial('gaussian', sigma*5, sigma), 'symmetric');
    pyramids{i} = Il; 
    sigma = sigma*2;
    Ih = Il; 
  end



