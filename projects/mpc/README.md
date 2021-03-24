## Usages
### 1. Select FA
```
# You first build a target library to use the FASelector.
$ ./FASelector.py
```
### 2. Make Seed Corpus
```
$ docker build -t fuzzbuilderex:expat_pre . -f pre.Dockerfile
```
### 3. Create Fuzzing Executables
```
$ docker build -t fuzzbuilderex:expat . -f Dockerfile
```
### 4. Run container images for fuzzing
```
$ docker run -it --priviledge fuzzbuilderex:expat /bin/bash
```
