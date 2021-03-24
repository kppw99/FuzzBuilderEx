FROM fuzzbuilderex:boringssl_pre
LABEL maintainer="onsoim <onsoim@gmail.com>"

ENV CC=afl-gcc
ENV CXX=afl-g++
ENV PATH=$PATH:/tool/afl-2.52b
ENV AFL_PATH=/tool/afl-2.52b
ARG opt=production
ENV flag=$opt

COPY ./seed.conf /exp/boringssl/

# Generate seed file
WORKDIR /exp/boringssl/source/boringssl

RUN afl-clang -emit-llvm -DBORINGSSL_ALLOW_CXX_RUNTIME -DBORINGSSL_IMPLEMENTATION -DOPENSSL_NO_ASM -Ithird_party/googletest/include -Icrypto/../include -m32 -DBORINGSSL_UNSAFE_FUZZER_MODE -Werror -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wnewline-eof -fcolor-diagnostics -Wimplicit-fallthrough -Wmissing-prototypes -Wold-style-definition -Wstrict-prototypes -Wshadow -D_XOPEN_SOURCE=700 -c crypto/bytestring/cbs.c crypto/bio/bio_mem.c

RUN afl-clang++ -emit-llvm -DBORINGSSL_ALLOW_CXX_RUNTIME -DBORINGSSL_IMPLEMENTATION -DOPENSSL_NO_ASM -Ithird_party/googletest/include -Iinclude -m32 -DBORINGSSL_UNSAFE_FUZZER_MODE -Werror -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wnewline-eof -fcolor-diagnostics -Wimplicit-fallthrough -Wmissing-declarations -std=c++11 -Wmissing-prototypes -Wshadow -c ssl/ssl_asn1.cc

RUN /tool/fuzzbuilder seed /exp/boringssl/seed.conf

RUN afl-clang++ -DBORINGSSL_ALLOW_CXX_RUNTIME -DBORINGSSL_IMPLEMENTATION -DOPENSSL_NO_ASM -m32 -DBORINGSSL_UNSAFE_FUZZER_MODE -Werror -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wnewline-eof -fcolor-diagnostics -Wimplicit-fallthrough -Wmissing-declarations -std=c++11 -Wmissing-prototypes -Wshadow -c cbs.bc.mod.bc bio_mem.bc.mod.bc ssl_asn1.bc.mod.bc

RUN mv cbs.bc.mod.o cbs.c.o && mv bio_mem.bc.mod.o bio_mem.c.o && mv ssl_asn1.bc.mod.o ssl_asn1.cc.o

RUN ar r crypto/libcrypto.a cbs.c.o bio_mem.c.o && ar r ssl/libssl.a ssl_asn1.cc.o

# An error occurs when ninja command is executing
RUN rm ssl/ssl_test crypto/crypto_test && ninja && (ssl/ssl_test || set ?=0) && (crypto/crypto_test || set ?=0)
RUN mv /tmp/fuzzbuilder.collect . && python /tool/seed_maker.py fuzzbuilder.collect seed_fb
RUN mkdir -p /exp/boringssl/seed/fuzzbuilder && mv seed_fb /exp/boringssl/seed/fuzzbuilder/org

