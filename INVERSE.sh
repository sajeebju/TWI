#!/bin/sh # Define the observed data files
OBSERVED_Z="/Users/ahasan/Documents/seismology_software/PROJECTFFT7/OBSDIR/Noisy_Convolved_OBS_Z.sac"
OBSERVED_R="/Users/ahasan/Documents/seismology_software/PROJECTFFT7/OBSDIR/Noisy_Convolved_OBS_R.sac"

SYNTHETICS_DIR="/Users/ahasan/Documents/seismology_software/PROJECTFFT7/SYNDIR"

MODELS_DIR="/Users/ahasan/Documents/seismology_software/PROJECTFFT7/MODELSDIR"

BEST_SYNTHETICS_DIR="/Users/ahasan/Documents/seismology_software/PROJECTFFT7/BEST_SYNDIR"

MISFIT_CSV="/Users/ahasan/Documents/seismology_software/PROJECTFFT7/misfits.csv"

echo "Iteration,Misfit" > $MISFIT_CSV

# Initialize variable to store the best misfit and corresponding model
BEST_MISFIT=1e99
BEST_MODEL=""

# Function to generate random model parameters
generate_random_parameters() {
    echo "MODEL.01"
    echo "CUS Model with Q from simple gamma values"
    echo "ISOTROPIC"
    echo "KGS"
    echo "FLAT EARTH"
    echo "1-D"
    echo "CONSTANT VELOCITY"
    echo "LINE08"
    echo "LINE09"
    echo "LINE10"
    echo "LINE11"

    # layer 1
    local h1=$(awk -v min=0.5 -v max=5.0 'BEGIN{srand(); print min+rand()*(max-min)}')
    local vp1=$(awk -v min=4.50 -v max=5.50 'BEGIN{srand(); print min+rand()*(max-min)}')
    local vs1=$(awk -v min=2.50 -v max=3.50 'BEGIN{srand(); print min+rand()*(max-min)}')
    local rho1=$(awk -v min=2.48 -v max=2.52 'BEGIN{srand(); print min+rand()*(max-min)}')
    

    # layer 2
    local h2=$(awk -v min=7.0 -v max=13.0 'BEGIN{srand(); print min+rand()*(max-min)}')
    local vp2=$(awk -v min=5.60 -v max=6.60 'BEGIN{srand(); print min+rand()*(max-min)}')
    local vs2=$(awk -v min=3.00 -v max=4.00 'BEGIN{srand(); print min+rand()*(max-min)}')
    local rho2=$(awk -v min=2.71 -v max=2.75 'BEGIN{srand(); print min+rand()*(max-min)}')

    # layer 3
    local h3=$(awk -v min=8 -v max=14.0 'BEGIN{srand(); print min+rand()*(max-min)}')
    local vp3=$(awk -v min=6.00 -v max=7.00 'BEGIN{srand(); print min+rand()*(max-min)}')
    local vs3=$(awk -v min=3.50 -v max=4.50 'BEGIN{srand(); print min+rand()*(max-min)}')
    local rho3=$(awk -v min=2.80 -v max=2.84 'BEGIN{srand(); print min+rand()*(max-min)}')    

    # layer 4
    # ASSUMING TRUE MODEL 20 KM
    local h4=$(awk -v min=16 -v max=28 'BEGIN{srand(); print min+rand()*(max-min)}')
    local vp4=$(awk -v min=6.20 -v max=7.20 'BEGIN{srand(); print min+rand()*(max-min)}')
    local vs4=$(awk -v min=3.60 -v max=4.60 'BEGIN{srand(); print min+rand()*(max-min)}')
    local rho4=$(awk -v min=2.88 -v max=2.92 'BEGIN{srand(); print min+rand()*(max-min)}')
    
    # layer 5

    local h5=$(awk -v min=6.00 -v max=12.00 'BEGIN{srand(); print min+rand()*(max-min)}')
    local vp5=$(awk -v min=7.50 -v max=8.50 'BEGIN{srand(); print min+rand()*(max-min)}')
    local vs5=$(awk -v min=4.50 -v max=5.50 'BEGIN{srand(); print min+rand()*(max-min)}')
    local rho5=$(awk -v min=2.96 -v max=3.00 'BEGIN{srand(); print min+rand()*(max-min)}')

    # layer 6

    local h6=$(awk -v min=4 -v max=8 'BEGIN{srand(); print min+rand()*(max-min)}')
    local vp6=$(awk -v min=7.80 -v max=8.60 'BEGIN{srand(); print min+rand()*(max-min)}')
    local vs6=$(awk -v min=4.60 -v max=5.60 'BEGIN{srand(); print min+rand()*(max-min)}')
    local rho6=$(awk -v min=3.04 -v max=3.08 'BEGIN{srand(); print min+rand()*(max-min)}')
   
    # layer 7

    local h7=$(awk -v min=4 -v max=8 'BEGIN{srand(); print min+rand()*(max-min)}')
    local vp7=$(awk -v min=8.00 -v max=8.60 'BEGIN{srand(); print min+rand()*(max-min)}')
    local vs7=$(awk -v min=4.70 -v max=5.80 'BEGIN{srand(); print min+rand()*(max-min)}')
    local rho7=$(awk -v min=3.12 -v max=3.16 'BEGIN{srand(); print min+rand()*(max-min)}')

    # halfspace
    local vp8=$(awk -v min=8.00 -v max=8.70 'BEGIN{srand(); print min+rand()*(max-min)}')
    local vs8=$(awk -v min=4.80 -v max=5.90 'BEGIN{srand(); print min+rand()*(max-min)}')
    local rho8=$(awk -v min=3.34 -v max=3.39 'BEGIN{srand(); print min+rand()*(max-min)}')


    echo "  H(KM) VP(KM/S) VS(KM/S) RHO(GM/CC)   QP   QS  ETAP  ETAS  FREFP  FREFS"
    echo " $h1    $vp1   $vs1 $rho1 0 0 0 0 1 1"
    echo " $h2    $vp2   $vs2 $rho2 0 0 0 0 1 1"
    echo " $h3    $vp3   $vs3 $rho3 0 0 0 0 1 1"
    echo " $h4    $vp4   $vs4 $rho4 0 0 0 0 1 1"
    echo " $h5    $vp5   $vs5 $rho5 0 0 0 0 1 1" 
    echo " $h6    $vp6   $vs6 $rho6 0 0 0 0 1 1"
    echo " $h7    $vp7   $vs7 $rho7 0 0 0 0 1 1"
    echo " 0.00   $vp8   $vs8 $rho8 0 0 0 0 1 1"
}


