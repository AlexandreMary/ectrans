#!/usr/bin/env bash

# versions of dependencies
fftw_version="3.3.10"
lapack_version="master"
ecbuild_version="master"
fiat_version="1.5.0"

fftw_uri=http://www.fftw.org/fftw-${fftw_version}.tar.gz
lapack_uri=https://github.com/Reference-LAPACK/lapack.git
ecbuild_uri=https://github.com/ecmwf/ecbuild.git
fiat_uri=https://github.com/ecmwf-ifs/fiat.git

# number of threads
export CMAKE_BUILD_PARALLEL_LEVEL=4
# container image to be used
container_uri=docker://quay.io/pypa/manylinux2014_x86_64
# local certificate (for pip)
local_certificate=/etc/ssl/certs/ca-certificates.crt
# python versions for which to build a wheel
export python_versions="cp312-cp312"
#export python_versions="cp310-cp310 cp311-cp311 cp312-cp312 cp313-cp313 cp313-cp313t"

# end of user customisation
# =============================================================================

# working directories
export ECTRANS_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export TMPWORKDIR=$ECTRANS_ROOT/tmp
export SRC=$TMPWORKDIR/src
mkdir -p $TMPWORKDIR
mkdir -p $SRC
# container stuff
export CONTAINER_SIF_PATH="$TMPWORKDIR/$(echo $container_uri | awk -F '/' '{print $NF}').sif"
export CONTAINER_ROOT=/work  # bind path from within the container
export SINGULARITY_BINDPATH=$ECTRANS_ROOT:$CONTAINER_ROOT  # binding out:in
export SINGULARITY_TMPDIR=$TMPWORKDIR/singularity
export REQUESTS_CA_BUNDLE=$TMPWORKDIR/ca-certificates.crt  # accessible copy within the container
mkdir -p $SINGULARITY_TMPDIR
# cmake stuff
export BUILD=$CONTAINER_ROOT/tmp/build
export INSTALL=$CONTAINER_ROOT/tmp/install  # path within the container for the sake of wheel link edition
export CMAKE_INSTALL_PREFIX=$INSTALL
export FFTW_ROOT=$INSTALL
export LAPACK_ROOT=$INSTALL
export fiat_ROOT=$INSTALL
export ecbuild_DIR=$INSTALL

# end of definitions
# =============================================================================

# target action
target=$1
if [ "$target" != "all" ] && [ "$target" != "get" ] && [ "$target" != "deps" ] && [ "$target" != "lib" ] && [ "$target" != "wheel" ]
then
  echo "Argument must be one of 'all', 'get', 'deps', 'lib', 'wheel'"
  exit 1
fi

# get dependencies and container
if [ "$target" == "get" ] || [ "$target" == "all" ]
then
  # clone dependencies packages (out of container)
  git clone $lapack_uri -b $lapack_version $SRC/lapack
  git clone $ecbuild_uri -b $ecbuild_version $SRC/ecbuild
  git clone $fiat_uri -b $fiat_version $SRC/fiat
  # fftw as a tar.gz
  wget ${fftw_uri}
  mv fftw-${fftw_version}.tar.gz $SRC/.
  cd $SRC; tar -xf fftw-${fftw_version}.tar.gz; mv fftw-${fftw_version} fftw; cd -

  # get container
  singularity pull $CONTAINER_SIF_PATH $container_uri
  
  # copy certificate for pip install from within the container
  cp $local_certificate $REQUESTS_CA_BUNDLE
fi

# build dependencies
if [ "$target" == "deps" ] || [ "$target" == "all" ]
then
  singularity run -i $CONTAINER_SIF_PATH bld/deps.sh
fi

# build libfa_[dp|sp].so
if [ "$target" == "lib" ] || [ "$target" == "all" ]
then
  singularity run -i $CONTAINER_SIF_PATH bld/lib.sh
fi
  
# build falfilfa4py python wheels
if [ "$target" == "wheel" ] || [ "$target" == "all" ]
then
  singularity run -i $CONTAINER_SIF_PATH bld/wheel.sh
fi
