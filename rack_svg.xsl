<?xml version="1.0"?>

<xsl:stylesheet version="1.0" 
	xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/2000/svg">

	<xsl:output method="xml" indent="yes" />

	<xsl:variable name="scale" select="/datacenter/@scale" />

		<xsl:variable name="colormap" select="document(/datacenter/@colormap)" />


	<xsl:template match="/">
		<xsl:element name="svg">
			<xsl:variable name="maxHeight">
				<xsl:call-template name="maximum">
					<xsl:with-param name="pSeq" select="/datacenter/rack/height" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:attribute name="version">1.1</xsl:attribute>
			<xsl:attribute name="height">
				<xsl:value-of select="100 + 100 + ( $maxHeight * $scale ) + 1"/>
			</xsl:attribute>
			<xsl:attribute name="width">
				<xsl:value-of select=" ( count(/datacenter/rack) * 250 ) + 50" />
			</xsl:attribute>


			<xsl:apply-templates select="datacenter" />
		</xsl:element>
	</xsl:template>


	<xsl:template name="maximum">
		<xsl:param name="pSeq" />

		<xsl:for-each select="$pSeq">
			<xsl:sort select="." data-type="number" order="descending" />
			<xsl:if test="position() = 1">
				<xsl:value-of select="." />
			</xsl:if>
		</xsl:for-each>
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

		<xsl:apply-templates select="rack" />
	</xsl:template>



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

				<xsl:call-template name="rubreaks">
					<xsl:with-param name="pCurrent" select="1" />
					<xsl:with-param name="pStop" select="height" />
				</xsl:call-template>

				<xsl:call-template name="ruindex">
					<xsl:with-param name="pCurrent" select="1" />
					<xsl:with-param name="pStop" select="height" />
				</xsl:call-template>

				<xsl:apply-templates select="item"/>

				<xsl:element name="line">
					<xsl:attribute name="x1">10</xsl:attribute>
					<xsl:attribute name="y1">0</xsl:attribute>
					<xsl:attribute name="x2">10</xsl:attribute>
					<xsl:attribute name="y2">
						<xsl:value-of select="$scale * height" />
					</xsl:attribute>
					<xsl:attribute name="stroke">black</xsl:attribute>
				</xsl:element>
					
				<xsl:element name="line">
					<xsl:attribute name="x1">190</xsl:attribute>
					<xsl:attribute name="y1">0</xsl:attribute>
					<xsl:attribute name="x2">190</xsl:attribute>
					<xsl:attribute name="y2">
						<xsl:value-of select="$scale * height" />
					</xsl:attribute>
					<xsl:attribute name="stroke">black</xsl:attribute>
				</xsl:element>
			</g>
		</g>

	</xsl:template>


	<xsl:template name="ruindex">
		<xsl:param name="pCurrent" />
		<xsl:param name="pStop" />

		<xsl:element name="text">
			<xsl:attribute name="x">-20</xsl:attribute>
			<xsl:attribute name="y">
				<xsl:value-of select="($scale * ( height - $pCurrent )) + 15 " />
			</xsl:attribute>

			<xsl:value-of select="$pCurrent" />

		</xsl:element>

		<xsl:if test="$pCurrent &lt; $pStop">
			<xsl:call-template name="ruindex">
				<xsl:with-param name="pCurrent" select="$pCurrent + 1" />
				<xsl:with-param name="pStop" select="$pStop" />
			</xsl:call-template>
		</xsl:if>
			
	</xsl:template>




	<xsl:template name="rubreaks">
		<xsl:param name="pCurrent" />
		<xsl:param name="pStop" />

		<xsl:element name="line">
			<xsl:attribute name="x1">0</xsl:attribute>
			<xsl:attribute name="y1">
				<xsl:value-of select="$pCurrent * $scale" />
			</xsl:attribute>
			<xsl:attribute name="x2">10</xsl:attribute>
			<xsl:attribute name="y2">
				<xsl:value-of select="$pCurrent * $scale" />
			</xsl:attribute>
			<xsl:attribute name="stroke">black</xsl:attribute>
		</xsl:element>

		<xsl:element name="line">
			<xsl:attribute name="x1">190</xsl:attribute>
			<xsl:attribute name="y1">
				<xsl:value-of select="$pCurrent * $scale" />
			</xsl:attribute>
			<xsl:attribute name="x2">200</xsl:attribute>
			<xsl:attribute name="y2">
				<xsl:value-of select="$pCurrent * $scale" />
			</xsl:attribute>
			<xsl:attribute name="stroke">black</xsl:attribute>
		</xsl:element>

		<xsl:if test="$pCurrent &lt; $pStop">
			<xsl:call-template name="rubreaks">
				<xsl:with-param name="pCurrent" select="$pCurrent + 1" />
				<xsl:with-param name="pStop" select="$pStop" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>



	<xsl:template match="item">
		<xsl:element name="g">
			<!--
			<xsl:choose>
				<xsl:when	test="../order = 'descend'">
					-->
					<xsl:attribute name="transform">
						<xsl:text>translate(0,</xsl:text>
						<xsl:value-of select="$scale * (../height - location - height + 1)" />
						<xsl:text>)</xsl:text>
					</xsl:attribute>
				<!--
				</xsl:when>

				<xsl:otherwise>
					<xsl:attribute name="transform">
						<xsl:text>translate(0,</xsl:text>
						<xsl:value-of select="$scale * location" />
						<xsl:text>)</xsl:text>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			-->			

			<xsl:element name="rect">
				<xsl:attribute name="x">0</xsl:attribute>
				<xsl:attribute name="y">0</xsl:attribute>
				<xsl:attribute name="width">200</xsl:attribute>
				<xsl:variable name="itemname" select="name" />
				<xsl:choose>
					<xsl:when test="@fill">
						<xsl:attribute name="fill">
							<xsl:value-of select="@fill" />
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="/datacenter/@colormap">
						<xsl:choose>
							<xsl:when test="$colormap/colormap/item[name=$itemname]">
								<xsl:attribute name="fill">
									<xsl:value-of select="$colormap/colormap/item[name=$itemname]/color" />
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="fill">lightgray</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="fill">lightgray</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
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


