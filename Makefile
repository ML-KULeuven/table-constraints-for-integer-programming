TEX = pdflatex -interaction=nonstopmode --shell-escape

SVGS := $(wildcard analysis/*.svg)
SVG_PDFS := $(patsubst analysis/%.svg,svg-inkscape/%_svg-tex.pdf,$(SVGS))

all: main.pdf

svg-inkscape/%_svg-tex.pdf: analysis/%.svg
	mkdir -p svg-inkscape
	inkscape $< --export-area-drawing --export-type=pdf --export-filename=$@ --export-latex

main.pdf: main.tex prelude.tex references.bib $(SVG_PDFS)
	$(TEX) main.tex
	bibtex main
	$(TEX) main.tex
	$(TEX) main.tex

clean:
	rm -rf main.aux main.log main.out main.pdf main.bbl main.blg main.vtc main.zip svg-inkscape

zip: main.zip

main.zip: main.tex prelude.tex references.bib lipics-v2021.cls main.pdf
	zip -r $@ Makefile main.pdf main.tex prelude.tex references.bib analysis svg-inkscape lipics-v2021.cls cc-by.pdf lipics-logo-bw.pdf orcid.pdf 

greyscale: main.pdf
	gs -sDEVICE=pdfwrite -dProcessColorModel=/DeviceGray -dColorConversionStrategy=/Gray -dNOPAUSE -dBATCH -sOutputFile=main-greyscale.pdf main.pdf

.PHONY: all clean zip greyscale
