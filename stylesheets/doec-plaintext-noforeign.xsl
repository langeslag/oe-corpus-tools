<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;"> <!-- NON-BREAKING SPACE -->
<!ENTITY AElig "&#x00C6;">		<!-- LATIN CAPITAL LETTER AE -->
<!ENTITY aelig "&#x00E6;">		<!-- LATIN SMALL LETTER AE -->
<!ENTITY OElig "&#x0152;">		<!-- LATIN CAPITAL LIGATURE OE -->
<!ENTITY oelig "&#x0153;">		<!-- LATIN SMALL LIGATURE OE -->
<!ENTITY THORN "&#x00DE;">		<!-- LATIN CAPITAL LETTER THORN -->
<!ENTITY thorn "&#x00FE;">		<!-- LATIN SMALL LETTER THORN -->
<!ENTITY ETH "&#x00D0;">		<!-- LATIN CAPITAL LETTER ETH -->
<!ENTITY eth "&#x00F0;">		<!-- LATIN SMALL LETTER ETH -->
<!ENTITY Eogon "&#x0118;">		<!-- LATIN CAPITAL LETTER E WITH OGONEK -->
<!ENTITY eogon "&#x0119;">		<!-- LATIN SMALL LETTER E WITH OGONEK -->
<!ENTITY quot "&#x0022;">		<!-- QUOTATION MARK -->
<!ENTITY amp "&#x0026;">		<!-- AMPERSAND -->
<!ENTITY apos "&#x0027;">		<!-- APOSTROPHE -->
<!ENTITY lt "&#x003C;">		<!-- LESS-THAN SIGN -->
<!ENTITY gt "&#x003E;">		<!-- GREATER-THAN SIGN -->
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0">
<!-- This stylesheet was written by Paul Langeslag. First draft 2022. -->

 <xsl:output method="text" encoding="utf-8"/>

<xsl:strip-space elements="*"/>

 <xsl:template match="/">
    		<xsl:for-each select="TEI.2">
     			<xsl:apply-templates select="text"/>
			</xsl:for-each>
 </xsl:template>

 <xsl:variable name="shortTitle">
	<xsl:value-of select="//teiHeader/fileDesc/titleStmt/title[@type='st']"/>
 </xsl:variable>

 <xsl:template match="text">
	 <xsl:apply-templates/>
 </xsl:template>

<xsl:template match="bibl">
</xsl:template>

 <xsl:template match="foreign">
 </xsl:template>

 <xsl:template match="corr">
	 <xsl:apply-templates/><xsl:text> </xsl:text>
 </xsl:template>

<xsl:template match="s">
	<!-- Uncomment and comment out the following two lines, respectively, or build in parameters, to avoid outputting sentence references: -->
	<!--<xsl:apply-templates/><xsl:text>&#xa;</xsl:text>-->
	<xsl:text>&#xa;</xsl:text><xsl:value-of select="$shortTitle"/><xsl:text> </xsl:text><xsl:value-of select="@n"/><xsl:text>: </xsl:text><xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
