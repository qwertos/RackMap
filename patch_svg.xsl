<?xml version="1.0"?>

<xsl:stylesheet version="1.0" 
	xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/2000/svg">

	<xsl:output method="xml" indent="yes" />

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
		<text x="20" y="80" fill="black">
			<xsl:value-of select="contact" />
		</text>

		<!--
		<xsl:apply-templates select="rack/item[@type='patch']" />
		-->
		<xsl:apply-templates select="rack" />
	</xsl:template>



	<!--
	<xsl:template match="rack">
		<g transform="translate({ ( count(preceding-sibling::rack) * 250 ) + 50 },100)">
			<text x="20" y="20" fill="black">
				<xsl:value-of select="name" />
			</text>
			<text x="20" y="40" fill="black">
				<xsl:value-of select="location" />
			</text>
			<text x="20" y="60" fill="black">
				<xsl:value-of select="owner" />
			</text>
			<text x="20" y="80" fill="black">
				<xsl:value-of select="contact" />
			</text>
	
	
			<g transform="translate(10,100)">

			</g>
		</g>

	</xsl:template>
	-->

	<xsl:template match="rack">
		<xsl:variable name="ytrans" select="( sum(preceding-sibling::rack/item[@type='patch']/height) * 60 ) + ( count(preceding-sibling::rack) * 100 ) + 100" />
		
		<g transform="translate(50, { $ytrans })">
			<text x="20" y="20" fill="black">
				<xsl:value-of select="name" />
			</text>
			<text x="20" y="40" fill="black">
				<xsl:value-of select="location" />
			</text>
			<text x="20" y="60" fill="black">
				<xsl:value-of select="owner" />
			</text>
			<text x="20" y="80" fill="black">
				<xsl:value-of select="contact" />
			</text>
	
	
			<g transform="translate(50, 100)">
				<xsl:apply-templates select="item[@type='patch']" />
				<rect x='0' y='0' width='10' height='10' fill='black' />
			</g>
		</g>
	</xsl:template>


	<xsl:template match="item[@type='patch']">
		<xsl:element name="g">
			<xsl:attribute name="transform">
				<xsl:text>translate(0,</xsl:text>
				<xsl:value-of select="sum(preceding-sibling::item[@type='patch']/height) * 60" />
				<xsl:text>)</xsl:text>
			</xsl:attribute>


			<xsl:element name="rect">
				<xsl:attribute name="x">0</xsl:attribute>
				<xsl:attribute name="y">0</xsl:attribute>
				<xsl:attribute name="width">100</xsl:attribute>
				<xsl:choose>
					<xsl:when test="@fill">
						<xsl:attribute name="fill">
							<xsl:value-of select="@fill" />
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="fill">lightgray</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:attribute name="stroke">black</xsl:attribute>
				<xsl:attribute name="height">
					<xsl:value-of select="60" />
				</xsl:attribute>
			</xsl:element>

			<!-- Patch label-->
			<text x="0" y="15">
				<xsl:value-of select="name" />
			</text>


				<xsl:element name="rect">
					<xsl:attribute name="x">100</xsl:attribute>
					<xsl:attribute name="y">0</xsl:attribute>
					<xsl:attribute name="width">600</xsl:attribute>
					<xsl:choose>
						<xsl:when test="@fill">
							<xsl:attribute name="fill">
								<xsl:value-of select="@fill" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="fill">pink</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:attribute name="stroke">black</xsl:attribute>
					<xsl:attribute name='height'>
						<xsl:value-of select="height * 60" />
					</xsl:attribute>
				</xsl:element>

		</xsl:element>	
	</xsl:template>

</xsl:stylesheet>


