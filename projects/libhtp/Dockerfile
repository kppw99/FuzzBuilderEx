FROM fuzzbuilderex:libhtp_pre
MAINTAINER Sanghoon(Kevin) Jeon <kppw99@gmail.com>

# Set environment variable of afl-gcc, afl-g++
ENV PATH=$PATH:/tool/afl-2.52b
ENV AFL_PATH=/tool/afl-2.52b
ENV srcdir=/exp/libhtp/source/libhtp/test/files/
ARG opt=production
ENV opt_flag=$opt

# Generate seed file
WORKDIR /exp/libhtp/source/libhtp
RUN afl-clang -emit-llvm -DHAVE_CONFIG_H -I. -I.. -O2 -I.. -I../htp -D_GNU_SOURCE -g -Wall -Wextra -std=gnu99 -pedantic -Wextra -Wno-missing-field-initializers -Wshadow -Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes -Wno-unused-parameter -m32 -O2 -Wstrict-overflow=1 -fstack-protector -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -fPIC -MT htp_multipart.lo -MD -MP -MF htp/.deps/htp_multipart.Tpo -c htp/htp_multipart.c
RUN /tool/fuzzbuilder seed /exp/libhtp/seed.conf
RUN afl-clang -DHAVE_CONFIG_H -I. -I.. -DHAVE_EXPAT_CONFIG_H -m32 -g -Wall -Wmissing-prototypes -Wstrict-prototypes -fexceptions -fno-strict-aliasing -c htp_multipart.bc.mod.bc -fPIC -DPIC -o htp_multipart.o
RUN ar cr htp/.libs/libhtp.a ./htp_multipart.o
WORKDIR /exp/libhtp/source/libhtp/test
RUN make test
RUN mv /tmp/fuzzbuilder.collect .
RUN python /tool/seed_maker.py fuzzbuilder.collect seed_fb
RUN mkdir -p /exp/libhtp/seed/fuzzbuilder
RUN mv seed_fb /exp/libhtp/seed/fuzzbuilder/org

# Generate executable files
WORKDIR /exp/libhtp/source/libhtp
RUN make clean && make
WORKDIR /exp/libhtp/source/libhtp/test
RUN if [ "$opt_flag" = "true" ]; then \
		/tool/fuzzbuilder opt /exp/libhtp/opt.conf;\
		afl-clang++ -emit-llvm -DHAVE_CONFIG_H -I. -I..  -I.. -I../htp -Wno-write-strings -DGTEST_USE_OWN_TR1_TUPLE=1 -D_GNU_SOURCE -g -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare -O2  -m32 -MT test_main.o -MD -MP -MF $depbase.Tpo -c gtest/gtest_main.cc gtest/gtest-all.cc test_main.cpp test_utils_opt.cpp test_multipart.cpp test_bench.cpp test_bstr_opt.cpp test_hybrid.cpp test_gunzip.cpp;\
		mv test_utils_opt.bc test_utils.bc;\
		mv test_bstr_opt.bc test_bstr.bc;\
	else \
		afl-clang++ -emit-llvm -DHAVE_CONFIG_H -I. -I..  -I.. -I../htp -Wno-write-strings -DGTEST_USE_OWN_TR1_TUPLE=1 -D_GNU_SOURCE -g -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare -O2  -m32 -MT test_main.o -MD -MP -MF $depbase.Tpo -c gtest/gtest_main.cc gtest/gtest-all.cc test_main.cpp test_utils.cpp test_multipart.cpp test_bench.cpp test_bstr.cpp test_hybrid.cpp test_gunzip.cpp;\
	fi
