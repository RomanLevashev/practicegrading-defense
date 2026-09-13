#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$ROOT_DIR/.build"
PDF_DIR="$ROOT_DIR/pdf"

rm -rf "$BUILD_DIR"

mkdir -p \
    "$BUILD_DIR/report" \
    "$BUILD_DIR/presentation" \
    "$PDF_DIR"

echo "Building report..."

(
    cd "$ROOT_DIR/sources/report"

    latexmk \
        -xelatex \
        -interaction=nonstopmode \
        -halt-on-error \
        -outdir="$BUILD_DIR/report" \
        report.tex
)

cp "$BUILD_DIR/report/report.pdf" \
   "$PDF_DIR/report.pdf"


echo "Building presentation..."

(
    cd "$ROOT_DIR/sources/presentation"

    latexmk \
        -xelatex \
        -interaction=nonstopmode \
        -halt-on-error \
        -outdir="$BUILD_DIR/presentation" \
        presentation.tex
)

cp "$BUILD_DIR/presentation/presentation.pdf" \
   "$PDF_DIR/presentation.pdf"


echo "Building technical documentation..."

(
    cd "$ROOT_DIR/sources/technical-documentation"

    pandoc technical-documentation.md \
        --from=markdown \
        --pdf-engine=xelatex \
        --lua-filter=pdf.lua \
        --include-in-header=header.tex \
        -V mainfont="DejaVu Serif" \
        -V sansfont="DejaVu Sans" \
        -V monofont="DejaVu Sans Mono" \
        -V fontsize=10pt \
        -V papersize=a4 \
        -V geometry:margin=20mm \
        -V lang=ru \
        -o "$PDF_DIR/technical-documentation.pdf"
)

echo
echo "Build completed successfully:"
echo "  pdf/report.pdf"
echo "  pdf/presentation.pdf"
echo "  pdf/technical-documentation.pdf"
