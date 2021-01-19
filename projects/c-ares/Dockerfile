FROM fuzzbuilder:test
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
# Generate seed file
WORKDIR /exp/c-ares/source/c-ares
RUN chmod 744 ./build_new.sh
RUN rm -f $(find . -name ".bc") && ./build_new.sh seed
RUN afl-clang -emit-llvm -DHAVE_CONFIG_H -I. -I. -DCARES_BUILDING_LIBRARY -DCARES_SYMBOL_HIDING -fvisibility=hidden -m32 -Qunused-arguments -g0 -Os -fPIC -DPIC -c ares_create_query.c ares_parse_a_reply.c ares_parse_aaaa_reply.c ares_parse_mx_reply.c ares_parse_naptr_reply.c ares_parse_ns_reply.c ares_parse_ptr_reply.c ares_parse_soa_reply.c ares_parse_srv_reply.c ares_parse_txt_reply.c
RUN /tool/fuzzbuilder seed /exp/c-ares/seed.conf
RUN afl-clang -DHAVE_CONFIG_H -I. -I. -DCARES_BUILDING_LIBRARY -DCARES_SYMBOL_HIDING -fvisibility=hidden -m32 -Qunused-arguments -g0 -Os -fPIC -DPIC -c ares_create_query.bc.mod.bc ares_parse_a_reply.bc.mod.bc ares_parse_aaaa_reply.bc.mod.bc ares_parse_mx_reply.bc.mod.bc ares_parse_naptr_reply.bc.mod.bc ares_parse_ns_reply.bc.mod.bc ares_parse_ptr_reply.bc.mod.bc ares_parse_soa_reply.bc.mod.bc ares_parse_srv_reply.bc.mod.bc ares_parse_txt_reply.bc.mod.bc
#RUN mv ares_create_query.bc.mod.o libcares_la-ares_create_query.o && mv ares_parse_a_reply.bc.mod.o libcares_la-ares_parse_a_reply.o && mv ares_parse_aaaa_reply.bc.mod.o libcares_la-ares_parse_aaaa_reply.o && mv ares_parse_mx_reply.bc.mod.o libcares_la-ares_parse_mx_reply.o && mv ares_parse_naptr_reply.bc.mod.o libcares_la-ares_parse_naptr_reply.o && mv ares_parse_ns_reply.bc.mod.o libcares_la-ares_parse_ns_reply.o && mv ares_parse_ptr_reply.bc.mod.o libcares_la-ares_parse_ptr_reply.o && mv ares_parse_soa_reply.bc.mod.o libcares_la-ares_parse_soa_reply.o && mv ares_parse_srv_reply.bc.mod.o libcares_la-ares_parse_srv_reply.o && mv ares_parse_txt_reply.bc.mod.o libcares_la-ares_parse_txt_reply.o
#RUN ar r .libs/libcares.a libcares_la-ares_create_query.o libcares_la-ares_parse*.o
#WORKDIR /exp/c-ares/source/c-ares/test
#RUN rm arestest && make && (./arestest || set ?=0)
#RUN mv /tmp/fuzzbuilder.collect . && python /tool/seed_maker.py fuzzbuilder.collect seed_fb
#RUN mkdir -p /exp/c-ares/seed/fuzzbuilder && mv /exp/c-ares/source/c-ares/test/seed_fb /exp/c-ares/seed/fuzzbuilder/org
WORKDIR /