# Generate executable files
WORKDIR /exp/boringssl/source/boringssl/crypto
RUN if [ "$flag" = "true" ]; then \
		/tool/fuzzbuilder opt /exp/boringssl/CBS_crypto_opt.conf;\
		afl-clang++ -emit-llvm -DBORINGSSL_ALLOW_CXX_RUNTIME -DBORINGSSL_IMPLEMENTATION -DOPENSSL_NO_ASM -I../third_party/googletest/include -I../include -m32 -DBORINGSSL_UNSAFE_FUZZER_MODE -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wnewline-eof -fcolor-diagnostics -Wimplicit-fallthrough -Wmissing-declarations -std=c++11 -Wmissing-prototypes -Wunused-value -Wshadow -c ./test/gtest_main.cc ecdh_extra/ecdh_test_opt.cc evp/evp_test_opt.cc obj/obj_test.cc fipsmodule/ec/ec_test.cc fipsmodule/bn/bn_test_opt.cc bytestring/bytestring_test_opt.cc pkcs8/pkcs12_test_opt.cc digest_extra/digest_test_opt.cc pkcs7/pkcs7_test_opt.cc dh/dh_test.cc;\
        mv ecdh_test_opt.bc ecdh_test.bc;\
        mv evp_test_opt.bc evp_test.bc;\
        mv bn_test_opt.bc bn_test.bc;\
        mv bytestring_test_opt.bc bytestring_test.bc;\
        mv pkcs12_test_opt.bc pkcs12_test.bc;\
        mv digest_test_opt.bc digest_test.bc;\
        mv pkcs7_test_opt.bc pkcs7_test.bc;\
	else\
		afl-clang++ -emit-llvm -DBORINGSSL_ALLOW_CXX_RUNTIME -DBORINGSSL_IMPLEMENTATION -DOPENSSL_NO_ASM -I../third_party/googletest/include -I../include -m32 -DBORINGSSL_UNSAFE_FUZZER_MODE -Werror -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wnewline-eof -fcolor-diagnostics -Wimplicit-fallthrough -Wmissing-declarations -std=c++11 -Wmissing-prototypes -Wshadow -c ./test/gtest_main.cc ecdh_extra/ecdh_test.cc evp/evp_test.cc obj/obj_test.cc fipsmodule/ec/ec_test.cc fipsmodule/bn/bn_test.cc bytestring/bytestring_test.cc pkcs8/pkcs12_test.cc digest_extra/digest_test.cc pkcs7/pkcs7_test.cc dh/dh_test.cc;\
    fi
RUN /tool/fuzzbuilder exec /exp/boringssl/CBS.crypto.conf
RUN afl-clang++ -DBORINGSSL_ALLOW_CXX_RUNTIME -DBORINGSSL_IMPLEMENTATION -DOPENSSL_NO_ASM -I../third_party/googletest/include -I../include -m32 -DBORINGSSL_UNSAFE_FUZZER_MODE -Werror -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wnewline-eof -fcolor-diagnostics -Wimplicit-fallthrough -Wmissing-declarations -std=c++11 -Wmissing-prototypes -Wshadow -c ./pkcs12_test.bc.mod.bc ./pkcs7_test.bc.mod.bc ./evp_test.bc.mod.bc ./ecdh_test.bc.mod.bc ./ec_test.bc.mod.bc ./bn_test.bc.mod.bc ./bytestring_test.bc.mod.bc ./obj_test.bc.mod.bc ./gtest_main.bc.mod.bc ./digest_test.bc.mod.bc ./dh_test.bc.mod.bc
RUN AFL_USE_ASAN=1 afl-clang++ -m32 -g -Werror -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wnewline-eof -fcolor-diagnostics -Wimplicit-fallthrough -Wmissing-declarations -std=c++11 -fno-exceptions -fno-rtti -Wmissing-prototypes -Wshadow -m32 -g ./ec_test.bc.mod.o ./gtest_main.bc.mod.o ./bytestring_test.bc.mod.o ./bn_test.bc.mod.o ./obj_test.bc.mod.o ./ecdh_test.bc.mod.o ./digest_test.bc.mod.o ./pkcs12_test.bc.mod.o ./pkcs7_test.bc.mod.o ./evp_test.bc.mod.o ./dh_test.bc.mod.o -o crypto_test_CBS_fuzzer -rdynamic test/libtest_support_lib.a ../libboringssl_gtest.a libcrypto.a -lpthread

