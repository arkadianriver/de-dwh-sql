#!/bin/bash

relsdir=$(realpath "${BASH_SOURCE[0]}")
abssdir=$(dirname "$relsdir")
absprjdir=$(dirname "$abssdir")

tstamp=$(date +%Y-%m-%d_%H%M%S)

logroot="${absprjdir}/logs/run_silver"

mkdir -p "${absprjdir}/logs"

case $1 in
    "create")   sudo -u postgres psql -f silver/ddl_silver.sql 2>&1 | tee "${logroot}-${tstamp}-2-create.log"
                ;;
    "load")     sudo -u postgres psql -f silver/load_silver.sql 2>&1 | tee "${logroot}-${tstamp}-3-load.log"
                ;;
    "all")      SECONDS=0 &&
                sudo -u postgres psql -f silver/ddl_silver.sql 2>&1 | tee "${logroot}-${tstamp}-0-all.log" &&
                sudo -u postgres psql -f silver/load_silver.sql 2>&1 | tee "${logroot}-${tstamp}-0-all.log" &&
                echo -ne "\n=================================\nElapsed time: $SECONDS seconds\n=================================\n" | tee -a "${logroot}-${tstamp}-0-all.log"
                ;;
    *)          echo "Usage: $0 {create|load|all}"
esac
