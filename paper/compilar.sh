#!/usr/bin/env bash
# Compila k_paper.tex localmente (pdflatex + biber). Uso: ./compilar.sh
set -e
cd "$(dirname "$0")"
if command -v latexmk >/dev/null 2>&1; then
  latexmk -pdf -interaction=nonstopmode k_paper.tex
else
  pdflatex -interaction=nonstopmode k_paper.tex
  biber k_paper
  pdflatex -interaction=nonstopmode k_paper.tex
  pdflatex -interaction=nonstopmode k_paper.tex
fi
echo "Listo: $(pwd)/k_paper.pdf"
