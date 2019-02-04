#!/bin/sh

pdflatex -halt-on-error -jobname=input > /dev/null 2>&1

cat input.log >&2

if [ $? -ne 0 ]; then
  exit 1
fi

echo "Converting..." >&2

pdf2svg input.pdf output.svg
cat output.svg

exit 0

