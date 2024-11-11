#!/usr/bin/env python3
import numpy as np
from scipy.signal import convolve
from obspy import read
import sys

def calculate_misfit(Er, Ez, Z, R):
    # Read the SAC files and get the waveform data
    trace_Er = read(Er)[0].data
    trace_Ez = read(Ez)[0].data
    trace_Z = read(Z)[0].data
    trace_R = read(R)[0].data

    conv_Z_Er = convolve(trace_Z, trace_Er, mode='same')
    conv_R_Ez = convolve(trace_R, trace_Ez, mode='same')

    misfit = np.linalg.norm(conv_Z_Er - conv_R_Ez)
    return misfit


def main():
    if len(sys.argv) != 5:
        print("Usage: python script.py Er_file Ez_file Z_file R_file")
        sys.exit(1)

    Er, Ez, Z, R = sys.argv[1:5]
    misfit = calculate_misfit(Er, Ez, Z, R)
    print(misfit)

if __name__ == "__main__":
    main()

