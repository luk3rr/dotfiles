#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <tex_file>"
    exit 1
fi

tex_file="$1"
output_dir=$(dirname "$tex_file")

cd "$output_dir"

base_name=$(basename "$tex_file" .tex)

pdflatex "$base_name.tex"
bibtex "$base_name"
pdflatex "$base_name.tex"
pdflatex "$base_name.tex"

cd -
