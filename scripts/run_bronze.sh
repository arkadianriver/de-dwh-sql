#!/bin/bash

case $1 in
    "init")     sudo -u postgres psql -f init_database.sql ;;
    "create")   sudo -u postgres psql -f bronze/ddl_bronze.sql ;;
    "load")     sudo -u postgres psql -f bronze/load_bronze.sql ;;
    "all")      sudo -u postgres psql -f init_database.sql && sudo -u postgres psql -f bronze/ddl_bronze.sql && sudo -u postgres psql -f bronze/load_bronze.sql ;;
    *)          echo "Usage: $0 {init|create|load}"
esac
