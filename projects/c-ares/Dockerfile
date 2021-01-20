FROM c-ares_pre:latest
MAINTAINER Sanghoon(Kevin) Jeon <kppw99@gmail.com>

# Set environment variable of afl-gcc, afl-g++
ENV PATH=$PATH:/tool/afl-2.52b
ENV AFL_PATH=/tool/afl-2.52b

# Generate seed file
WORKDIR /exp/c-ares/source/c-ares
RUN afl-clang -emit-llvm -DHAVE_CONFIG_H -I. -I. -DCARES_BUILDING_LIBRARY -DCARES_SYMBOL_HIDING -fvisibility=hidden -m32 -Qunused-arguments -g0 -Os -fPIC -DPIC -c ares_create_query.c ares_parse_a_reply.c ares_parse_aaaa_reply.c ares_parse_mx_reply.c ares_parse_naptr_reply.c ares_parse_ns_reply.c ares_parse_ptr_reply.c ares_parse_soa_reply.c ares_parse_srv_reply.c ares_parse_txt_reply.c
RUN /tool/fuzzbuilder seed /exp/c-ares/seed.conf
RUN afl-clang -DHAVE_CONFIG_H -I. -I. -DCARES_BUILDING_LIBRARY -DCARES_SYMBOL_HIDING -fvisibility=hidden -m32 -Qunused-arguments -g0 -Os -fPIC -DPIC -c ares_create_query.bc.mod.bc ares_parse_a_reply.bc.mod.bc ares_parse_aaaa_reply.bc.mod.bc ares_parse_mx_reply.bc.mod.bc ares_parse_naptr_reply.bc.mod.bc ares_parse_ns_reply.bc.mod.bc ares_parse_ptr_reply.bc.mod.bc ares_parse_soa_reply.bc.mod.bc ares_parse_srv_reply.bc.mod.bc ares_parse_txt_reply.bc.mod.bc
RUN mv ares_create_query.bc.mod.o libcares_la-ares_create_query.o && mv ares_parse_a_reply.bc.mod.o libcares_la-ares_parse_a_reply.o && mv ares_parse_aaaa_reply.bc.mod.o libcares_la-ares_parse_aaaa_reply.o && mv ares_parse_mx_reply.bc.mod.o libcares_la-ares_parse_mx_reply.o && mv ares_parse_naptr_reply.bc.mod.o libcares_la-ares_parse_naptr_reply.o && mv ares_parse_ns_reply.bc.mod.o libcares_la-ares_parse_ns_reply.o && mv ares_parse_ptr_reply.bc.mod.o libcares_la-ares_parse_ptr_reply.o && mv ares_parse_soa_reply.bc.mod.o libcares_la-ares_parse_soa_reply.o && mv ares_parse_srv_reply.bc.mod.o libcares_la-ares_parse_srv_reply.o && mv ares_parse_txt_reply.bc.mod.o libcares_la-ares_parse_txt_reply.o
RUN ar r .libs/libcares.a libcares_la-ares_create_query.o libcares_la-ares_parse*.o
WORKDIR /exp/c-ares/source/c-ares/test
RUN rm arestest && make && (./arestest || set ?=0)
RUN mv /tmp/fuzzbuilder.collect . && python /tool/seed_maker.py fuzzbuilder.collect seed_fb
RUN mkdir -p /exp/c-ares/seed/fuzzbuilder && mv /exp/c-ares/source/c-ares/test/seed_fb /exp/c-ares/seed/fuzzbuilder/org

