%-- Input: Me ----%
style_transfer('0', '348625753_a09d77183a_o', '16', 6, true);

%-- Input: 0006_001 ----%
style_transfer('1', '0006_001', '0', 6, true);
style_transfer('2', '0006_001', '9', 6, true);
style_transfer('3', '0006_001', '10', 6, true);

%-- Input: 0004_6 ----%  
out = style_transfer('4', '0004_6', '16', 6, true);
style_transfer('5', '0004_6', '21', 6, true);

%-- Blending! Input: 0004_6 ----%
left=im2double(imread(sprintf('../data/Inputs/imgs/%s.png', '0004_6')));
pyramid_blending(left, out, 1);
pyramid_blending(left, out, 3);
pyramid_blending(left, out, 6);
pyramid_blending(left, out, 8);
pyramid_blending(left, out, 10);