# Nonlinear Inversion for 1-D Crustal Velocity Structure Using Cross-Convolution of Teleseismic Waveforms
Here only added the 7 layer and half space test 
We used Central US Model CUS.mod -> SCM.mod to generate synthetic earth response using the scripts

#!/bin/sh "\n"
MODEL_FILE="/Users/ahasan/Documents/seismology_software/PROJECTFFT/OBSDIR/SCM.mod"
hrftn96 -M "$MODEL_FILE" -RAYP 0.07 -DT 0.05 -NPTS 2048 -P -z
mv hrftn96.sac "OBS_Z.sac"
hrftn96 -M "$MODEL_FILE" -RAYP 0.07 -DT 0.05 -NPTS 2048 -P -r
mv hrftn96.sac "OBS_R.sac"

hrftn96, a program of Computer Program in Seismology (Herrmann, 2013) is used to generate synthetic seismograms


