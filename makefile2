
all:

install: /usr/local/bin/rackmap


/usr/local/lib/rackmap:
	mkdir -p /usr/local/lib/rackmap

/usr/local/lib/rackmap/patch_svg.xsl: /usr/local/lib/rackmap patch_svg.xsl
	cp patch_svg.xsl /usr/local/lib/rackmap/patch_svg.xsl

/usr/local/lib/rackmap/rack_svg.xsl: /usr/local/lib/rackmap rack_svg.xsl
	cp rack_svg.xsl /usr/local/lib/rackmap/rack_svg.xsl

/usr/local/bin:
	mkdir -p /usr/local/bin

/usr/local/bin/rackmap: /usr/local/bin rackmap /usr/local/lib/rackmap /usr/local/lib/rackmap/patch_svg.xsl /usr/local/lib/rackmap/rack_svg.xsl
	cp rackmap /usr/local/bin/rackmap



remove:
	rm -rf /usr/local/lib/rackmap
	rm -f /usr/local/bin/rackmap


