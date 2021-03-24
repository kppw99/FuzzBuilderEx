# FuzzBuilderEx: Automated Building Seed Corpus and Fuzzing Executables using Test Framework
![FuzzBuilderEx](https://user-images.githubusercontent.com/48042609/112236234-6b13db80-8c83-11eb-84e5-049404d585bb.png)

## Introduction
FuzzBuilder is a tool for generating an executable automatically for library fuzzing by using a unit test. Further, FuzzBuilder can generate seed files to fuzz a specific library API function by analyzing a unit test. Generated executables are compatible with various greybox fuzzers like AFL. Using these features, FuzzBuilder can help to apply greybox fuzzing widely on a development process. We will provide source code of FuzzBuilder with detailed information about how to build and how to use. Briefly, FuzzBuilder requires LLVM-6.0, clang-6.0(exactly 6.0.1) packages to be built. FuzzBuilder has beentested on the Linux Debian 4.9.0-8-amd64. Further, the current version of FuzzBuilder can take only 32-bit bitcode files. It is difficult to set up the same experiment environment of this paper. Thus, we will prepare Dockerfile that can generate a docker image to set up every resource for evaluation automatically. Along with Dockerfile, several bash or python scripts will be provided to getting result from a docker container.

## About
This program is authored and maintained by **Sanghoon(Kevin) Jeon**, **Min Soo Ryu**, and **Dong Young Kim**.
> Email: kppw99@gmail.com, onsoim@gmail.com, ehddud758@gmail.com

> GitHub[@FuzzBuilderEx](https://github.com/kppw99/FuzzBuilderEx)