RUN afl-clang -emit-llvm -DHAVE_CONFIG_H -I. -I..  -I.. -I../htp -Wno-write-strings -DGTEST_USE_OWN_TR1_TUPLE=1 -D_GNU_SOURCE -g -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare -O2 -D_GNU_SOURCE -g -Wall -Wextra -std=gnu99 -pedantic -Wextra -Wno-missing-field-initializers -Wshadow -Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes -Wno-unused-parameter -m32 -O2 -Wstrict-overflow=1 -fstack-protector -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -fPIC -MT test.o -MD -MP -MF $depbase.Tpo -c test.c
RUN /tool/fuzzbuilder exec /exp/libhtp/htp_mpartp_parse.conf
RUN afl-clang++ -DHAVE_CONFIG_H -I. -I..  -I.. -I../htp -Wno-write-strings -DGTEST_USE_OWN_TR1_TUPLE=1 -D_GNU_SOURCE -g -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare -O2 -m32 -c -o test_main.o test_main.bc
RUN afl-clang++ -DHAVE_CONFIG_H -I. -I..  -I.. -I../htp -Wno-write-strings -DGTEST_USE_OWN_TR1_TUPLE=1 -D_GNU_SOURCE -g -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare -O2 -m32 -c -o test_utils.o test_utils.bc
RUN afl-clang++ -DHAVE_CONFIG_H -I. -I..  -I.. -I../htp -Wno-write-strings -DGTEST_USE_OWN_TR1_TUPLE=1 -D_GNU_SOURCE -g -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare -O2 -m32 -c -o test_multipart.o test_multipart.bc.mod.bc
RUN afl-clang++ -DHAVE_CONFIG_H -I. -I.. -I.. -I../htp -Wno-write-strings -DGTEST_USE_OWN_TR1_TUPLE=1 -D_GNU_SOURCE -g -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare -O2  -m32 -c -o test_bench.o test_bench.bc
RUN afl-clang++ -DHAVE_CONFIG_H -I. -I..  -I.. -I../htp -Wno-write-strings -DGTEST_USE_OWN_TR1_TUPLE=1 -D_GNU_SOURCE -g -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare -O2 -m32 -c -o test_hybrid.o test_hybrid.bc
RUN afl-clang++ -DHAVE_CONFIG_H -I. -I.. -I.. -I../htp -Wno-write-strings -DGTEST_USE_OWN_TR1_TUPLE=1 -D_GNU_SOURCE -g -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare -O2 -m32 -c -o test_bstr.o test_bstr.bc
RUN afl-clang++ -DHAVE_CONFIG_H -I. -I..  -I.. -I../htp -Wno-write-strings -DGTEST_USE_OWN_TR1_TUPLE=1 -D_GNU_SOURCE -g -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare -O2 -m32 -c -o test_gunzip.o test_gunzip.bc
RUN afl-clang -DHAVE_CONFIG_H -I. -I.. -I.. -I../htp -Wno-write-strings -DGTEST_USE_OWN_TR1_TUPLE=1 -D_GNU_SOURCE -g -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare -O2 -D_GNU_SOURCE -g -Wall -Wextra -std=gnu99 -pedantic -Wextra -Wno-missing-field-initializers -Wshadow -Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes -Wno-unused-parameter -m32 -O2 -Wstrict-overflow=1 -fstack-protector -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -fPIC -c -o test.o test.bc
RUN afl-clang++ -DHAVE_CONFIG_H -I. -I..  -I.. -I../htp -Wno-write-strings -DGTEST_USE_OWN_TR1_TUPLE=1 -D_GNU_SOURCE -g -Wall -Wextra -Wno-sign-compare -O2 -m32 -o gtest/gtest_main.o -c gtest_main.bc.mod.bc
RUN afl-clang++ -DHAVE_CONFIG_H -I. -I..  -I.. -I../htp -Wno-write-strings -DGTEST_USE_OWN_TR1_TUPLE=1 -D_GNU_SOURCE -g -Wall -Wextra -Wno-sign-compare -O2 -m32 -o gtest/gtest-all.o -c gtest-all.bc.mod.bc
RUN ar cr libgtest.a gtest/gtest-all.o gtest/gtest_main.o
RUN afl-clang++ -m32 -o htp_multipart_fuzzer test_bstr.o test_gunzip.o test_hybrid.o test_main.o test_multipart.o test.o test_utils.o test_bench.o gtest/gtest_main.o libgtest.a -lpthread ../htp/.libs/libhtp.a -lz
RUN mkdir -p /exp/libhtp/bin/fuzz/fuzzbuilder/
RUN cp -rf ./htp_multipart_fuzzer /exp/libhtp/bin/fuzz/fuzzbuilder/

# Seed Optimization
WORKDIR /exp/libhtp/
RUN mkdir -p /exp/libhtp/seed/fuzzbuilder/opt
RUN afl-cmin -m 1024 -i seed/fuzzbuilder/org/htp_mpartp_parse -o seed/fuzzbuilder/opt/htp_mpartp_parse bin/fuzz/fuzzbuilder/htp_multipart_fuzzer

WORKDIR /