# Iterate over 1000 SCM.mod model parameter files
for i in $(seq 1 1000); do
    MODEL_FILE="${MODELS_DIR}/SCM_${i}.mod"
    
    generate_random_parameters > $MODEL_FILE

    hrftn96 -M $MODEL_FILE -RAYP 0.07 -DT 0.05 -NPTS 2048 -P -z
    mv hrftn96.sac "$SYNTHETICS_DIR/SYN_Ez_${i}.sac"
    hrftn96 -M $MODEL_FILE -RAYP 0.07 -DT 0.05 -NPTS 2048 -P -r
    mv hrftn96.sac "$SYNTHETICS_DIR/SYN_Er_${i}.sac"


    misfit=$(python3 calculate_misfit.py "$SYNTHETICS_DIR/SYN_Er_${i}.sac" "$SYNTHETICS_DIR/SYN_Ez_${i}.sac" $OBSERVED_Z $OBSERVED_R)
    echo "${i},${misfit}" >> $MISFIT_CSV


    # Update the best misfit and model if the current misfit is lower
    if [ "$(echo "$misfit < $BEST_MISFIT" | bc)" -eq 1 ]; then
        BEST_MISFIT=$misfit
        BEST_MODEL=$MODEL_FILE
	cp ${MODEL_FILE} BEST.mod

        cp "$SYNTHETICS_DIR/SYN_Ez_${i}.sac" "${BEST_SYNTHETICS_DIR}/SYN_Ez_best.sac"
        cp "$SYNTHETICS_DIR/SYN_Er_${i}.sac" "${BEST_SYNTHETICS_DIR}/SYN_Er_best.sac"

    fi
done

# Output the best model and its misfit
echo "Best Model: $BEST_MODEL"
echo "Best Misfit: $BEST_MISFIT"


