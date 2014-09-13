

all: out.svg out.pdf

out.pdf: out.tex
	pdflatex out.tex

out.tex: out.texml
	texml out.texml out.tex

out.texml: texml.xsl rackinfo.xml
	xsltproc texml.xsl rackinfo.xml > out.texml

out.svg: layout.xsl rackinfo.xml
	xsltproc layout.xsl rackinfo.xml > out.svg



clean:
	rm -rf out.svg
	rm -rf out.tex
	rm -rf out.texml
	rm -rf out.pdf
	rm -rf out.aux
	rm -rf out.log
