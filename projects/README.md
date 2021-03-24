## How to build a target library using dockerfile
### 1. Prerequisite
- Preparation for seed configuration files that created by the FASelector
```
$ ./FASelector.py [target library] [test binary] [source code directory]
```
- Preparation for optimization configuration files (Option)
- Preparation for exec configuration files (recommend creating per FA)

### 2. Build Target Libary
- Execute *pre.Dockerfile*
```
# To build the boringssl (example)
$ docker build -t fuzzbuilderex:boringssl_pre . -f pre.Dockerfile

# To check a container for pre.Docker file
$ docker run -it --privileged fuzzbuilderex:boringssl_pre /bin/bash
```

### 3. Generate seed corpus and fuzzing executables
- Execute *Dockerfile*
```
# To generate seed corpus and fuzzing executables of boringssl (example)
$ docker build -t fuzzbuilderex:boringssl . -f Dockerfile

# To check a container for Dockerfile
$ docker run -it --privileged fuzzbuilderex:boringssl /bin/bash
```

### 4. Fuzzing
- Execute the docker container for target libary
```
$ docker run -it --privileged fuzzbuilderex:boringssl /bin/bash
```
- Execute *AFL_Fuzzer*
```
# Recommend using many options appropriate to the target library
$ afl-fuzz -i [seed directory] -o [output directory] [fuzzing executable]
```
