FROM debian:stretch

LABEL maintainer="onsoim <onsoim@gmail.com>"

# Install Basic Development Packages
RUN apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install dialog apt-utils git wget build-essential cmake gcc-multilib g++-multilib gnupg zip autoconf automake libtool docbook2x zlib1g-dev rapidjson-dev apt-transport-https ca-certificates apt-utils vim gnuplot

# Install LLVM Development Package
RUN echo "#LLVM Repository" >> /etc/apt/sources.list && \
    echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-6.0 main" >> /etc/apt/sources.list && \
    echo "deb-src http://apt.llvm.org/stretch/ llvm-toolchain-stretch-6.0 main" >> /etc/apt/sources.list && \
    wget -O ./key.gpg https://apt.llvm.org/llvm-snapshot.gpg.key --no-check-certificate && \
    apt-key add < ./key.gpg && \
    rm ./key.gpg && \
    apt-get -y update && \
    apt-get -y install clang-6.0 clang-6.0-dev llvm-6.0 llvm-6.0-dev && \
    ln -s /usr/bin/clang-6.0 /usr/bin/clang && \
    ln -s /usr/bin/clang++-6.0 /usr/bin/clang++

# Install AFL
RUN mkdir -p tool && cd /tool && \
    wget http://lcamtuf.coredump.cx/afl/releases/afl-2.52b.tgz && \
    tar zxvf afl-2.52b.tgz && \
    cd /tool/afl-2.52b && \
    make

# Install FuzzBuilder
COPY source/src/ /fuzzbuilder
RUN mkdir -p /fuzzbuilder/build && \
    cd /fuzzbuilder/build && \
    cmake build .. && \
    make && \
    mv /fuzzbuilder/build/fuzzbuilder /tool/
COPY source/script/ /tool/

# Install OSS-Fuzz
RUN mkdir -p /exp/oss-fuzz && cd /exp/oss-fuzz && \
    git clone https://github.com/google/oss-fuzz.git source && \
    cd /exp/oss-fuzz/source && \
    git checkout a55a1276d9e0c453f588160b7e3581cdf6236013

# Install FASelector Dependencies
WORKDIR /tool
RUN bash FASelector.sh

# docker build -t fuzzbuilderex:base .
