FROM fuzzbuilderex:base
LABEL maintainer="KDY <ehddud758@gmail.com>"


# [mpc]
# 1. Prepare source codes & project build
COPY . /exp/mpc

RUN mkdir -p /exp/mpc/source && cd /exp/mpc/source && git clone https://github.com/orangeduck/mpc.git && cd mpc && cp ../../build_new.sh .

# 2. FuzzBuilder (seed)
ENV CFLAGS=-m32
RUN cd /exp/mpc/source/mpc && rm -f $(find . -name "*.bc") && bash ./build_new.sh seed && /tool/afl-2.52b/afl-clang -emit-llvm -I. -I./tests -I./build -fvisibility=hidden -m32 -Qunused-arguments -g0 -Os -fPIC -DPIC -c mpc.c && /tool/fuzzbuilder seed /exp/mpc/seed.conf && /tool/afl-2.52b/afl-clang -I. -I./tests -I./build -fvisibility=hidden -m32 -Qunused-arguments -g0 -Os -fPIC -DPIC -c mpc.bc.mod.bc -o mpc.o && ar r build/libmpc.a mpc.o && cd build && rm -f $(find ./* -maxdepth 0 -executable -type f -name "test-*") && cd ../ && make check && cd build && mv /tmp/fuzzbuilder.collect . && python /tool/seed_maker.py fuzzbuilder.collect seed_fb && mkdir -p /exp/mpc/seed/fuzzbuilder && mv /exp/mpc/source/mpc/build/seed_fb /exp/mpc/seed/fuzzbuilder/org

# 3. FuzzBuilder (exec)
RUN cd /exp/mpc/source/mpc/tests && /tool/afl-2.52b/afl-clang -emit-llvm -I.. -I. -I../build -fvisibility=hidden -m32 -g -Wall -pthread -c test.c regex.c core.c grammar.c combinators.c  ptest.c && /tool/fuzzbuilder exec /exp/mpc/mpca_lang.conf && /tool/afl-2.52b/afl-clang -I.. -I. -I../build -m32 -g -Wall -pthread -c test.bc.mod.bc regex.bc.mod.bc core.bc.mod.bc grammar.bc.mod.bc  combinators.bc.mod.bc ptest.bc.mod.bc && AFL_USE_ASAN=1 /tool/afl-2.52b/afl-clang -m32 -Wall -pthread -o mpca_lang test.bc.mod.o regex.bc.mod.o core.bc.mod.o grammar.bc.mod.o combinators.bc.mod.o ptest.bc.mod.o ../build/libmpc.a && /tool/fuzzbuilder exec /exp/mpc/mpc_test_pass.conf && /tool/afl-2.52b/afl-clang -I.. -I. -I../build -m32 -g -Wall -pthread -c test.bc.mod.bc regex.bc.mod.bc core.bc.mod.bc grammar.bc.mod.bc combinators.bc.mod.bc ptest.bc.mod.bc && AFL_USE_ASAN=1 /tool/afl-2.52b/afl-clang -m32 -Wall -pthread -o mpc_test_pass test.bc.mod.o regex.bc.mod.o core.bc.mod.o grammar.bc.mod.o combinators.bc.mod.o ptest.bc.mod.o ../build/libmpc.a && mkdir -p /exp/mpc/bin/fuzz/fuzzbuilder && mv /exp/mpc/source/mpc/tests/mpca_lang /exp/mpc/bin/fuzz/fuzzbuilder && mv /exp/mpc/source/mpc/tests/mpc_test_pass /exp/mpc/bin/fuzz/fuzzbuilder

# 4. Seed Optimization
RUN cd /exp/mpc && mkdir -p /exp/mpc/seed/fuzzbuilder/opt && /tool/afl-2.52b/afl-cmin -m 1024 -i /exp/mpc/seed/fuzzbuilder/org/mpca_lang -o /exp/mpc/seed/fuzzbuilder/opt/mpca_lang /exp/mpc/bin/fuzz/fuzzbuilder/mpca_lang @@ && /tool/afl-2.52b/afl-cmin -m 1024 -i /exp/mpc/seed/fuzzbuilder/org/mpc_test_pass -o /exp/mpc/seed/fuzzbuilder/opt/mpc_test_pass /exp/mpc/bin/fuzz/fuzzbuilder/mpc_test_pass @@


