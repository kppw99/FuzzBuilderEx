#!/bin/sh

P="Parser"
S="FASelector.py"

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
    python3 $P/$S -h
    exit
}

function main {
    checkDependency
    cp $S $P/

    if [ $# -ne 3 ]; then usage; fi
    python3 $P/$S $1 $2 $3

    log "Generated seed conf folder is \"seeds.conf\""
}


main "$@"