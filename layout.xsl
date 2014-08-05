<?xml version="1.0"?>

<xsl:stylesheet version="1.0" 
	xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/2000/svg">

	<xsl:variable name="scale" select="/datacenter/@scale" />

	<xsl:template match="/">
		<svg xmlns="http://www.w3.org/2000/svg" version="1.1">
			<xsl:apply-templates select="datacenter" />
		</svg>
	</xsl:template>



	<xsl:template match="datacenter">
		<text x="20" y="20" fill="black">
			<xsl:value-of select="name" />
		</text>
		<text x="20" y="40" fill="black">
			<xsl:value-of select="location" />
		</text>
		<text x="20" y="60" fill="black">
			<xsl:value-of select="owner" />
		</text>

		<xsl:apply-templates select="rack" />
	</xsl:template>



	<xsl:template match="rack">
		<g transform="translate({ ( count(../preceding-sibling::rack) * 210 ) + 10 },100)">
			<text x="20" y="20" fill="black">
				<xsl:value-of select="name" />
			</text>
			<text x="20" y="40" fill="black">
				<xsl:value-of select="location" />
			</text>
			<text x="20" y="60" fill="black">
				<xsl:value-of select="owner" />
			</text>
	
	
			<g transform="translate(10,100)">
				<xsl:element name="rect">
					<xsl:attribute name="x">0</xsl:attribute>
					<xsl:attribute name="y">0</xsl:attribute>
					<xsl:attribute name="width">200</xsl:attribute>
					<xsl:attribute name="fill">none</xsl:attribute>
					<xsl:attribute name="stroke">black</xsl:attribute>
					<xsl:attribute name="height">
						<xsl:value-of select="$scale * height" />
					</xsl:attribute>
				</xsl:element>
	
				<xsl:apply-templates select="item"/>
			</g>
		</g>

	</xsl:template>


	<xsl:template match="item">
		<xsl:element name="g">
			<xsl:attribute name="transform">
				<xsl:text>translate(0,</xsl:text>
				<xsl:value-of select="$scale * location" />
				<xsl:text>)</xsl:text>
			</xsl:attribute>

			<xsl:element name="rect">
				<xsl:attribute name="x">0</xsl:attribute>
				<xsl:attribute name="y">0</xsl:attribute>
				<xsl:attribute name="width">200</xsl:attribute>
				<xsl:attribute name="fill">none</xsl:attribute>
				<xsl:attribute name="stroke">black</xsl:attribute>
				<xsl:attribute name="height">
					<xsl:value-of select="$scale * height" />
				</xsl:attribute>
			</xsl:element>

			<text x="20" y="15">
				<xsl:value-of select="name" />
			</text>
		</xsl:element>	
	</xsl:template>

</xsl:stylesheet>


