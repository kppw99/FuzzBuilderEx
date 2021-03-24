FROM fuzzbuilderex:json-c_pre
MAINTAINER Sanghoon(Kevin) Jeon <kppw99@gmail.com>

# Set environment variable of afl-gcc, afl-g++
ENV PATH=$PATH:/tool/afl-2.52b
ENV AFL_PATH=/tool/afl-2.52b

# Generate seed file
WORKDIR /exp/json-c/source/json-c/build
RUN afl-clang -emit-llvm -I.. -I. -m32 -g -D_REENTRANT -c ../json_tokener.c
RUN /tool/fuzzbuilder seed /exp/json-c/seed.conf
RUN afl-clang -I.. -I. -m32 -g -D_REENTRANT -o CMakeFiles/json-c.dir/json_tokener.c.o -c json_tokener.bc.mod.bc
RUN ar cr libjson-c.a CMakeFiles/json-c.dir/json_tokener.c.o
RUN ranlib libjson-c.a
WORKDIR /exp/json-c/source/json-c/build/tests
RUN afl-clang -m32 -g -rdynamic CMakeFiles/test_parse.dir/test_parse.c.o -o json_tokener_seedgen ../libjson-c.a
RUN ./json_tokener_seedgen
RUN mv /tmp/fuzzbuilder.collect .
RUN python /tool/seed_maker.py fuzzbuilder.collect seed_fb
RUN mkdir -p /exp/json-c/seed/fuzzbuilder
RUN mv seed_fb /exp/json-c/seed/fuzzbuilder/org

# Generate executable files
WORKDIR /exp/json-c/source/json-c/tests/
RUN afl-clang -emit-llvm -fno-inline-functions -I./PUBLIC -I. -I.. -I../build  -m32 -g -c ./test_parse.c
RUN /tool/fuzzbuilder exec /exp/json-c/json_tokner_parse.conf
RUN afl-clang -I./PUBLIC -I.. -I. -I../build  -m32 -g -o ../build/tests/CMakeFiles/test_parse.dir/test_parse.c.o -c test_parse.bc.mod.bc
RUN afl-clang -m32 -g  -rdynamic ../build/tests/CMakeFiles/test_parse.dir/test_parse.c.o  -o json_tokener_parse_fuzzer ../build/libjson-c.a
RUN mkdir -p /exp/json-c/bin/fuzz/fuzzbuilder/
RUN cp -rf ./json_tokener_parse_fuzzer /exp/json-c/bin/fuzz/fuzzbuilder/

# Seed Optimization
WORKDIR /exp/json-c/
RUN mkdir -p seed/fuzzbuilder/opt
RUN afl-cmin -m 1024 -i seed/fuzzbuilder/org/json_tokener_parse -o seed/fuzzbuilder/opt/json_tokener_parse bin/fuzz/fuzzbuilder/json_tokener_parse_fuzzer

WORKDIR /
