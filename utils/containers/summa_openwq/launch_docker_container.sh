#! /bin/bash
# Set path to the top of Summa-OpenWQ with PROJECT_DIR
# Add the sytnethic tests directory if desired
export PROJECT_DIR=$(realpath $(pwd)/../../../)
export FORCING_DATA_DIR=/home/kklenk/Projects/hydrology/forcing-data/Great-Slave-Lake
export CONFIG_DIR=/home/kklenk/Projects/hydrology/openwq/configuration

docker run -d -it --name SUMMA-openWQ \
    -v $FORCING_DATA_DIR:/input/forcing_data \
    -v $CONFIG_DIR:/input/config \
    -v $PROJECT_DIR:/code/Summa-OpenWQ \
    summa-openwq:latest