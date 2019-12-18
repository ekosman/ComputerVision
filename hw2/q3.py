from scipy.signal import convolve2d as conv2d
import numpy as np
import cv2
import matplotlib.pyplot as plt
import matplotlib as mpl
mpl.rc('image', cmap='gray')


def build_gaussian_psf(sig):
    """
    creates gaussian kernel with side length l and a sigma of sig
    """
    l = sig * 5
    ax = np.arange(-l // 2 + 1., l // 2 + 1.)
    xx, yy = np.meshgrid(ax, ax)
    kernel = np.exp(-(xx ** 2 + yy ** 2) / (2. * sig ** 2))
    return kernel / np.sum(kernel)


def laplacian_pyramid(img, num_levels):
    gaussian_pyramid = [img]

    for i in range(num_levels - 1):
        gaussian_pyramid.append(conv2d(in1=img, in2=build_gaussian_psf(sig=i+2), mode='same'))

    gaussian_pyramid.append(np.zeros_like(img))
    return [gaussian_pyramid[i] - gaussian_pyramid[i + 1] for i in range(len(gaussian_pyramid) - 1)]


def load(img_path):
    return cv2.imread(img_path, 1)


def reconstruct(laplacian_pyramid):
    return np.sum(laplacian_pyramid, axis=0)


def change_background(img, mask, background):
    return img * mask + background * (1 - mask)


def compute_local_energy(img, level):
    return conv2d(in1=img*img, in2=build_gaussian_psf(level + 1))


def combine(b, g, r):
    out = np.zeros((b.shape[0], b.shape[1], 3))
    out[..., 0] = b
    out[..., 1] = g
    out[..., 2] = r
    return out
"""
    Load the data and transform the background using the mask
"""
img = load(r'data/Inputs/imgs/0004_6.png')
example = load(r'data/Examples/imgs/10.png')
background = load(r'data/Examples/bgs/0.jpg')
mask = load(r'data/Inputs/masks/0004_6.png') // 255
img = change_background(img=img, mask=mask, background=background)

"""
    Generate the laplacian pyramid for each channel of the two images (content and style)
"""
img_pyr_b = laplacian_pyramid(img=img[..., 0], num_levels=6)
img_pyr_g = laplacian_pyramid(img=img[..., 1], num_levels=6)
img_pyr_r = laplacian_pyramid(img=img[..., 2], num_levels=6)

ex_pyr_b = laplacian_pyramid(img=example[..., 0], num_levels=6)
ex_pyr_g = laplacian_pyramid(img=example[..., 1], num_levels=6)
ex_pyr_r = laplacian_pyramid(img=example[..., 2], num_levels=6)

"""
    Calculate the energy and the gain
"""
img_b_S = [compute_local_energy(x, level+1) for level, x in enumerate(img_pyr_b)]
img_g_S = [compute_local_energy(x, level+1) for level, x in enumerate(img_pyr_g)]
img_r_S = [compute_local_energy(x, level+1) for level, x in enumerate(img_pyr_r)]

ex_b_S = [compute_local_energy(x, level+1) for level, x in enumerate(ex_pyr_b)]
ex_g_S = [compute_local_energy(x, level+1) for level, x in enumerate(ex_pyr_g)]
ex_r_S = [compute_local_energy(x, level+1) for level, x in enumerate(ex_pyr_r)]

epsilon = 1e-4
gain_b = [np.sqrt(style / (content + epsilon)) for style, content in zip(ex_b_S, img_b_S)]
gain_g = [np.sqrt(style / (content + epsilon)) for style, content in zip(ex_g_S, img_g_S)]
gain_r = [np.sqrt(style / (content + epsilon)) for style, content in zip(ex_r_S, img_r_S)]

"""
    Construct the output pyramid
"""
out_b = (np.array(gain_b) * np.array(img_pyr_b))[:-1].append(ex_pyr_b[-1])
out_g = (np.array(gain_g) * np.array(img_pyr_g))[:-1].append(ex_pyr_g[-1])
out_r = (np.array(gain_r) * np.array(img_pyr_r))[:-1].append(ex_pyr_r[-1])

"""
    Reconstruct the new channels
"""
new_b = reconstruct(out_b)
new_g = reconstruct(out_g)
new_r = reconstruct(out_r)

new = combine(new_b, new_g, new_r)

cv2.imshow('out', new)
cv2.waitKey(0)

i=1
"""
cv2.imshow('img', img)
cv2.imshow('mask', mask)
cv2.imshow('background', img_bg)
cv2.waitKey(0)
pyr = laplacian_pyramid(img, 6, build_gaussian_psf(sig=5))
rec = reconstruct(pyr)

change_background(img, mask, background)
"""