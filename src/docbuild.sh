#!/bin/bash

case $1 in
	"clean")    rm -rf ../docs/*
				;;
	"html")     mkdir -p ../docs/html
				cp docsrc/index.html ../docs/
				touch ../docs/.nojekyll
				asciidoctor -r asciidoctor-diagram -D ../docs/html docsrc/de-dwh-sql.adoc
				cp docsrc/*.png ../docs/html/
				cp docsrc/*.svg ../docs/html/
				;;
	"pdf")      mkdir -p ../docs/pdf
				asciidoctor-pdf -r asciidoctor-diagram -o ../docs/pdf/de-dwh-sql.pdf docsrc/de-dwh-sql.adoc
				;;
	"all")      mkdir -p ../docs/html
				cp docsrc/index.html ../docs/
				touch ../docs/.nojekyll
				asciidoctor -r asciidoctor-diagram -D ../docs/html docsrc/de-dwh-sql.adoc
				cp docsrc/*.png ../docs/html/
				cp docsrc/*.svg ../docs/html/
				mkdir -p ../docs/pdf
				asciidoctor-pdf -r asciidoctor-diagram -o ../docs/pdf/de-dwh-sql.pdf docsrc/de-dwh-sql.adoc
				;;
	*)          echo "Usage: $0 {clean|html|pdf|all}"
				;;
esac
