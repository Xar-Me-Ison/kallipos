#!/bin/bash
FONT="Open Sans"

if [ ! -d latex ]; then
  echo "Directory does not exist. Creating latex..."
  mkdir latex
else
  echo "Latex directory already exists."
fi

echo "Remaking the book directory..."
rm -rf ./book
mkdir book

echo "Assembling and preprocessing all the sources files..."

pandoc text/pre.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/pre.tex
pandoc text/intro.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/intro.tex

for filename in text/ch*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=filter.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --lua-filter=footnote.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --wrap=none --to latex > latex/"$(basename "$filename" .txt).tex"
done

pandoc text/web.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/web.tex
pandoc text/bio.txt --top-level-division=chapter --to latex > latex/bio.tex

for filename in text/apx*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --to latex > latex/"$(basename "$filename" .txt).tex"
done

echo "Merging tex files... "
pandoc -s latex/*.tex -o book/book.tex

echo "Converting to pdf... "
pandoc -N --quiet --variable "geometry=margin=1.2in" --variable mainfont="$FONT" --variable sansfont="$FONT" --variable monofont="$FONT" --variable fontsize=12pt --variable version=2.0 book/book.tex  --pdf-engine=xelatex --toc -o book/book.pdf
echo "Finished converting to pdf. "

echo "Converting to epub..."
pandoc -o book/book.epub book/book.tex --metadata title="book"

echo "Converting to html..."
echo "#lang pollen" >> book/book.html.pmd
pandoc book/book.tex -o book/book.html
cat book/book.html >> book/book.html.pmd
raco pollen render book/book.html.pmd
rm -rf "book/compiled"
rm "book/book.html.pmd"

echo "Book finished building."
