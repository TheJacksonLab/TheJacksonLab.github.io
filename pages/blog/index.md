---
layout: none
title: ""
permalink: /nicks_blog/
---

<link rel="stylesheet" href="{{ site.url }}{{ site.baseurl }}/assets/css/nicks_blog.css">

<div id="page">
<!-- optional, early-2000s vibe -->
<marquee class="color-letters" scrollamount="2">(just a place to put things)</marquee>

<div class="home-link">
  <a href="{{ site.url }}{{ site.baseurl }}/">← Home</a>
</div>

<div class="header-with-audio">
  <h1 class="color-letters"> Nick's Blog</h1>
  <div class="audio-widget">
    <audio controls preload="metadata">
      <source src="{{ site.url }}{{ site.baseurl }}/assets/scruggs_earls_breakdown.mp3" type="audio/mpeg">
      (audio player didn't load?)
    </audio>
  </div>
</div>

<div>
  {% assign notes = site.nicks_blog %}
  
  {%- comment -%} reverse if you want newest first {%- endcomment -%}
  {% assign notes = notes | reverse %}
  
  {%- for note in notes -%}
    <div class="post-entry">
      {%- if note.date -%}
        <div class="post-timestamp">{{ note.date | date: "%B %d, %Y" }}</div>
      {%- endif -%}
      
      {%- if note.title and note.title != "" -%}
        <h2>{{ note.title }}</h2>
      {%- endif -%}
      
      {{ note.content }}
      
      <hr>
    </div>
  {%- endfor -%}
</div>
</div>

<script>
(function() {
  // Function to wrap each word in a span
  function wrapWords(element) {
    if (!element) return;
    var text = element.textContent;
    // Split by whitespace to get words, preserving the text
    var words = text.trim().split(/\s+/);
    var wrapped = '';
    for (var i = 0; i < words.length; i++) {
      if (words[i]) {
        wrapped += '<span>' + words[i] + '</span>';
        if (i < words.length - 1) {
          wrapped += ' '; // Add space between words
        }
      }
    }
    element.innerHTML = wrapped;
  }
  
  // Wrap words when DOM is ready
  document.addEventListener('DOMContentLoaded', function() {
    var title = document.querySelector('.header-with-audio h1.color-letters');
    var marquee = document.querySelector('marquee.color-letters');
    
    if (title) wrapWords(title);
    if (marquee) wrapWords(marquee);
  });
})();
</script>

