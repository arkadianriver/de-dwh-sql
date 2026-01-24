#!/bin/bash

case $1 in
	"clean")    rm -rf out/html/*
				rm -rf out/pdf/*
				;;
	"html")     mkdir -p out/html
				asciidoctor src/index.adoc -o out/html/index.html
				cp src/*.png out/html/
				cp src/*.svg out/html/
				;;
	"pdf")      mkdir -p out/pdf
				asciidoctor-pdf src/index.adoc -o out/pdf/de-dwh-sql.pdf
				;;
	"all")      mkdir -p out/html
				asciidoctor src/index.adoc -o out/html/index.html
				cp src/*.png out/html/
				cp src/*.svg out/html/
				mkdir -p out/pdf
				asciidoctor-pdf src/index.adoc -o out/pdf/de-dwh-sql.pdf
				;;
	*)          echo "Usage: $0 {clean|html|pdf|all}"
				;;
esac
