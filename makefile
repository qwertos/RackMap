

all: out.svg

out.svg: layout.xsl rackinfo.xml
	xsltproc layout.xsl rackinfo.xml > out.svg

patch.svg: patch_svg.xsl rackinfo.xml
	xsltproc patch_svg.xsl rackinfo.xml > patch.svg



clean:
	rm -rf out.svg
	rm -rf patch.svg
