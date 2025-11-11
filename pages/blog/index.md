---
layout: none
title: ""
permalink: /nicks_blog/
---

<link rel="stylesheet" href="{{ site.url }}{{ site.baseurl }}/assets/css/nicks_blog.css">

<!-- optional, early-2000s vibe -->
<marquee scrollamount="2">(just a place to put things)</marquee>

<div class="home-link">
  <a href="{{ site.url }}{{ site.baseurl }}/">← Home</a>
</div>

<div class="header-with-audio">
  <h1> Nick's Blog</h1>
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

