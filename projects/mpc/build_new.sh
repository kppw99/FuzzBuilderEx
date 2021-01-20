#!/bin/bash -eu

if [ "$#" -ge "1" ] && [ $1 == "cov" ];
then
    CFLAGS_TEST="-m32"
    CXXFLAGS_TEST="-m32"
    CFLAGS="-m32 -fprofile-arcs -ftest-coverage"
    CXXFLAGS="-m32 -fprofile-arcs -ftest-coverage"
    LDFLAGS="-m32 -fprofile-arcs -ftest-coverage"
    LDFLAGS_TEST="-m32 -fprofile-arcs -ftest-coverage"
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
OUT=.

make clean

if [[ "$#" -ge "1" && ( $1 == "cov" || $1 == "seed" ) ]]
then
    make
    make check || set ?=0
else
    AFL_USE_ASAN=1 make
    ASAN_OPTIONS=detect_leaks=0 AFL_USE_ASAN=1 make check || set ?=0
fi

if [[ "$#" -ge "1" && ( $1 == "seed" ) ]]
then
    exit
fi


#$CC $CFLAGS_TEST -I. -c $SRC/mpc.c -o mpc.o
#AFL_USE_ASAN=1 $CC $CFLAGS_TEST $LDFLAGS_TEST $SRC/mpc.o -o mpc build/libmpc.a
