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


def laplacian_pyramid(img, num_levels, kernel):
    gaussian_pyramid = [img]

    for i in range(num_levels - 1):
        gaussian_pyramid.append(conv2d(in1=gaussian_pyramid[-1], in2=kernel, mode='same'))

    gaussian_pyramid.append(np.zeros_like(img))
    return [gaussian_pyramid[i] - gaussian_pyramid[i + 1] for i in range(len(gaussian_pyramid) - 1)]


def load(img_path):
    return cv2.imread(img_path, 1)


def reconstruct(laplacian_pyramid):
    return np.sum(laplacian_pyramid, axis=0)


def change_background(img, mask, background):
    return img * mask + background * (1 - mask)


img = load(r'data/Inputs/imgs/0004_6.png')
example = load(r'data/Examples/imgs/10.png')
background = load(r'data/Examples/bgs/0.jpg')
mask = load(r'data/Inputs/masks/0004_6.png') // 255
img = change_background(img=img, mask=mask, background=background)

kernel = build_gaussian_psf(sig=5)
img_pyr_b = laplacian_pyramid(img=img[..., 0], num_levels=6, kernel=kernel)
img_pyr_g = laplacian_pyramid(img=img[..., 1], num_levels=6, kernel=kernel)
img_pyr_r = laplacian_pyramid(img=img[..., 2], num_levels=6, kernel=kernel)

ex_pyr_b = laplacian_pyramid(img=example[..., 0], num_levels=6, kernel=kernel)
ex_pyr_g = laplacian_pyramid(img=example[..., 1], num_levels=6, kernel=kernel)
ex_pyr_r = laplacian_pyramid(img=example[..., 2], num_levels=6, kernel=kernel)

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