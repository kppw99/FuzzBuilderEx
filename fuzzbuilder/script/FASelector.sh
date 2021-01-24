#!/bin/bash

P="Parser"
S="FASelector.py"
python="python3.7"

log () { echo "[*] $1"; }

function installPython37 {
    mkdir tmp && cd tmp
    wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tar.xz
    tar xvf Python-3.7.0.tar.xz
    cd Python-3.7.0
    ./configure
    make altinstall
    cd ../../
    rm -rf tmp
}

function checkDependency {
    if ! [ -d "$P" ]; then
        log "No Parser exist!"
        log "Start to clone Parser from git"
        git clone https://github.com/onsoim/$P
    else
        log "Using exist Parser"
    fi

    [[ "$(python3.7 -V)" =~ "Python 3" ]] || installPython37
}

function usage {
    $python $P/$S -h
    exit
}

function main {
    checkDependency
    cp $S $P/

    if [ $# -ne 3 ]; then usage; fi
    $python $P/$S $1 $2 $3

    log "Generated seed conf folder is \"seeds.conf\""
}


main "$@"
