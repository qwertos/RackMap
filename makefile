

all: out.svg patch.svg

out.svg: rack_svg.xsl rackinfo.xml
	xsltproc rack_svg.xsl rackinfo.xml > out.svg

patch.svg: patch_svg.xsl rackinfo.xml
	xsltproc patch_svg.xsl rackinfo.xml > patch.svg



clean:
	rm -rf out.svg
	rm -rf patch.svg
