#!/bin/sh

P="Parser"

log () { echo "[*] $1"; }

function checkDependency {
    if ! [ -d "$P" ]; then
        log "No Parser exist!"
        log "Start to clone Parser from git"
        git clone https://github.com/onsoim/$P
    else
        log "Using exist Parser"
    fi
}

function usage {
    python3 $P/FA.py -h
    exit
}

function main {
    checkDependency
    cp FA.py $PARSER/

    if [ $# -ne 3 ]; then usage; fi
    python3 Parser/FA.py $1 $2 $3

    log "Generated seed conf folder is \"seeds.conf\""
}


main "$@"