RUN if [ "$flag" = "true" ]; then \
        /tool/fuzzbuilder opt /exp/boringssl/BIO_crypto_opt.conf;\
        afl-clang++ -emit-llvm -DBORINGSSL_ALLOW_CXX_RUNTIME -DBORINGSSL_IMPLEMENTATION -DOPENSSL_NO_ASM -I../third_party/googletest/include -I../include -m32 -DBORINGSSL_UNSAFE_FUZZER_MODE -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wnewline-eof -fcolor-diagnostics -Wimplicit-fallthrough -Wmissing-declarations -std=c++11 -Wmissing-prototypes -Wunused-value -Wshadow -c ./test/gtest_main.cc bio/bio_test_opt.cc pem/pem_test_opt.cc pkcs7/pkcs7_test_opt.cc pkcs8/pkcs12_test_opt.cc ../crypto_test_data.cc x509/x509_test_opt.cc;\
        mv bio_test_opt.bc bio_test.bc;\
        mv pem_test_opt.bc pem_test.bc;\
        mv pkcs7_test_opt.bc pkcs7_test.bc;\
        mv pkcs12_test_opt.bc pkcs12_test.bc;\
        mv x509_test_opt.bc x509_test.bc;\
    else \
        afl-clang++ -emit-llvm -DBORINGSSL_ALLOW_CXX_RUNTIME -DBORINGSSL_IMPLEMENTATION -DOPENSSL_NO_ASM -I../third_party/googletest/include -I../include -m32 -DBORINGSSL_UNSAFE_FUZZER_MODE -Werror -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wnewline-eof -fcolor-diagnostics -Wimplicit-fallthrough -Wmissing-declarations -std=c++11 -Wmissing-prototypes -Wshadow -c ./test/gtest_main.cc bio/bio_test.cc pem/pem_test.cc pkcs7/pkcs7_test.cc pkcs8/pkcs12_test.cc ../crypto_test_data.cc x509/x509_test.cc;\
    fi

RUN /tool/fuzzbuilder exec /exp/boringssl/BIO.crypto.conf
RUN afl-clang++ -DBORINGSSL_ALLOW_CXX_RUNTIME -DBORINGSSL_IMPLEMENTATION -DOPENSSL_NO_ASM -I../third_party/googletest/include -I../include -m32 -DBORINGSSL_UNSAFE_FUZZER_MODE -Werror -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wnewline-eof -fcolor-diagnostics -Wimplicit-fallthrough -Wmissing-declarations -std=c++11 -Wmissing-prototypes -Wshadow -c gtest_main.bc.mod.bc bio_test.bc.mod.bc pem_test.bc.mod.bc pkcs7_test.bc.mod.bc pkcs12_test.bc.mod.bc x509_test.bc.mod.bc crypto_test_data.bc.mod.bc
RUN AFL_USE_ASAN=1 afl-clang++ -m32 -g -Werror -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wnewline-eof -fcolor-diagnostics -Wimplicit-fallthrough -Wmissing-declarations -std=c++11 -fno-exceptions -fno-rtti -Wmissing-prototypes -Wshadow -m32 -g gtest_main.bc.mod.o bio_test.bc.mod.o pem_test.bc.mod.o pkcs7_test.bc.mod.o pkcs12_test.bc.mod.o x509_test.bc.mod.o crypto_test_data.bc.mod.o -o crypto_test_BIO_fuzzer -rdynamic test/libtest_support_lib.a ../libboringssl_gtest.a libcrypto.a -lpthread

