FROM fuzzbuilderex:base
MAINTAINER Sanghoon(Kevin) Jeon <kppw99@gmail.com>

# Set environment variable of afl-gcc, afl-g++
ENV PATH=$PATH:/tool/afl-2.52b
ENV AFL_PATH=/tool/afl-2.52b
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y make autoconf automake libtool zlib1g-dev liblzma-dev lib32z1-dev

COPY . /exp/libhtp/

# Download source code
WORKDIR /exp/libhtp
RUN mkdir source
WORKDIR /exp/libhtp/source
RUN git clone https://github.com/kobolabs/liblzma liblzma
RUN git clone https://github.com/OISF/libhtp.git libhtp
WORKDIR /exp/libhtp/source/liblzma
RUN git checkout 87b7682ce4b1c849504e2b3641cebaad62aaef87
WORKDIR /exp/libhtp/source/libhtp
RUN git checkout e198e8f280dec64f048b7e8e84cb33753c2b919d

# Build project
WORKDIR /exp/libhtp
RUN cp -rf fuzzer_main.cc build.sh source
WORKDIR /exp/libhtp/source
RUN rm -rf libhtp/*.bc libhtp/*.o && chmod 744 build.sh
RUN ./build.sh seed

WORKDIR /