# Generate executable files
WORKDIR /exp/c-ares/source/c-ares/test
RUN afl-clang++ -emit-llvm -DHAVE_CONFIG_H -I. -I.. -isystem gmock-1.8.0 -m32 -g -Wall -pthread -c ares-test-main.cc ares-test-misc.cc ares-test.cc ares-test-internal.cc dns-proto.cc ares-test-parse-a.cc ares-test-parse.cc ares-test-parse-aaaa.cc ares-test-parse-ptr.cc ares-test-parse-ns.cc ares-test-parse-srv.cc ares-test-parse-txt.cc ares-test-parse-soa.cc ares-test-parse-naptr.cc ares-test-parse-mx.cc
RUN /tool/fuzzbuilder exec /exp/c-ares/ares_create_query.conf
RUN afl-clang++ -DHAVE_CONFIG_H -I. -I.. -isystem gmock-1.8.0 -m32 -g -Wall -pthread -c ares-test-main.bc.mod.bc ares-test-misc.bc.mod.bc ares-test.bc.mod.bc ares-test-internal.bc.mod.bc dns-proto.bc.mod.bc
RUN AFL_USE_ASAN=1 afl-clang++ -m32 -Wall -pthread -o ares_create_query_fuzzer ares-test-main.bc.mod.o ares-test-misc.bc.mod.o ares-test.bc.mod.o ares-test-internal.bc.mod.o dns-proto.bc.mod.o .libs/libgmock.a ../.libs/libcares.a
RUN /tool/fuzzbuilder exec /exp/c-ares/ares_parse_reply.conf
RUN afl-clang++ -DHAVE_CONFIG_H -I. -I.. -isystem gmock-1.8.0 -m32 -g -Wall -pthread -c ares-test-main.bc.mod.bc ares-test.bc.mod.bc ares-test-internal.bc.mod.bc dns-proto.bc.mod.bc ares-test-parse-aaaa.bc.mod.bc ares-test-parse-a.bc.mod.bc ares-test-parse.bc.mod.bc ares-test-parse-mx.bc.mod.bc ares-test-parse-naptr.bc.mod.bc ares-test-parse-ns.bc.mod.bc ares-test-parse-ptr.bc.mod.bc ares-test-parse-soa.bc.mod.bc ares-test-parse-srv.bc.mod.bc ares-test-parse-txt.bc.mod.bc
RUN AFL_USE_ASAN=1 afl-clang++ -m32 -g -Wall -pthread -o ares_parse_reply_fuzzer ares-test-main.bc.mod.o ares-test.bc.mod.o ares-test-internal.bc.mod.o dns-proto.bc.mod.o ares-test-parse-aaaa.bc.mod.o ares-test-parse-a.bc.mod.o ares-test-parse.bc.mod.o ares-test-parse-mx.bc.mod.o ares-test-parse-naptr.bc.mod.o ares-test-parse-ns.bc.mod.o ares-test-parse-ptr.bc.mod.o ares-test-parse-soa.bc.mod.o ares-test-parse-srv.bc.mod.o ares-test-parse-txt.bc.mod.o .libs/libgmock.a ../.libs/libcares.a
RUN mkdir -p /exp/c-ares/bin/fuzz/fuzzbuilder && mv /exp/c-ares/source/c-ares/test/*_fuzzer /exp/c-ares/bin/fuzz/fuzzbuilder

# Seed Optimization
RUN mkdir -p /exp/c-ares/seed/fuzzbuilder/org/ares_parse_reply && mv /exp/c-ares/seed/fuzzbuilder/org/ares_parse_*_reply/* /exp/c-ares/seed/fuzzbuilder/org/ares_parse_reply
RUN rm -rf /exp/c-ares/seed/fuzzbuilder/org/ares_parse_*_reply && mkdir -p /exp/c-ares/seed/eval/ares_create_query 
WORKDIR /exp/c-ares
RUN afl-cmin -m 1024 -i /exp/c-ares/seed/fuzzbuilder/org/ares_create_query -o /exp/c-ares/seed/fuzzbuilder/opt/ares_create_query /exp/c-ares/bin/fuzz/fuzzbuilder/ares_create_query_fuzzer @@
RUN afl-cmin -m 1024 -i /exp/c-ares/seed/fuzzbuilder/org/ares_parse_reply -o /exp/c-ares/seed/fuzzbuilder/opt/ares_parse_reply /exp/c-ares/bin/fuzz/fuzzbuilder/ares_parse_reply_fuzzer @@
WORKDIR /
