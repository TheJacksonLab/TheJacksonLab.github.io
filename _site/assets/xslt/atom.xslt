<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom">
<xsl:output method="html" encoding="utf-8" />
<xsl:template match="/atom:feed">
	<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html &gt;</xsl:text>
	<html>
	<head>
		<xsl:text disable-output-escaping="yes"><![CDATA[
		<meta charset="utf-8">

	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Atom Feed (Styled)</title>

    <link rel="stylesheet" type="text/css" href="http://localhost:4001/assets/css/styles_feeling_responsive.css">

    <link href="/assets/css/fontawesome.all.min.css" rel="stylesheet">

  

	<script src="http://localhost:4001/assets/js/modernizr.min.js"></script>

	<script src="https://ajax.googleapis.com/ajax/libs/webfont/1.5.18/webfont.js"></script>
	<script>
		WebFont.load({
			google: {
				families: [ 'Zalando+Sans:400,500,600,700:latin', 'Trocchi:400,700:latin' ]
			}
		});
	</script>

	<noscript>
		<link href='http://fonts.googleapis.com/css?family=Zalando+Sans:400,500,600,700|Trocchi:400,700' rel='stylesheet' type='text/css'>
	</noscript>


	<!-- Search Engine Optimization -->
	<meta name="description" content="This is the website for the academic lab of Malachi and Obi Griffith">
	
	
	
	
	
	
	<link rel="canonical" href="http://localhost:4001/assets/xslt/atom.xslt">


	<!-- Facebook Open Graph -->
	<meta property="og:title" content="Atom Feed (Styled)">
	<meta property="og:description" content="This is the website for the academic lab of Malachi and Obi Griffith">
	<meta property="og:url" content="http://localhost:4001/assets/xslt/atom.xslt">
	<meta property="og:locale" content="en_EN">
	<meta property="og:type" content="website">
	<meta property="og:site_name" content="The Jackson Lab">
	
	


	

	<link type="text/plain" rel="author" href="http://localhost:4001/humans.txt">

	

	

	<link rel="icon" sizes="32x32" href="http://localhost:4001/assets/img/favicon-32x32.png">

	<link rel="icon" sizes="192x192" href="http://localhost:4001/assets/img/touch-icon-192x192.png">

	<link rel="apple-touch-icon-precomposed" sizes="180x180" href="http://localhost:4001/assets/img/apple-touch-icon-180x180-precomposed.png">

	<link rel="apple-touch-icon-precomposed" sizes="152x152" href="http://localhost:4001/assets/img/apple-touch-icon-152x152-precomposed.png">

	<link rel="apple-touch-icon-precomposed" sizes="144x144" href="http://localhost:4001/assets/img/apple-touch-icon-144x144-precomposed.png">

	<link rel="apple-touch-icon-precomposed" sizes="120x120" href="http://localhost:4001/assets/img/apple-touch-icon-120x120-precomposed.png">

	<link rel="apple-touch-icon-precomposed" sizes="114x114" href="http://localhost:4001/assets/img/apple-touch-icon-114x114-precomposed.png">

	
	<link rel="apple-touch-icon-precomposed" sizes="76x76" href="http://localhost:4001/assets/img/apple-touch-icon-76x76-precomposed.png">

	<link rel="apple-touch-icon-precomposed" sizes="72x72" href="http://localhost:4001/assets/img/apple-touch-icon-72x72-precomposed.png">

	<link rel="apple-touch-icon-precomposed" href="http://localhost:4001/assets/img/apple-touch-icon-precomposed.png">	

	<meta name="msapplication-TileImage" content="http://localhost:4001/assets/img/msapplication_tileimage.png">

	<meta name="msapplication-TileColor" content="#fabb00">


	

		]]></xsl:text>
	</head>
	<body id="top-of-page">
		<xsl:text disable-output-escaping="yes"><![CDATA[
		<div id="navigation" class="sticky">
  <nav class="top-bar" role="navigation" data-topbar>
    <ul class="title-area">
      <li class="name">
      <h1 class="show-for-small-only"><a href="http://localhost:4001" class="icon-tree"> The Jackson Lab</a></h1>
    </li>
       <!-- Remove the class "menu-icon" to get rid of menu icon. Take out "Menu" to just have icon alone -->
      <li class="toggle-topbar menu-icon"><a href="#"><span>Nav</span></a></li>
    </ul>
    <section class="top-bar-section">

      <ul class="right">
        

              

          
          
        

              

          
          
        

              

          
          
        

              

          
          
        

              

          
          
        

              

          
          
        

              

          
          
            
            
              <li class="divider"></li>
              <li><a  href="http://localhost:4001/contact/">Contact</a></li>

            
            
          
        
        
      </ul>

      <ul class="left">
        

              

          
          

            
            
              <li><a  href="http://localhost:4001/">Home</a></li>
              <li class="divider"></li>

            
            
          
        

              

          
          

            
            
              <li><a  href="http://localhost:4001/team/">Team</a></li>
              <li class="divider"></li>

            
            
          
        

              

          
          

            
            
              <li><a  href="http://localhost:4001/research/">Research</a></li>
              <li class="divider"></li>

            
            
          
        

              

          
          

            
            
              <li><a  href="http://localhost:4001/publications/">Publications</a></li>
              <li class="divider"></li>

            
            
          
        

              

          
          

            
            

              <li class="has-dropdown">
                <a  href="http://localhost:4001/news/">News</a>

                  <ul class="dropdown">
                    

                      

                      <li><a  href="http://localhost:4001/news/archive/">News Archive</a></li>
                    
                  </ul>

              </li>
              <li class="divider"></li>
            
          
        

              

          
          

            
            
              <li><a  href="http://localhost:4001/software/">Resources</a></li>
              <li class="divider"></li>

            
            
          
        

              

          
          
        
        
      </ul>
    </section>
  </nav>
</div><!-- /#navigation -->

		

<div id="masthead-no-image-header">
	<div class="row">
		<div class="small-12 columns">
			<a id="logo" href="http://localhost:4001/" title="The Jackson Lab – ">
				<img src="http://localhost:4001/assets/img/Site_Logo4.png" alt="The Jackson Lab – ">
			</a>
		</div><!-- /.small-12.columns -->
	</div><!-- /.row -->
</div><!-- /#masthead -->









		


<div class="alert-box warning text-center"><p>This <a href="https://en.wikipedia.org/wiki/RSS" target="_blank">Atom feed</a> is meant to be used by <a href="https://en.wikipedia.org/wiki/Template:Aggregators" target="_blank">RSS reader applications and websites</a>.</p>
</div>



		]]></xsl:text>
		<header class="t30 row">
	<p class="subheadline"><xsl:value-of select="atom:subtitle" disable-output-escaping="yes" /></p>
	<h1>
		<xsl:element name="a">
			<xsl:attribute name="href">
				<xsl:value-of select="atom:id" />
			</xsl:attribute>
			<xsl:value-of select="atom:title" />
		</xsl:element>
	</h1>
