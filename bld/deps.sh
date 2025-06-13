#!/usr/bin/env bash

FFTW=1
LAPACK=1
ECBUILD=1
FIAT=1

# 1. FFTW
if [ "$FFTW" == 1 ]; then
rm -rf $BUILD
export CFLAGS="-fPIC"
export FFLAGS="-fPIC"
OPTIONS="-S $SRC/fftw -B $BUILD -DCMAKE_INSTALL_PREFIX=$FFTW_ROOT -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DBUILD_SHARED_LIBS=OFF"
#OPTIONS="-S $SRC/fftw -B $BUILD -DCMAKE_INSTALL_PREFIX=$FFTW_ROOT -DCMAKE_POLICY_VERSION_MINIMUM=3.5"
cmake $OPTIONS
cmake --build $BUILD
cmake --install $BUILD
fi

# 2. LAPACK
if [ "$LAPACK" == 1 ]; then
rm -rf $BUILD
OPTIONS="-S $SRC/lapack -B $BUILD -DCMAKE_INSTALL_PREFIX=$LAPACK_ROOT"
cmake $OPTIONS
cmake --build $BUILD
cmake --install $BUILD
fi

# 3. ecbuild
if [ "$ECBUILD" == 1 ]; then
rm -rf $BUILD
OPTIONS="-S $SRC/ecbuild -B $BUILD -DCMAKE_INSTALL_PREFIX=$ecbuild_DIR"
cmake $OPTIONS
cmake --build $BUILD
cmake --install $BUILD
fi

# 4. fiat
if [ "$FIAT" == 1 ]; then
rm -rf $BUILD
OPTIONS="-S $SRC/fiat -B $BUILD -DCMAKE_INSTALL_PREFIX=$fiat_ROOT -DENABLE_OMP=OFF -DENABLE_MPI=OFF"
cmake $OPTIONS
cmake --build $BUILD
cmake --install $BUILD
fi
