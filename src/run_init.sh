#!/bin/bash

relsdir=$(realpath "${BASH_SOURCE[0]}")
abssdir=$(dirname "$relsdir")
absprjdir=$(dirname "$abssdir")

tstamp=$(date +%Y-%m-%d_%H%M%S)

logroot="${absprjdir}/logs/run_bronze"

mkdir -p "${absprjdir}/logs"

case $1 in
    "init")     sudo -u postgres psql -f init_database.sql 2>&1 | tee "${logroot}-${tstamp}-1-init.log"
                ;;
    *)          echo "Usage: $0 init"
esac
