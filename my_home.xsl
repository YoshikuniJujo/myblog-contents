<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:html="http://www.w3.org/1999/xhtml">

<xsl:output
	omit-xml-declaration="no"
	encoding="UTF-8"
	method="xml"
	version="1.0"
	doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	indent="yes" />

<xsl:template match="/">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ja_JP">
<head>
<title><xsl:value-of select="page/title" /></title>
</head>
<body>
<xsl:apply-templates select="page" />
<hr/>
<p style="text-align:left;">
	<a href="/salamander/third/">home</a></p>
<p style="text-align:right;">
	<a href="http://validator.w3.org/check?uri=referer"><img
		src="http://www.w3.org/Icons/valid-xhtml10"
		alt="Valid XHTML 1.0 Strict" height="31" width="88" /></a></p>
</body>
</html>
</xsl:template>

<xsl:template match="page">
<h1><xsl:value-of select="title" /></h1>
<h2>リンク</h2>
<xsl:apply-templates select="link" />
</xsl:template>

<xsl:template match="link">
<p>
<a>
<xsl:attribute name="href"><xsl:value-of select="address" /></xsl:attribute>
<xsl:apply-templates select="image" />
<xsl:text> </xsl:text>
<xsl:apply-templates select="title" />
</a></p>
</xsl:template>

<xsl:template match="image">
<img alt="" height="20"><xsl:attribute name="src">
<xsl:value-of select="address" />
</xsl:attribute>
</img>
</xsl:template>

</xsl:stylesheet>
