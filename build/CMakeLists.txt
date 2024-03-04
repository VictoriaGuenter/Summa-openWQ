CMAKE_MINIMUM_REQUIRED(VERSION 3.10 FATAL_ERROR)
PROJECT(openwq_summa LANGUAGES CXX Fortran)

if(NOT CMAKE_BUILD_TYPE)
    set(COMPILE_MODE fast)
else()
    SET(COMPILE_MODE ${CMAKE_BUILD_TYPE})
endif()


# Declare use of multiple Languages
ENABLE_LANGUAGE(C)
INCLUDE(FortranCInterface)
FortranCInterface_VERIFY(CXX)
SET(CMAKE_CXX_STANDARD 17)

find_package(HDF5 REQUIRED)
find_package(Boost REQUIRED)
find_package(LAPACK REQUIRED)

# Compile openWQ
SET(exec_name "summa_openwq_${COMPILE_MODE}")
# Default executable directory (Change with -DEXEC_DIR=...)
SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../bin)
MESSAGE(STATUS "Executable directory: ${EXEC_DIR}")
# OpenWQ Files

SET(OPENWQ_DIR ${CMAKE_CURRENT_SOURCE_DIR}/source/openwq/openwq)
FILE(GLOB OPENWQ_SOURCES 
          ${OPENWQ_DIR}/src/*.cpp 
          ${OPENWQ_DIR}/src/global/*.cpp
          ${OPENWQ_DIR}/src/extwatflux_ss/*.cpp
          ${OPENWQ_DIR}/src/initiate/*.cpp
          ${OPENWQ_DIR}/src/chem/*.cpp
          ${OPENWQ_DIR}/src/watertransp/*.cpp
          ${OPENWQ_DIR}/src/readjson/*.cpp
          ${OPENWQ_DIR}/src/couplercalls/*.cpp
          ${OPENWQ_DIR}/src/output/*.cpp
          ${OPENWQ_DIR}/src/solver/*.cpp
          ${OPENWQ_DIR}/src/units/*.cpp
          ${OPENWQ_DIR}/src/utils/*.cpp)
SET(OPENWQ_INCLUDES ${OPENWQ_DIR}/src/)
MESSAGE(STATUS "OpenWQ source files: ${OPENWQ_DIR}")

# Set up the C++ flags
IF("${COMPILE_MODE}" STREQUAL "debug")
    SET(CMAKE_CXX_FLAGS "-g -Wall -pedantic")
ELSEIF("${COMPILE_MODE}" STREQUAL "fast")
    FIND_PACKAGE(OpenMP)
    SET(CMAKE_CXX_FLAGS "-O3 -Wall -pedantic ${OpenMP_CXX_FLAGS}")
ENDIF()


SET(SUMMA_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../)
FILE(GLOB HYDROLINK_SOURCES 
        ${SUMMA_DIR}/build/source/openwq/OpenWQ_hydrolink.cpp
        ${SUMMA_DIR}/build/source/openwq/OpenWQ_interface.cpp)


# File definitions for subcomponents - For Summa
SET(DRIVER_DIR ${SUMMA_DIR}/build/source/driver)
SET(HOOKUP_DIR ${SUMMA_DIR}/build/source/hookup)
SET(NETCDF_DIR ${SUMMA_DIR}/build/source/netcdf)
SET(DSHARE_DIR ${SUMMA_DIR}/build/source/dshare)
SET(NOAHMP_DIR ${SUMMA_DIR}/build/source/noah-mp)
SET(ENGINE_DIR ${SUMMA_DIR}/build/source/engine)
SET(OPENWQ_INTERFACE_DIR ${SUMMA_DIR}/build/source/openwq)
#  utilities
SET(NRUTIL
    ${ENGINE_DIR}/nrtype.f90
    ${ENGINE_DIR}/f2008funcs.f90
    ${ENGINE_DIR}/nr_utility.f90)
# Numerical recipes procedures
SET(NRPROC
    ${ENGINE_DIR}/expIntegral.f90
    ${ENGINE_DIR}/spline_int.f90)
# Hook-up modules (set files and directory paths)
SET(HOOKUP
    ${HOOKUP_DIR}/ascii_util.f90
    ${HOOKUP_DIR}/summaFileManager.f90)
# Data modules
SET(DATAMS
    ${OPENWQ_INTERFACE_DIR}/openWQ.f90 # needs to be compiled before globalData
    ${DSHARE_DIR}/multiconst.f90
    ${DSHARE_DIR}/var_lookup.f90
    ${DSHARE_DIR}/data_types.f90
    ${DSHARE_DIR}/globalData.f90
    ${DSHARE_DIR}/flxMapping.f90
    ${DSHARE_DIR}/get_ixname.f90
    ${DSHARE_DIR}/popMetadat.f90
    ${DSHARE_DIR}/outpt_stat.f90)
# utility modules
SET(UTILMS
    ${ENGINE_DIR}/time_utils.f90
    ${ENGINE_DIR}/mDecisions.f90
    ${ENGINE_DIR}/snow_utils.f90
    ${ENGINE_DIR}/soil_utils.f90
    ${ENGINE_DIR}/updatState.f90
    ${ENGINE_DIR}/matrixOper.f90)
# Solver
SET(SOLVER
    ${ENGINE_DIR}/vegPhenlgy.f90
    ${ENGINE_DIR}/diagn_evar.f90
    ${ENGINE_DIR}/stomResist.f90
    ${ENGINE_DIR}/groundwatr.f90
    ${ENGINE_DIR}/vegSWavRad.f90
    ${ENGINE_DIR}/vegNrgFlux.f90
    ${ENGINE_DIR}/ssdNrgFlux.f90
    ${ENGINE_DIR}/vegLiqFlux.f90
    ${ENGINE_DIR}/snowLiqFlx.f90
    ${ENGINE_DIR}/soilLiqFlx.f90
    ${ENGINE_DIR}/bigAquifer.f90
    ${ENGINE_DIR}/computFlux.f90
    ${ENGINE_DIR}/computResid.f90
    ${ENGINE_DIR}/computJacob.f90
    ${ENGINE_DIR}/eval8summa.f90
    ${ENGINE_DIR}/summaSolve.f90
    ${ENGINE_DIR}/systemSolv.f90
    ${ENGINE_DIR}/varSubstep.f90
    ${ENGINE_DIR}/opSplittin.f90
    ${ENGINE_DIR}/coupled_em.f90
    ${ENGINE_DIR}/run_oneGRU.f90
    ${ENGINE_DIR}/run_oneHRU.f90)
# Define routines for SUMMA preliminaries
SET(PRELIM
    ${ENGINE_DIR}/conv_funcs.f90
    ${ENGINE_DIR}/sunGeomtry.f90
    ${ENGINE_DIR}/convE2Temp.f90
    ${ENGINE_DIR}/allocspace.f90
    ${ENGINE_DIR}/checkStruc.f90
    ${ENGINE_DIR}/childStruc.f90
    ${ENGINE_DIR}/ffile_info.f90
    ${ENGINE_DIR}/read_attrb.f90
    ${ENGINE_DIR}/read_pinit.f90
    ${ENGINE_DIR}/pOverwrite.f90
    ${ENGINE_DIR}/read_param.f90
    ${ENGINE_DIR}/paramCheck.f90
    ${ENGINE_DIR}/check_icond.f90
    ${OPENWQ_INTERFACE_DIR}/summa_openWQ_allocspace.f90)
# Define routines for the SUMMA model runs
SET(MODRUN
    ${ENGINE_DIR}/indexState.f90
    ${ENGINE_DIR}/getVectorz.f90
    ${ENGINE_DIR}/updateVars.f90
    ${ENGINE_DIR}/var_derive.f90
    ${ENGINE_DIR}/read_force.f90
    ${ENGINE_DIR}/derivforce.f90
    ${ENGINE_DIR}/snowAlbedo.f90
    ${ENGINE_DIR}/canopySnow.f90
    ${ENGINE_DIR}/tempAdjust.f90
    ${ENGINE_DIR}/snwCompact.f90
    ${ENGINE_DIR}/layerMerge.f90
    ${ENGINE_DIR}/layerDivide.f90
    ${ENGINE_DIR}/volicePack.f90
    ${ENGINE_DIR}/qTimeDelay.f90)
SET(NETCDF
    ${NETCDF_DIR}/netcdf_util.f90
    ${NETCDF_DIR}/def_output.f90
    ${NETCDF_DIR}/modelwrite.f90
    ${NETCDF_DIR}/read_icond.f90)
# Stitch together common programs
SET(COMM_ALL
    ${NRPROC}
    ${HOOKUP}
    ${DATAMS}
    ${UTILMS})
# Stitch together SUMMA programs
SET(SUMMA_ALL
    ${NETCDF}
    ${PRELIM}
    ${MODRUN}
    ${SOLVER})
# Define the driver routine
SET(DRIVER
    ${DRIVER_DIR}/summa_type.f90
    ${DRIVER_DIR}/summa_util.f90
    ${DRIVER_DIR}/summa_alarms.f90
    ${DRIVER_DIR}/summa_globalData.f90
    ${DRIVER_DIR}/summa_defineOutput.f90
    ${DRIVER_DIR}/summa_init.f90
    ${DRIVER_DIR}/summa_setup.f90
    ${DRIVER_DIR}/summa_restart.f90
    ${DRIVER_DIR}/summa_forcing.f90
    ${DRIVER_DIR}/summa_modelRun.f90
    ${DRIVER_DIR}/summa_writeOutput.f90
    ${OPENWQ_INTERFACE_DIR}/summa_openWQ.f90
    ${DRIVER_DIR}/summa_driver.f90)

    
IF("${COMPILE_MODE}" STREQUAL "debug")
    SET(CMAKE_Fortran_FLAGS "-p -g -Wall -ffree-line-length-none -fmax-errors=0 -fbacktrace -fcheck=bounds")
ELSEIF("${COMPILE_MODE}" STREQUAL "fast")
    SET(CMAKE_Fortran_FLAGS "-O3 -ffree-line-length-none -fmax-errors=0 -lstdc++")
ENDIF()


# compile openWQ into an object file
ADD_LIBRARY(openWQ OBJECT ${OPENWQ_SOURCES} ${HYDROLINK_SOURCES})
TARGET_INCLUDE_DIRECTORIES(openWQ PRIVATE
                           $ENV{ARAMA_INCLUDES}
                            ${HDF5_INCLUDE_DIRS}
                            ${OPENWQ_INCLUDES})

TARGET_LINK_LIBRARIES(openWQ PUBLIC
                      $ENV{ARMA_LIB}
                      ${HDF5_C_LIBRARY_hdf5})

IF(OpenMP_CXX_FOUND)
    MESSAGE("** OpenWQ **: OpenMP enabled!")
    TARGET_LINK_LIBRARIES(openWQ PUBLIC OpenMP::OpenMP_CXX)
ENDIF()

# Compile the NOAHMP into object/.mod files
ADD_LIBRARY(SUMMA_NOAHMP OBJECT
    ${NOAHMP_DIR}/module_model_constants.F
    ${NOAHMP_DIR}/module_sf_noahutl.F
    ${NOAHMP_DIR}/module_sf_noahlsm.F
    ${NOAHMP_DIR}/module_sf_noahmplsm.F
    ${NRUTIL})
IF("${COMPILE_MODE}" STREQUAL "debug")
    target_compile_options(SUMMA_NOAHMP PRIVATE -p -g -ffree-form -ffree-line-length-none -fmax-errors=0 -fbacktrace -Wno-unused -Wno-unused-dummy-argument)
ELSEIF("${COMPILE_MODE}" STREQUAL "fast")
    target_compile_options(SUMMA_NOAHMP PRIVATE -O3 -ffree-form -ffree-line-length-none -fmax-errors=0 -lstdc++ -fopenmp)
ENDIF()


# Compile Summa_Comm into object/.mod files
ADD_LIBRARY(SUMMA_COMM OBJECT ${COMM_ALL})
IF("${COMPILE_MODE}" STREQUAL "debug")
    target_compile_options(SUMMA_COMM PRIVATE -p -g -Wall -ffree-line-length-none -fmax-errors=0 -fbacktrace -fcheck=bounds)
ELSEIF("${COMPILE_MODE}" STREQUAL "fast")
    target_compile_options(SUMMA_COMM PRIVATE -O3 -ffree-line-length-none -fmax-errors=0 -lstdc++ -fopenmp)
ENDIF() 

TARGET_INCLUDE_DIRECTORIES(SUMMA_COMM PRIVATE
    $ENV{EBROOTNETCDFMINFORTRAN}/include)
TARGET_LINK_LIBRARIES(SUMMA_COMM PUBLIC
    -lnetcdff
    SUMMA_NOAHMP)

# Create the executable with openWQ coupled to Summa                 
ADD_EXECUTABLE(${exec_name}
    ${SUMMA_ALL}
    ${DRIVER})
    SET_PROPERTY(TARGET ${exec_name} PROPERTY LINKER_LANGUAGE Fortran)
    TARGET_INCLUDE_DIRECTORIES(
            ${exec_name} PUBLIC
            ${LAPACK_INCLUDES}
            $ENV{EBROOTNETCDFMINFORTRAN}/include)
    TARGET_LINK_LIBRARIES(
            ${exec_name} PUBLIC
            -lnetcdff
            ${LAPACK_LIBRARIES}
            SUMMA_COMM
            SUMMA_NOAHMP
            openWQ)
