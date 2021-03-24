FROM fuzzbuilderex:base
MAINTAINER Sanghoon(Kevin) Jeon <kppw99@gmail.com>

# Set environment variable of afl-gcc, afl-g++
ENV PATH=$PATH:/tool/afl-2.52b
ENV AFL_PATH=/tool/afl-2.52b

# Download source code
RUN mkdir -p /exp/c-ares/source
WORKDIR /exp/c-ares/source
RUN git clone https://github.com/c-ares/c-ares.git
WORKDIR /exp/c-ares/source/c-ares
RUN git checkout a9c2068e25a107bf535b1fc988eec47384b86dc6
RUN cp -rf /exp/c-ares/build_new.sh /exp/c-ares/source/c-ares && cp -rf /exp/c-ares/StandaloneFuzzTargetMain.c /exp/c-ares/source/c-ares

# Build project
WORKDIR /exp/c-ares/source/c-ares
RUN chmod 744 ./build_new.sh
RUN rm -f $(find . -name ".bc") && ./build_new.sh seed

WORKDIR /
