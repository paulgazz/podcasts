<?xml version="1.0" encoding="utf-8"?>
<xsl:transform  version="1.0"
                xmlns:npr="http://www.npr.org/rss/"
                xmlns:nprml="http://api.npr.org/nprml"
                xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
                xmlns:content="http://purl.org/rss/1.0/modules/content/"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:a="http://www.w3.org/2005/Atom"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                >

  <xsl:strip-space elements="*"/>
  <xsl:output method="text"/>

  <!-- <xsl:template match="/rss"> -->
  <!--   <xsl:apply-templates/> -->
  <!-- </xsl:template> -->

  <xsl:template match="text()|@*" />

  <xsl:template match="channel">
    <xsl:apply-templates />
  </xsl:template>

  <!-- <xsl:template match="/rss/channel/item"> -->
  <!--   <xsl:apply-templates/> -->
  <!-- </xsl:template> -->

  <xsl:template match="/rss/channel/item">"<xsl:value-of select="enclosure[contains(@type,'audio')]/@url[1]" />" "<xsl:value-of select="../title[1]" />" "<xsl:value-of select="title[1]" />" "<xsl:value-of select="../image[1]/url[1]" />" "<xsl:value-of select="pubDate[1]" />" "<xsl:value-of select="itunes:episode[1]" />"
</xsl:template>
</xsl:transform>
