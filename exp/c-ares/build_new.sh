#!/bin/bash -eu
# Copyright 2016 Google Inc.
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

# Remove -DFUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION from CFLAGS
# as a workaround for https://github.com/google/oss-fuzz/issues/413.
# It's unclear why the c-ares configure is that picky;
# a better fix would probably be in the c-ares build system.

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

CC=/tool/afl-2.52b/afl-clang
CXX=/tool/afl-2.52b/afl-clang++
nproc=1
SRC=.
WORK=.
OUT=.

CFLAGS=$(for f in $CFLAGS; do [ $f != "-DFUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION" ] && echo $f; done);

# Build the project.
./buildconf
./configure CC=$CC CXX=$CXX CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS"
make clean

if [[ "$#" -ge "1" && ( $1 == "seed" || $1 == "cov" ) ]]
then
    make -j$(nproc) V=1 all
else
    AFL_USE_ASAN=1 make -j$(nproc) V=1 all
fi

pushd test
./configure CC=$CC CXX=$CXX CFLAGS="$CFLAGS_TEST" CXXFLAGS="$CXXFLAGS_TEST" LDFLAGS="$LDFLAGS_TEST"

make clean

if [[ "$#" -ge "1" && ( $1 == "seed" || $1 == "cov" ) ]]
then
    make -j$(nproc) V=1
else
    AFL_USE_ASAN=1 make -j$(nproc) V=1
fi
popd

if [[ "$#" -ge "1" && $1 == "seed" ]];
then
    exit
fi

# Build the fuzzers.
$CC $CFLAGS_TEST -I. -c test/ares-test-fuzz.c -o ares-test-fuzz.o

$CXX $CXXFLAGS_TEST -I. -c StandaloneFuzzTargetMain.c

AFL_USE_ASAN=1 $CXX $CXXFLAGS_TEST $LDFLAGS_TEST -std=c++11 ares-test-fuzz.o StandaloneFuzzTargetMain.o \
    -o ares_parse_reply_fuzzer .libs/libcares.a

$CC $CFLAGS_TEST -I. -c test/ares-test-fuzz-name.c \
    -o ares-test-fuzz-name.o

AFL_USE_ASAN=1 $CXX $CXXFLAGS_TEST $LDFLAGS_TEST -std=c++11 ares-test-fuzz-name.o StandaloneFuzzTargetMain.o \
    -o ares_create_query_fuzzer .libs/libcares.a

# Archive and copy to $OUT seed corpus if the build succeeded.
zip -j ares_parse_reply_fuzzer_seed_corpus.zip test/fuzzinput/*
zip -j ares_create_query_fuzzer_seed_corpus.zip test/fuzznames/*
