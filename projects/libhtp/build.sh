#!/bin/bash -eu
# Copyright 2018 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

# [ Dependencies ]

# apt-get update && apt-get install -y make autoconf automake libtool zlib1g-dev liblzma-dev
# git clone https://github.com/kobolabs/liblzma liblzma
# git clone --depth 1 https://github.com/OISF/libhtp.git libhtp


# liblzma package does not support -m32 option. Manual build required...
LIBLZMA_DIR=$PWD/liblzma
LIB32_DIR=/usr/lib32
CC=/tool/afl-2.52b/afl-clang
CXX=/tool/afl-2.52b/afl-clang++

# git clone https://github.com/kobolabs/liblzma liblzma

if [ -e "$LIB32_DIR/liblzma.so" ];
then
    :
else
    pushd liblzma
    
    ./configure 
    ./configure CFLAGS="-m32" CXXFLAGS="-m32" LDFLAGS="-m32"
    make

    # install .a & .so files
    ln -s $LIBLZMA_DIR/src/liblzma/.libs/liblzma.so /usr/lib32
    ln -s $LIBLZMA_DIR/src/liblzma/.libs/liblzma.so.5 /usr/lib32
    ln -s $LIBLZMA_DIR/src/liblzma/.libs/liblzma.a /usr/lib32

    popd
fi


if [ "$#" -ge "1" ] && [ $1 == "cov" ];
then
    CFLAGS_TEST="-m32"
    CXXFLAGS_TEST="-m32"
    CFLAGS="-fprofile-arcs -ftest-coverage -m32"
    CXXFLAGS="-fprofile-arcs -ftest-coverage -m32"
    LDFLAGS="-fprofile-arcs -ftest-coverage -m32"
    LDFLAGS_TEST="-fprofile-arcs -ftest-coverage -m32"
else
    CFLAGS_TEST="-m32"
    CXXFLAGS_TEST="-m32"
    CFLAGS="-m32"
    CXXFLAGS="-m32"
    LDFLAGS="-m32 -static"
    LDFLAGS_TEST="-m32"
fi

# modify afl-clang PATH below
CC=/tool/afl-2.52b/afl-clang
CXX=/tool/afl-2.52b/afl-clang++
SRC=.
OUT=.
WORK=.

# git clone --depth 1 https://github.com/OISF/libhtp.git libhtp
# build project
cd libhtp
sh autogen.sh
./configure CC=$CC CXX=$CXX CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS"
# Trouble Shooting - 32-bit problem like below...
# 
#   configure:16005: checking for inflate in -lz
#   configure:16030: /home/user/work/AFL/afl-clang -o conftest -m32 -O2  -O2 -m32 -static conftest.c -lz
#   /usr/bin/ld: skipping incompatible //usr/lib/x86_64-linux-gnu/libz.a 
# 
# Solution : sudo apt install lib32z1-dev
if [[ "$#" -ge "1" && ( $1 == "seed" || $1 == "cov" ) ]]
then
    make 
    $CXX $CXXFLAGS_TEST -I. -c ../fuzzer_main.cc -o fuzzer_main.o

    $CC $CFLAGS -I. -c test/fuzz/fuzz_htp.c -o fuzz_htp.o
    $CC $CFLAGS -I. -c test/test.c -o test.o    

    zip -r $OUT/fuzz_htp_seed_corpus.zip test/files/*.t
else
    AFL_USE_ASAN=1 make
fi


if [[ "$#" -ge "1" && $1 == "seed" ]];
then
    exit
fi

# fuzzer_main.o build
$CXX $CXXFLAGS_TEST -I. -c ../fuzzer_main.cc -o fuzzer_main.o

$CC $CFLAGS -I. -c test/fuzz/fuzz_htp.c -o fuzz_htp.o
$CC $CFLAGS -I. -c test/test.c -o test.o

# add fuzzer_main.o, instead of $LIB_FUZZING_ENGINE
AFL_USE_ASAN=1 $CXX $CXXFLAGS fuzz_htp.o test.o -o $OUT/fuzz_htp ./htp/.libs/libhtp.a fuzzer_main.o -lz -llzma

# builds corpus
zip -r $OUT/fuzz_htp_seed_corpus.zip test/files/*.t