</header>
<ul class="accordion row" data-accordion="">
	<xsl:for-each select="atom:entry">
		<li class="accordion-navigation">
			<xsl:variable name="slug-id">
				<xsl:call-template name="slugify">
					<xsl:with-param name="text" select="atom:id" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:element name="a">
				<xsl:attribute name="href"><xsl:value-of select="concat('#', $slug-id)"/></xsl:attribute>
				<xsl:value-of select="atom:title"/>
				<br/>
				<small><xsl:value-of select="atom:updated"/></small>
			</xsl:element>
			<xsl:element name="div">
				<xsl:attribute name="id"><xsl:value-of select="$slug-id"/></xsl:attribute>
				<xsl:attribute name="class">content</xsl:attribute>
				<h1>
					<xsl:element name="a">
						<xsl:attribute name="href"><xsl:value-of select="atom:id"/></xsl:attribute>
						<xsl:value-of select="atom:title"/>
					</xsl:element>
				</h1>
				<xsl:value-of select="atom:content" disable-output-escaping="yes" />
			</xsl:element>
		</li>
	</xsl:for-each>
</ul>

		<xsl:text disable-output-escaping="yes"><![CDATA[
		<div id="up-to-top" class="row">
  <div class="small-12 columns" style="text-align: right;">
    <a class="iconfont" href="#top-of-page">&#xf108;</a>
  </div><!-- /.small-12.columns -->
</div><!-- /.row -->


<footer id="footer-content" class="bg-grau">
  <div id="footer">
    <div class="row">
      <div class="medium-6 large-6 columns">
        <h5 class="shadow-black">About This Site</h5>
        <p class="shadow-black">
          This is the website for the academic lab of Malachi and Obi Griffith
          <a href="http://localhost:4001/">More ›</a>
        </p>
        <section id="subfooter-left" class="small-12 medium-6 columns">
          <ul class="inline-list social-icons">
          
            <li><a href="https://github.com/TheJacksonLab" target="_blank" class="fa-brands fa-github" title="Github repo for site."></a></li>
          
            <li><a href="" target="_blank" class="" title=""></a></li>
          
            <li><a href="" target="_blank" class="" title=""></a></li>
          
            <li><a href="" target="_blank" class="" title=""></a></li>
          
            <li><a href="" target="_blank" class="" title=""></a></li>
          
            <li><a href="" target="_blank" class="" title=""></a></li>
          
            <li><a href="" target="_blank" class="" title=""></a></li>
          
            <li><a href="" target="_blank" class="" title=""></a></li>
          
            <li><a href="" target="_blank" class="" title=""></a></li>
          
            <li><a href="" target="_blank" class="" title=""></a></li>
          
            <li><a href="" target="_blank" class="" title=""></a></li>
          
            <li><a href="" target="_blank" class="" title=""></a></li>
          
            <li><a href="" target="_blank" class="" title=""></a></li>
          
            <li><a href="" target="_blank" class="" title=""></a></li>
          
            <li><a href="" target="_blank" class="" title=""></a></li>
          
          </ul>
        </section>
      </div>
      <!-- /.large-6.columns -->
      <div class="medium-6 large-6 columns">
        <a href="https://chemistry.illinois.edu/"><img src="/assets/img/Illinois.png"></a>
      </div><!-- /.large-6.columns -->
    </div><!-- /.row -->
    <div class="row">
        <section id="subfooter-right" class="medium-6 large-centered columns">
          <p>Powered by <a href="http://jekyllrb.com/" target="_blank">Jekyll</a> based on the theme <a href="http://phlow.github.io/feeling-responsive/">Feeling Responsive</a>.</p>
        </section>
    </div>
  </div><!-- /#footer -->
</footer>

		


<script src="http://localhost:4001/assets/js/javascript.min.js"></script>


<script>
$(document).ready(function() {
  // Foundation should have auto-initialized, but ensure magellan-expedition is working
  if ($('[data-magellan-expedition]').length > 0) {
    // Wait for Foundation to be ready, then ensure magellan is initialized
    setTimeout(function() {
      // Check if magellan-expedition is initialized
      var expedition = $('[data-magellan-expedition]');
      expedition.each(function() {
        var $exp = $(this);
        // If not initialized, initialize it
        if (!$exp.data('magellan-expedition-init')) {
          // Try to initialize via Foundation
          try {
            $(document).foundation('magellan-expedition', 'init', $exp);
          } catch(e) {
            // If that fails, Foundation should have auto-initialized
            console.log('Magellan initialization check:', e);
          }
        }
      });
      // Force reflow and trigger events
      $(document).foundation('magellan-expedition', 'reflow');
      $(window).trigger('scroll.fndtn.magellan');
      $(window).trigger('resize.fndtn.magellan');
    }, 300);
  }
});
</script>













		]]></xsl:text>
	</body>
	</html>
</xsl:template>
<xsl:template name="slugify">
	<xsl:param name="text" select="''" />
	<xsl:variable name="dodgyChars" select="' ,.#_-!?*:;=+|&amp;/\\'" />
	<xsl:variable name="replacementChar" select="'-----------------'" />
	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	<xsl:variable name="lowercased"><xsl:value-of select="translate( $text, $uppercase, $lowercase )" /></xsl:variable>
	<xsl:variable name="escaped"><xsl:value-of select="translate( $lowercased, $dodgyChars, $replacementChar )" /></xsl:variable>
	<xsl:value-of select="$escaped" />
</xsl:template>
</xsl:stylesheet>
