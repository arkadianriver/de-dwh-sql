#!/bin/bash

case $1 in
	"clean")    rm -rf out/html/*
				rm -rf out/pdf/*
				;;
	"html")     mkdir -p out/html
				asciidoctor -r asciidoctor-diagram -D out/html src/de-dwh-sql.adoc
				cp src/*.png out/html/
				cp src/*.svg out/html/
				;;
	"pdf")      mkdir -p out/pdf
				asciidoctor-pdf -r asciidoctor-diagram -o out/pdf/de-dwh-sql.pdf src/de-dwh-sql.adoc
				;;
	"all")      mkdir -p out/html
				asciidoctor -r asciidoctor-diagram -D out/html src/de-dwh-sql.adoc
				cp src/*.png out/html/
				cp src/*.svg out/html/
				mkdir -p out/pdf
				asciidoctor-pdf -r asciidoctor-diagram -o out/pdf/de-dwh-sql.pdf src/de-dwh-sql.adoc
				;;
	*)          echo "Usage: $0 {clean|html|pdf|all}"
				;;
esac
