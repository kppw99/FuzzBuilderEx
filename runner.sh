#!/bin/bash

function build {
    docker-compose build fuzzbuilderex
    docker-compose build $1_pre
    docker-compose build $1
}


build "$@"

# bash runner.sh boringssl