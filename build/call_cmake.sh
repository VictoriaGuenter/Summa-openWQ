#! /bin/bash

cmake -S. -B_build -DEXEC_DIR=/code/Summa-OpenWQ/bin -DCOMPILE_TARGET=summa_openwq -DCMAKE_BUILD_TYPE=debug
cmake --build _build -j 4