function pyramids = laplacian_pyramid(input, nLevel)
pyramids={};

pyramids{1}=input;
for i = 2 : nLevel
  sigma=2^(i);
  kernel=fspecial('gaussian', sigma*5, sigma); 
  pyramids{i} = imfilter(input, kernel, 'symmetric');
end

for i = 1 : nLevel-1
  pyramids{i} = (pyramids{i}-pyramids{i+1});
end

pyramids{nLevel} = pyramids{nLevel};

