# FuzzBuilderEx: Automated Building Seed Corpus and Fuzzing Executables using Test Framework
![FuzzBuilderEx](https://user-images.githubusercontent.com/48042609/112240130-16745e80-8c8b-11eb-9d7f-95436646cfec.png)

## Abstract
![abstract](https://user-images.githubusercontent.com/48042609/112237303-bcbd6580-8c85-11eb-9de2-a077e1992660.png)

## Prerequisite
- **OS:** Ubuntu (18.04 LTS)
- **Container:** Docker (19.03.6)


## Description of Directory
*(D: directory / F: file)
- **[D] source:** source code of fuzzbuilderex
- **[D] projects:** target librares
- **[F] Dockerfile:** dockerfile for base environment such as os, LLVM, AFL, utils
- **[F] docker-compose.yml:** docker compose file for fuzzbuilderex, target libraries
- **[F] runner.sh:** script file to build target library
```
$ ./runner.sh [project name]
```

## About
This program is authored and maintained by **Sanghoon(Kevin) Jeon**, **Min Soo Ryu**, and **Dong Young Kim**.
> Email: kppw99@gmail.com, onsoim@gmail.com, ehddud758@gmail.com

> GitHub[@FuzzBuilderEx](https://github.com/kppw99/FuzzBuilderEx)
