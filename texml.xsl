<?xml version="1.0"?>

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

	<xsl:output method="xml" indent="yes" />

	<xsl:variable name="scale" select="/datacenter/@scale" />

	<xsl:template match="/">
		<TeXML>
			<cmd name="documentclass">
				<opt>letterpaper</opt>
				<parm>article</parm>
			</cmd>
			<cmd name="usepackage">
				<opt>margin=1in</opt>
				<parm>geometry</parm>
			</cmd>
			<cmd name="usepackage">
				<parm>tikz</parm>
			</cmd>
			<cmd name="usepackage">
				<parm>parskip</parm>
			</cmd>
			<cmd name="setlength\parindent">
				<parm>0pt</parm>
			</cmd>
			<cmd name="newcommand\datacenter">
				<opt>4</opt>
				<parm>
					<spec cat="parm" />
					<xsl:text>1</xsl:text>
					<ctrl ch="\"/>
					<spec cat="parm" />
					<xsl:text>2</xsl:text>
					<ctrl ch="\"/>
					<spec cat="parm" />
					<xsl:text>3</xsl:text>
					<ctrl ch="\"/>
					<spec cat="parm" />
					<xsl:text>4</xsl:text>
				</parm>
			</cmd>
			<cmd name="newcommand\rack">
				<opt>4</opt>
				<parm>
					<spec cat="parm" />
					<xsl:text>1</xsl:text>
					<ctrl ch="\"/>
					<spec cat="parm" />
					<xsl:text>2</xsl:text>
					<ctrl ch="\"/>
					<spec cat="parm" />
					<xsl:text>3</xsl:text>
					<ctrl ch="\"/>
					<spec cat="parm" />
					<xsl:text>4</xsl:text>
				</parm>
			</cmd>
			<env name="document">
				<xsl:apply-templates select="datacenter" />
			</env>
		</TeXML>
	</xsl:template>



<!-- TODO PLACEHOLDER -->
	<xsl:template match="datacenter">
		<cmd name="datacenter">
			<parm><xsl:value-of select="name" /></parm>
			<parm><xsl:value-of select="location" /></parm>
			<parm><xsl:value-of select="owner" /></parm>
			<parm><xsl:value-of select="contact" /></parm>
		</cmd>

		<!--
		<xsl:apply-templates select="rack" />
		-->
	</xsl:template>



	<xsl:template match="rack">
		<g transform="translate({ ( count(preceding-sibling::rack) * 250 ) + 50 },100)">
			<cmd name="rack">
				<parm><xsl:value-of select="name" /></parm>
				<parm><xsl:value-of select="location" /></parm>
				<parm><xsl:value-of select="owner" /></parm>
				<parm><xsl:value-of select="contact" /></parm>
			</cmd>	
			
			<!--
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
		-->
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
			<xsl:choose>
				<xsl:when	test="../order = 'descend'">
					<xsl:attribute name="transform">
						<xsl:text>translate(0,</xsl:text>
						<xsl:value-of select="$scale * (../height - location)" />
						<xsl:text>)</xsl:text>
					</xsl:attribute>
				</xsl:when>

				<xsl:otherwise>
					<xsl:attribute name="transform">
						<xsl:text>translate(0,</xsl:text>
						<xsl:value-of select="$scale * location" />
						<xsl:text>)</xsl:text>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>

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


