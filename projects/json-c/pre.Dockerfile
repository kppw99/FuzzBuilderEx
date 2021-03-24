FROM fuzzbuilderex:base
MAINTAINER Sanghoon(Kevin) Jeon <kppw99@gmail.com>

# Set environment variable of afl-gcc, afl-g++
ENV PATH=$PATH:/tool/afl-2.52b
ENV AFL_PATH=/tool/afl-2.52b
ENV CC=afl-gcc
ENV CXX=afl-g++

COPY . /exp/json-c/

# Download source code
RUN mkdir -p /exp/json-c/source
WORKDIR /exp/json-c/source
RUN git clone https://github.com/json-c/json-c.git json-c
WORKDIR /exp/json-c/source/json-c
RUN git checkout df27756491abf9ecce648c3aa85d6a70feb4c600

# Build project
RUN mkdir build
WORKDIR /exp/json-c/source/json-c/build
RUN CFLAGS=-m32 CXXFLAGS=-m32 cmake -DBUILD_SHARED_LIBS=OFF ..
RUN make

WORKDIR /
