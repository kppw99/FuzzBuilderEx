[![DOI](https://zenodo.org/badge/310195829.svg)](https://zenodo.org/badge/latestdoi/310195829)
# FuzzBuilderEx: Automated Building Seed Corpus and Fuzzing Executables using Test Framework
![FuzzBuilderEx](https://user-images.githubusercontent.com/48042609/112240130-16745e80-8c8b-11eb-9d7f-95436646cfec.png)

## Abstract
![abstract](https://user-images.githubusercontent.com/48042609/112237303-bcbd6580-8c85-11eb-9de2-a077e1992660.png)

## Prerequisite
- **OS:** ubuntu (18.04 LTS)
- **Container:** docker (19.03.6)

## Description of Directory
*(D: directory / F: file)*
- **[D] source:** source code of fuzzbuilderex
- **[D] projects:** target librares
- **[F] Dockerfile:** dockerfile for base environment such as os, LLVM, AFL, utils
- **[F] docker-compose.yml:** docker compose file for fuzzbuilderex, target libraries
- **[F] runner.sh:** script file to build target library

## How to use FuzzBuilderEx
```
# To build target library with FuzzBuilderEx (using docker)
$ ./runner.sh [target library name]

# To make seed
$ ./fuzzbuilderex seed [configuration file]

# To optimization
$ ./fuzzbuilderex opt [configuration file]

# To create fuzzing executables
$ ./fuzzbuilderex exec [configuration file]
```

## Publications
```
FuzzBuilderEx: Automated Building Seed Corpus and Fuzzing Executables using Test Framework

@article{
TBD
}
```

## About
This program is authored and maintained by **Sanghoon(Kevin) Jeon**, **Minsoo Ryu**, and **Dongyoung Kim**.
> Email: kppw99@gmail.com, onsoim@gmail.com, ehddud758@gmail.com

> GitHub[@FuzzBuilderEx](https://github.com/kppw99/FuzzBuilderEx)
