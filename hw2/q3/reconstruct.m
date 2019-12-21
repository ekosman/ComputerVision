function output = reconstruct(pyramid)
  nlevel=length(pyramid);
  output = pyramid{nlevel};

  for i =  nlevel-1 : -1: 1
    output = output + pyramid{i};
  end
