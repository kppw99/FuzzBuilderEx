FROM fuzzbuilder:v2 
LABEL maintainer="KDY <ehddud758@gmail.com>"

# [ http-parser ]
# 1. Prepare source codes & project build
RUN mkdir -p /exp/http-parser/source && cd /exp/http-parser/source && git clone https://github.com/nodejs/http-parser.git && cd http-parser && cp ../../build_new.sh . && bash ./build_new.sh seed

# 2. Fuzzbuilder (seed)
RUN cd /exp/http-parser/source/http-parser/ && /tool/afl-2.52b/afl-clang -emit-llvm -I. -m32 -c ./http_parser.c -fPIC -DPIC && /tool/fuzzbuilder seed /exp/http-parser/seed.conf && /tool/afl-2.52b/afl-clang -I. -m32 -c ./http_parser.bc.mod.bc -fPIC -DPIC -o http_parser.o && cd ./contrib && gcc -I.. -m32 -o url_parser url_parser.c ../http_parser.o && ./url_parser get http://www.google.com && mv /tmp/fuzzbuilder.collect . && python /tool/seed_maker.py fuzzbuilder.collect seed_fb && mkdir -p /exp/http-parser/seed/fuzzbuilder && mv /exp/http-parser/source/http-parser/contrib/seed_fb /exp/http-parser/seed/fuzzbuilder/org

# parsertrace << don`t have sample http packet
# Therefore exclude from test

# 3. Fuzzbuilder (exec)
RUN cd /exp/http-parser/source/http-parser && bash build_new.sh && rm http_parser.o && gcc -m32 -c http_parser.c && cd /exp/http-parser/source/http-parser/contrib && /tool/afl-2.52b/afl-clang -emit-llvm -I.. -m32 -c ./url_parser.c && /tool/fuzzbuilder exec /exp/http-parser/http_parser_parser_url.conf && AFL_USE_ASAN=1 /tool/afl-2.52b/afl-clang -I.. -m32 -o url_parser url_parser.bc.mod.bc ../http_parser.o && mkdir -p /exp/http-parser/bin/fuzz/fuzzbuilder && mv /exp/http-parser/source/http-parser/contrib/url_parser /exp/http-parser/bin/fuzz/fuzzbuilder


# 4. Seed Optimization
RUN cd /exp/http-parser && mkdir -p /exp/http-parser/seed/fuzzbuilder/opt && /tool/afl-2.52b/afl-cmin -m 1024 -i /exp/http-parser/seed/fuzzbuilder/org/http_parser_parse_url -o /exp/http-parser/seed/fuzzbuilder/opt/http_parser_parse_url /exp/http-parser/bin/fuzz/fuzzbuilder/url_parser
#/tool/afl-2.52b/afl-cmin -m 1024 -i /exp/http-parser/seed/fuzzbuilder/org/seed_fb/http_parser_execute -o /exp/http-parser/seed/fuzzbuilder/opt/http_parser_execute /exp/http-parser/bin/fuzz/fuzzbuilder/parsertrace

