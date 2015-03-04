<?xml version="1.0"?>

<xsl:stylesheet version="1.0" 
	xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/2000/svg">

	<xsl:output method="xml" indent="yes" />

	<xsl:variable name="scale" select="/datacenter/@scale" />
	<xsl:variable name="patchFullWidth" select="1500" />
	<xsl:variable name="slotHeight" select="60" />
	<xsl:variable name="patchBuffer" select="10" />

	<xsl:template match="/">
		<xsl:element name="svg">
			<!--
			<xsl:attribute name="xmlns">http://www.w3.org/2000/svg</xsl:attribute>-->
			<xsl:attribute name="version">1.1</xsl:attribute>
			<xsl:attribute name="height">
				<xsl:value-of select="(
						100 + (
							count(/datacenter/rack) * 100
						) + (
							sum(/datacenter/rack/item[@type='patch']/internal-layout/@vertical) * $slotHeight
						) + (
							( count(/datacenter/rack/item[@type='patch']) - 1 ) * $patchBuffer
						)	+ 1
					)"/>
			</xsl:attribute>

			<xsl:attribute name="width">
				<xsl:value-of select="( 50 + 50 + 100 + $patchFullWidth + 1 )"/>
			</xsl:attribute>

			<xsl:apply-templates select="datacenter" />
		</xsl:element>
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
		<xsl:variable name="ytrans_prev_slot_height_sum" select="sum(preceding-sibling::rack/item[@type='patch']/internal-layout/@vertical) * $slotHeight" />
		<xsl:variable name="ytrans_prev_rack_head" select="count(preceding-sibling::rack) * 100" />
		<xsl:variable name="ytrans_dc_head" select="100" />
		<xsl:variable name="ytrans_prev_patch_buf" select="count(preceding-sibling::rack/item[@type='patch']) * $patchBuffer" />
		<xsl:variable name="ytrans" select="$ytrans_prev_slot_height_sum + $ytrans_prev_rack_head + $ytrans_dc_head + $ytrans_prev_patch_buf" />
		
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
			</g>
		</g>
	</xsl:template>


	<xsl:template match="item[@type='patch']">
		<xsl:element name="g">
			<xsl:attribute name="transform">
				<xsl:text>translate(0,</xsl:text>
				<xsl:variable name="prev_slot_height_sum" select="sum(preceding-sibling::item[@type='patch']/internal-layout/@vertical) * $slotHeight" />
				<xsl:variable name="total_patch_buffer" select="count(preceding-sibling::item[@type='patch']) * $patchBuffer" />
				<xsl:value-of select="$prev_slot_height_sum + $total_patch_buffer" />
				<xsl:text>)</xsl:text>
			</xsl:attribute>

			<!--
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
			-->

			<!-- Patch label-->
			<text x="0" y="15">
				<xsl:value-of select="name" />
			</text>
			<text x="0" y="35">
				<xsl:text>Location: </xsl:text>
				<xsl:value-of select="location" />
			</text>

			<g transform="translate(100,0)">
				<xsl:element name="rect">
					<xsl:attribute name="x">0</xsl:attribute>
					<xsl:attribute name="y">0</xsl:attribute>
					<xsl:attribute name="width">
						<xsl:value-of select="$patchFullWidth" />
					</xsl:attribute>
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
					<xsl:attribute name='height'>
						<xsl:value-of select="internal-layout/@vertical * $slotHeight" />
					</xsl:attribute>
				</xsl:element>

				
				<xsl:call-template name='vert_bar'>
					<xsl:with-param name="pCurrent" select="1" />
					<xsl:with-param name="pStop" select="internal-layout/@horizontal" />
				</xsl:call-template>

				<xsl:call-template name='hori_bar'>
					<xsl:with-param name="pCurrent" select="1" />
					<xsl:with-param name="pStop" select="internal-layout/@vertical" />
				</xsl:call-template>
			
				<xsl:apply-templates select="internal-layout/slot"/>

			</g>

		</xsl:element>	
	</xsl:template>


	<xsl:template name="vert_bar">
		<xsl:param name="pCurrent" />
		<xsl:param name="pStop" />

		<xsl:element name="line">
			<xsl:attribute name="x1">
				<xsl:value-of select="( $patchFullWidth div internal-layout/@horizontal ) * $pCurrent" />
			</xsl:attribute>
			<xsl:attribute name="y1">0</xsl:attribute>
			<xsl:attribute name="x2">
				<xsl:value-of select="( $patchFullWidth div internal-layout/@horizontal ) * $pCurrent" />
			</xsl:attribute>
			<xsl:attribute name="y2">
				<xsl:value-of select="internal-layout/@vertical * $slotHeight" />
			</xsl:attribute>
			<xsl:attribute name="stroke">black</xsl:attribute>
		</xsl:element>

		<xsl:if test="$pCurrent &lt; $pStop">
			<xsl:call-template name="vert_bar">
				<xsl:with-param name="pCurrent" select="$pCurrent + 1" />
				<xsl:with-param name="pStop" select="$pStop"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="hori_bar">
		<xsl:param name="pCurrent" />
		<xsl:param name="pStop" />

		<xsl:element name="line">
			<xsl:attribute name="y1">
				<xsl:value-of select="$slotHeight * $pCurrent" />
			</xsl:attribute>
			<xsl:attribute name="x1">0</xsl:attribute>
			<xsl:attribute name="y2">
				<xsl:value-of select="$slotHeight * $pCurrent" />
			</xsl:attribute>
			<xsl:attribute name="x2">
				<xsl:value-of select="$patchFullWidth" />
			</xsl:attribute>
			<xsl:attribute name="stroke">black</xsl:attribute>
		</xsl:element>

		<xsl:if test="$pCurrent &lt; $pStop">
			<xsl:call-template name="hori_bar">
				<xsl:with-param name="pCurrent" select="$pCurrent + 1" />
				<xsl:with-param name="pStop" select="$pStop"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<xsl:template match="slot">
		<xsl:choose>
			<xsl:when test="../@direction-priority = 'ud'">
                                <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
                                <!-- <xsl:variable name="sypos" select="( @id - 1 ) mod ../@vertical" />         -->
                                <!-- <xsl:variable name="sxpos" select="floor( ( @id - 1 ) div ../@vertical)" /> -->
                                <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

				<xsl:call-template name="slot_with_params">
					<xsl:with-param name="sypos" select="( @id - 1 ) mod ../@vertical" />
					<xsl:with-param name="sxpos" select="floor( ( @id - 1 ) div ../@vertical)" />
				</xsl:call-template>
			</xsl:when>

			<xsl:otherwise>
				<xsl:call-template name="slot_with_params">
					<xsl:with-param name="sxpos" select="( @id - 1 ) mod ../@horizontal" />
					<xsl:with-param name="sypos" select="floor( ( @id - 1 ) div ../@horizontal)" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="slot_with_params">
		<xsl:param name="sxpos" />
		<xsl:param name="sypos" />

		<xsl:variable name="swidth" select="( $patchFullWidth div ../@horizontal )" />

		<xsl:element name="g">
			<xsl:attribute name="transform">
				<xsl:text>translate(</xsl:text>
				<xsl:value-of select="$sxpos * $swidth"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$sypos * $slotHeight"/>
				<xsl:text>)</xsl:text>
			</xsl:attribute>

			<xsl:element name="rect">
				<xsl:attribute name="x">0</xsl:attribute>
				<xsl:attribute name="y">0</xsl:attribute>
				<xsl:attribute name="height">
					<xsl:value-of select="$slotHeight" />
				</xsl:attribute>
				<xsl:attribute name="width">
					<xsl:value-of select="$swidth" />
				</xsl:attribute>
				<xsl:attribute name="fill">
					<xsl:value-of select="@color" />
				</xsl:attribute>
				<xsl:attribute name="stroke">black</xsl:attribute>
			</xsl:element>

			<text x="0" y="15">
				<xsl:value-of select="@id" />
			</text>
			<text x="0" y="35">
				<xsl:value-of select="@name" />
			</text>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>


