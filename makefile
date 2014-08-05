

all: out.svg

out.svg: layout.xsl rackinfo.xml
	xsltproc layout.xsl rackinfo.xml > out.svg



clean:
	rm -rf out.svg
