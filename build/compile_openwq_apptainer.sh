#! /bin/bash

#######
# Add the paths for
# 1) the singularity/apptainer container
# 2) the Summa-openWQ source code
#######
APPTAINER_SIF="/home/kklenk/OpenWQ-Projects/openwq.sif"
Summa_openWQ_SOURCE_DIR="/home/kklenk/OpenWQ-Projects/Summa-openWQ"

singularity exec \
  --bind $Summa_openWQ_SOURCE_DIR:/code/Summa-openWQ \
  --pwd /code/Summa-openWQ/build/source/openwq/openwq/ \
  ${APPTAINER_SIF} \
  /code/Summa-openWQ/build/call_cmake.sh
