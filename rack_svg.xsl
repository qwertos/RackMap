<?xml version="1.0"?>
<!-- vim: set foldmethod=syntax : -->
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
				<xsl:choose>
					<xsl:when test="datacenter/name or datacenter/location or datacenter/owner or datacenter/contact">
						<xsl:value-of select="100 + 100 + ( $maxHeight * $scale ) + 1"/>
					</xsl:when>

					<xsl:otherwise>
						<xsl:value-of select="100 + ( $maxHeight * $scale ) + 1"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="width">
				<xsl:choose>
					<xsl:when test="/datacenter/@colormap and $colormap/colormap/limit">
						<xsl:value-of select=" ( count(/datacenter/rack[group = $colormap/colormap/limit]) * 250 ) + 50" />
					</xsl:when>

					<xsl:otherwise>
						<xsl:value-of select=" ( count(/datacenter/rack) * 250 ) + 50" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="style">
				<xsl:text>background-color: white</xsl:text>
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
		<xsl:if test="name">
			<text x="20" y="20" fill="black">
				<xsl:value-of select="name" />
			</text>
		</xsl:if>
		
		<xsl:if test="location">
			<text x="20" y="40" fill="black">
				<xsl:value-of select="location" />
			</text>
		</xsl:if>
		
		<xsl:if test="owner">
			<text x="20" y="60" fill="black">
				<xsl:value-of select="owner" />
			</text>
		</xsl:if>

		<xsl:if test="contact">
			<text x="20" y="80" fill="black">
				<xsl:value-of select="contact" />
			</text>
		</xsl:if>
		
		<xsl:element name="g">
			<xsl:if test="name or location or owner or contact">
				<xsl:attribute name="transform">
					<xsl:text>translate( 0, 100 )</xsl:text>
				</xsl:attribute>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="/datacenter/@colormap and $colormap/colormap/limit">
					<xsl:apply-templates select="rack[group = $colormap/colormap/limit]"/>
				</xsl:when>

				<xsl:otherwise>
					<xsl:apply-templates select="rack" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>



	<xsl:template match="rack">
		<xsl:element name="g">
			<xsl:attribute name="transform">
				<xsl:choose>
					<xsl:when test="/datacenter/@colormap and $colormap/colormap/limit">
						<xsl:text>translate(</xsl:text>
						<xsl:value-of select="( count(preceding-sibling::rack[group = $colormap/colormap/limit]) * 250 ) + 50"/>
						<xsl:text>, 0)</xsl:text>
					</xsl:when>

					<xsl:otherwise>
						<xsl:text>translate(</xsl:text>
						<xsl:value-of select="( count(preceding-sibling::rack) * 250 ) + 50"/>
						<xsl:text>, 0)</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>

			<!-- Add Name -->
			<text x="20" y="20" fill="black">
				<xsl:value-of select="name" />
			</text>
			<!-- Add location -->
			<text x="20" y="40" fill="black">
				<xsl:value-of select="location" />
			</text>
			<!-- Add owner -->
			<text x="20" y="60" fill="black">
				<xsl:value-of select="owner" />
			</text>
			<!-- Add contact -->
			<text x="20" y="80" fill="black">
				<xsl:value-of select="contact" />
			</text>
	
			<!-- Graphical -->	
			<g transform="translate(10,100)">

				<!-- Rectangle around rack -->
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

				<!-- Rack Unit ticks -->
				<xsl:call-template name="rubreaks">
					<xsl:with-param name="pCurrent" select="1" />
					<xsl:with-param name="pStop" select="height" />
				</xsl:call-template>

				<!-- Rack Unit numbers -->
				<xsl:call-template name="ruindex">
					<xsl:with-param name="pCurrent" select="1" />
					<xsl:with-param name="pStop" select="height" />
				</xsl:call-template>

				<!-- Add items -->
				<xsl:apply-templates select="item"/>
				<xsl:apply-templates select="bladecenter"/>

				<!-- Vert bar left -->
				<xsl:element name="line">
					<xsl:attribute name="x1">10</xsl:attribute>
					<xsl:attribute name="y1">0</xsl:attribute>
					<xsl:attribute name="x2">10</xsl:attribute>
					<xsl:attribute name="y2">
						<xsl:value-of select="$scale * height" />
					</xsl:attribute>
					<xsl:attribute name="stroke">black</xsl:attribute>
				</xsl:element>

				<!-- Vert bar right -->
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
		</xsl:element>
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

			<!-- Set vertical location -->
			<xsl:attribute name="transform">
				<xsl:text>translate(0,</xsl:text>
				<xsl:value-of select="$scale * (../height - location - height + 1)" />
				<xsl:text>)</xsl:text>
			</xsl:attribute>
			<xsl:variable name="itemname" select="name" />

			<!-- Create hover text -->
			<xsl:if test="/datacenter/@colormap">
				<xsl:if test="$colormap/colormap/item[name=$itemname]/trigger">
					<xsl:element name="title">
						<xsl:for-each select="$colormap/colormap/item[name=$itemname]/trigger" >
							<xsl:text>
- </xsl:text>
							<xsl:value-of select="." />
						</xsl:for-each>
					</xsl:element>
				</xsl:if>
			</xsl:if>

			<!-- WAT? -->
			<!--
			<xsl:if test="trigger">
				<xsl:element name="title">
					<xsl:for-each select="trigger">
						<xsl:value-of select="." />
						<xsl:text>
						</xsl:text>
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
			-->

			<!-- Rectangle around item -->
			<xsl:element name="rect">
				<xsl:attribute name="x">0</xsl:attribute>
				<xsl:attribute name="y">0</xsl:attribute>
				<xsl:attribute name="width">200</xsl:attribute>
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

			<!-- Item name -->
			<text x="20" y="15">
				<xsl:value-of select="name" />
			</text>
		</xsl:element>	
	</xsl:template>


	<xsl:template match="internal-layout">
		<xsl:element name="g">

			<!-- Offset from "rack mount" -->
			<xsl:attribute name="transform">
				<xsl:text>translate(10,0)</xsl:text>
			</xsl:attribute>

			
		</xsl:element>	
	</xsl:template>


	<xsl:template match="bladecenter">
		<xsl:element name="g">

			<!-- Set its location in the rack -->
			<xsl:attribute name="transform">
				<xsl:text>translate(0,</xsl:text>
				<xsl:value-of select="$scale * (../height - location - height + 1)" />
				<xsl:text>)</xsl:text>
			</xsl:attribute>

			<xsl:variable name="itemname" select="name" />

			<xsl:apply-templates select="internal-layout"/>

			<!-- Add the triggers in hover text -->
			<xsl:if test="/datacenter/@colormap">
				<xsl:if test="$colormap/colormap/item[name=$itemname]/trigger">
					<xsl:element name="title">
						<xsl:for-each select="$colormap/colormap/item[name=$itemname]/trigger" >
							<xsl:text>
- </xsl:text>
							<xsl:value-of select="." />
						</xsl:for-each>
					</xsl:element>
				</xsl:if>
			</xsl:if>

			<!-- XXX: WAT??-->
			<!--
			<xsl:if test="trigger">
				<xsl:element name="title">
					<xsl:for-each select="trigger">
						<xsl:value-of select="." />
						<xsl:text>
						</xsl:text>
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
			-->

			<xsl:element name="rect">
				<xsl:attribute name="x">0</xsl:attribute>
				<xsl:attribute name="y">0</xsl:attribute>
				<xsl:attribute name="width">200</xsl:attribute>
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


