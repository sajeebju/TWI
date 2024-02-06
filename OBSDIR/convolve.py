#!/usr/bin/env python3
import sys
from obspy import read
import numpy as np
from scipy.signal import convolve
import matplotlib.pyplot as plt

def create_damped_oscillator_function(duration, dt, omega, gamma, psi):
    t = np.arange(0, duration, dt)
    return np.exp(-((omega * t) / gamma)**2) * np.cos(omega * t + psi)

def convolve_with_function(sac_file, dho_func):
    st = read(sac_file)
    for tr in st:
        tr.data = convolve(tr.data, dho_func, mode='same')
    return st

def main():
    if len(sys.argv) < 3:
        print("Usage: python convolve.py <Z_SAC_file_path> <R_SAC_file_path>")
        sys.exit(1)

    z_sac_file, r_sac_file = sys.argv[1], sys.argv[2]

    # Parameters for the damped harmonic oscillator function
    duration = 5
    dt = 0.05  # Sampling interval
    omega = 2 * np.pi * 1  # Angular frequency, e.g., 1 Hz
    gamma = 4   # Damping coefficient
    psi = 4     # Phase shift

    dho_func = create_damped_oscillator_function(duration, dt, omega, gamma, psi)

    # Convolve and save the results
    z_convolved = convolve_with_function(z_sac_file, dho_func)
    z_convolved.write("Convolved_OBS_Z.sac", format='SAC')

    r_convolved = convolve_with_function(r_sac_file, dho_func)
    r_convolved.write("Convolved_OBS_R.sac", format='SAC')

if __name__ == "__main__":
    main()

