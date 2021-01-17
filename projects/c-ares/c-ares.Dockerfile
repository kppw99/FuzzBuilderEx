FROM fuzzbuilderex:v2
LABEL maintainer="Sanghoon(Kevin) Jeon <kppw99@gmail.com>"

ENV CC=/tool/afl-2.52b/afl-gcc
ENV CXX=/tool/afl-2.52b/afl-g++
RUN export
RUN mkdir -p /exp/c-ares/source