RUN mkdir -p /exp/boringssl/bin/fuzz/fuzzbuilder && mv /exp/boringssl/source/boringssl/crypto/*_fuzzer /exp/boringssl/bin/fuzz/fuzzbuilder

WORKDIR /exp/boringssl/source/boringssl/ssl
RUN if [ "$flag" = "true" ]; then \
        /tool/fuzzbuilder opt /exp/boringssl/BIO_ssl_opt.conf;\
        afl-clang++ -emit-llvm -DBORINGSSL_ALLOW_CXX_RUNTIME -DBORINGSSL_IMPLEMENTATION -DOPENSSL_NO_ASM -I../third_party/googletest/include -I../include -m32 -DBORINGSSL_UNSAFE_FUZZER_MODE -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wnewline-eof -fcolor-diagnostics -Wimplicit-fallthrough  -Wunused-value -Wmissing-declarations -std=c++11 -Wmissing-prototypes -Wshadow -c ../crypto/test/gtest_main.cc ssl_test_opt.cc;\
        mv ssl_test_opt.bc ssl_test.bc;\
    else \
        afl-clang++ -emit-llvm -DBORINGSSL_ALLOW_CXX_RUNTIME -DBORINGSSL_IMPLEMENTATION -DOPENSSL_NO_ASM -I../third_party/googletest/include -I../include -m32 -DBORINGSSL_UNSAFE_FUZZER_MODE -Werror -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wnewline-eof -fcolor-diagnostics -Wimplicit-fallthrough -Wmissing-declarations -std=c++11 -Wmissing-prototypes -Wshadow -c ../crypto/test/gtest_main.cc ssl_test.cc;\
    fi
RUN /tool/fuzzbuilder exec /exp/boringssl/BIO.ssl.conf
RUN afl-clang++ -DBORINGSSL_ALLOW_CXX_RUNTIME -DBORINGSSL_IMPLEMENTATION -DOPENSSL_NO_ASM -I../third_party/googletest/include -I../include -m32 -DBORINGSSL_UNSAFE_FUZZER_MODE -Werror -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wnewline-eof -fcolor-diagnostics -Wimplicit-fallthrough -Wmissing-declarations -std=c++11 -Wmissing-prototypes -Wshadow -c gtest_main.bc.mod.bc ssl_test.bc.mod.bc
RUN AFL_USE_ASAN=1 afl-clang++ -m32 -g -Werror -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wnewline-eof -fcolor-diagnostics -Wimplicit-fallthrough -Wmissing-declarations -std=c++11 -fno-exceptions -fno-rtti -Wmissing-prototypes -Wshadow -m32 -g gtest_main.bc.mod.o ssl_test.bc.mod.o -o ssl_test_BIO_fuzzer -rdynamic ../crypto/test/libtest_support_lib.a ../libboringssl_gtest.a libssl.a ../crypto/libcrypto.a -lpthread

RUN /tool/fuzzbuilder exec /exp/boringssl/SSL.ssl.conf
RUN afl-clang++ -DBORINGSSL_ALLOW_CXX_RUNTIME -DBORINGSSL_IMPLEMENTATION -DOPENSSL_NO_ASM -I../third_party/googletest/include -I../include -m32 -DBORINGSSL_UNSAFE_FUZZER_MODE -Werror -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wmissing-declarations -std=c++11 -Wmissing-prototypes -Wshadow -c gtest_main.bc.mod.bc ssl_test.bc.mod.bc
RUN AFL_USE_ASAN=1 afl-clang++ -m32 -g -Werror -Wformat=2 -Wsign-compare -Wmissing-field-initializers -Wwrite-strings -Wall -ggdb -fvisibility=hidden -fno-common -Wnewline-eof -fcolor-diagnostics -Wimplicit-fallthrough -Wmissing-declarations -std=c++11 -fno-exceptions -fno-rtti -Wmissing-prototypes -Wshadow -m32 -g gtest_main.bc.mod.o ssl_test.bc.mod.o -o ssl_test_SSL_fuzzer -rdynamic ../crypto/test/libtest_support_lib.a ../libboringssl_gtest.a libssl.a ../crypto/libcrypto.a -lpthread

RUN mv /exp/boringssl/source/boringssl/ssl/*_fuzzer /exp/boringssl/bin/fuzz/fuzzbuilder/

# Seed Optimization
WORKDIR /exp/boringssl/
RUN mkdir -p /exp/boringssl/seed/fuzzbuilder/opt
RUN afl-cmin -m 1024 -i seed/fuzzbuilder/org/BIO_new_mem_buf -o seed/fuzzbuilder/opt/crypto_test_BIO bin/fuzz/fuzzbuilder/crypto_test_BIO_fuzzer
RUN afl-cmin -m 1024 -i seed/fuzzbuilder/org/CBS_init -o seed/fuzzbuilder/opt/crypto_test_CBS bin/fuzz/fuzzbuilder/crypto_test_CBS_fuzzer
RUN afl-cmin -m 1024 -i seed/fuzzbuilder/org/BIO_new_mem_buf -o seed/fuzzbuilder/opt/ssl_test_BIO bin/fuzz/fuzzbuilder/ssl_test_BIO_fuzzer
RUN afl-cmin -m 1024 -i seed/fuzzbuilder/org/SSL_SESSION_from_bytes -o seed/fuzzbuilder/opt/ssl_test_SSL bin/fuzz/fuzzbuilder/ssl_test_SSL_fuzzer

WORKDIR /

