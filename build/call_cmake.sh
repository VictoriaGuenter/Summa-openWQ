#! /bin/bash

# Change the paths to your 

module load StdEnv/2020
module load gcc/9.3.0
module load openblas/0.3.17
module load netcdf-fortran/4.5.2 # HDF5/1.10.6
module load boost

export ARMA_INCLUDES=/home/kklenk/OpenWQ-Projects/local_libraries/armadillo-10.3.0/include
export ARMA_LIB=/home/kklenk/OpenWQ-Projects/local_libraries/armadillo-10.3.0/libarmadillo.so.10
EXEC_DIR=/home/kklenk/OpenWQ-Projects/Summa-openWQ/bin


cmake -S. -B_build -D -DCOMPILE_TARGET=summa_openwq -DCMAKE_BUILD_TYPE=debug
cmake --build _build -j 4