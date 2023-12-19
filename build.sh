#!/bin/bash

set -euo pipefail

td="$(cd $(dirname $0) && pwd)"

has_ccache=false
if (command -v ccache &> /dev/null); then
  has_ccache=true
fi
has_clang=false
if (command -v clang &> /dev/null) && (command -v clang++ &> /dev/null); then
  has_clang=true
fi

if ! $has_clang; then
    echo "error: clang not found. Please install."
    exit 1
else
    RAW_CC="clang"
    RAW_CXX="clang++"
fi

# Find the dynamic asan library.
libclang_rt_path="$(clang -print-file-name=libclang_rt.asan-$(uname -m).so)"
if [ -z "$libclang_rt_path" ]; then
    echo "Could not find ASAN shared library"
    exit 1
fi

echo "export LIBCLANG_RT_PATH='$libclang_rt_path'
export LD_LIBRARY_PATH=$(dirname $libclang_rt_path)
export ASAN_OPTIONS='detect_leaks=0'
export CC=$RAW_CC
export CXX=$RAW_CXX
export CFLAGS=""
export CXXFLAGS=""
" > $td/env

source $td/env

echo "Using:"
echo "  CC=$CC"
echo "  CXX=$CXX"
echo "  CFLAGS=$CFLAGS"
echo "  CXXFLAGS=$CXXFLAGS"

# Set up ccache.
if $has_ccache; then
    echo "Enabling ccache"
    export CC="ccache $CC"
    export CXX="ccache $CXX"
fi

src_dir="$td/cpython-src"
build_dir="$td/build"
install_dir="$td/install"
mkdir -p $build_dir $install_dir

cd $build_dir
echo "CONFIGURING"
echo "-----------"
"$src_dir/configure" --prefix=$install_dir --with-address-sanitizer

echo "BUILDING"
echo "--------"
make -j

