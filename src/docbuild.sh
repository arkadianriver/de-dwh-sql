#!/bin/bash

cp docsrc/index.html ../docs/
touch ../docs/.nojekyll

case $1 in
	"clean")    rm -rf ../docs/*
				;;
	"html")     mkdir -p ../docs/html
				asciidoctor -r asciidoctor-diagram -D ../docs/html docsrc/sql-data-warehouse.adoc
				cp -r docsrc/media ../docs/html/
				;;
	"pdf")      mkdir -p ../docs/pdf
				asciidoctor-pdf -r asciidoctor-diagram -o ../docs/pdf/sql-data-warehouse.pdf docsrc/sql-data-warehouse.adoc
				;;
	"all")      mkdir -p ../docs/html
				asciidoctor -r asciidoctor-diagram -D ../docs/html docsrc/sql-data-warehouse.adoc --trace
				cp -r docsrc/media ../docs/html/
				mkdir -p ../docs/pdf
				asciidoctor-pdf -r asciidoctor-diagram -o ../docs/pdf/sql-data-warehouse.pdf docsrc/sql-data-warehouse.adoc --trace
				;;
	*)          echo "Usage: $0 {clean|html|pdf|all}"
				;;
esac
