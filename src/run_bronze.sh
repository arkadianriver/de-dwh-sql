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
    "create")   sudo -u postgres psql -f bronze/ddl_bronze.sql 2>&1 | tee "${logroot}-${tstamp}-2-create.log"
                ;;
    "load")     sudo -u postgres psql -f bronze/load_bronze.sql 2>&1 | tee "${logroot}-${tstamp}-3-load.log"
                ;;
    "all")      SECONDS=0 &&
                sudo -u postgres psql -f init_database.sql  2>&1 | tee "${logroot}-${tstamp}-0-all.log" &&
                sudo -u postgres psql -f bronze/ddl_bronze.sql 2>&1 | tee "${logroot}-${tstamp}-0-all.log" &&
                sudo -u postgres psql -f bronze/load_bronze.sql 2>&1 | tee "${logroot}-${tstamp}-0-all.log" &&
                echo -ne "\n=================================\nElapsed time: $SECONDS seconds\n=================================\n" | tee -a "${logroot}-${tstamp}-0-all.log"
                ;;
    *)          echo "Usage: $0 {init|create|load|all}"
esac
