FROM fuzzbuilderex:base

LABEL maintainer="onsoim <onsoim@gmail.com>"

# [expat]
ENV NAME expat
COPY . /exp/expat

# 1. Prepare source codes
RUN mkdir -p /exp/expat/source && cd /exp/expat/source && git clone https://github.com/libexpat/libexpat && cd /exp/expat/source/libexpat && git checkout 39e487da353b20bb3a724311d179ba0fddffc65b && cp /exp/expat/fuzzer_main.cc /exp/expat/source/libexpat/expat && cp /exp/oss-fuzz/source/projects/expat/parse_fuzzer.cc /exp/expat/source/libexpat/expat && cp /exp/expat/build_new.sh /exp/expat/source/libexpat/expat && cp /exp/expat/StandaloneFuzzTargetMain.c /exp/expat/source/libexpat/expat

# 2. FuzzBuilder (seed)
WORKDIR /exp/expat/source/libexpat/expat
RUN chmod +x build_new.sh && ./build_new.sh seed

# 3. FASelector
WORKDIR /tool
RUN bash FASelector.sh /exp/expat/source/libexpat/expat/lib/.libs/libexpat.a /exp/expat/source/libexpat/expat/tests/runtests /exp/expat/source/libexpat/expat/

# docker build -t fuzzbuilder:expat_v1 . -f v1.Dockerfile
# docker cp 9177b5c6a2a8:/tool/seeds.conf .