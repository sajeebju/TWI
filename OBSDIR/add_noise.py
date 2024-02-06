#!/usr/bin/env python3
import sys
from obspy import read
import numpy as np
np.random.seed(0)

def add_gaussian_noise(data, mean, std_dev, num_samples):
    np.random.seed(958)
    noise = np.random.normal(mean, std_dev, num_samples)
    return data + noise

def process_sac_file(sac_file, noise_mean, noise_std_dev, num_samples):
    st = read(sac_file)
    for tr in st:
        tr.data = add_gaussian_noise(tr.data, noise_mean, noise_std_dev, num_samples)
    return st

def main():
    if len(sys.argv) < 3:
        print("Usage: python add_noise.py <Z_SAC_file_path> <R_SAC_file_path>")
        sys.exit(1)

    z_sac_file, r_sac_file = sys.argv[1], sys.argv[2]
    noise_mean = 0.00
    noise_std_dev = 0.01 
    num_samples = 2048


    z_noisy = process_sac_file(z_sac_file, noise_mean, noise_std_dev, num_samples)
    z_noisy.write("Noisy_" + z_sac_file.split('/')[-1], format='SAC')

    r_noisy = process_sac_file(r_sac_file, noise_mean, noise_std_dev, num_samples)
    r_noisy.write("Noisy_" + r_sac_file.split('/')[-1], format='SAC')

if __name__ == "__main__":
    main()

