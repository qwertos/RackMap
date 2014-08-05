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
		<text x="10" y="10" fill="red">THIS IS A TEST</text>
	</xsl:template>



</xsl:stylesheet>


