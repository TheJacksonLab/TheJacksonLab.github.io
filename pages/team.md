---
layout: page-fullwidth
title: "Team"
meta_title: ""
subheadline: ""
teaser: ""
permalink: "/team/"
header:
    # Banner image uses site.background_banner from _config.yml (can override per page if needed)
---

<div data-magellan-expedition="fixed">
  <ul class="sub-nav">
    <li data-magellan-arrival="Principal_Investigator"><a href="#Principal_Investigator">P.I.</a></li>
    <li data-magellan-arrival="Postdoctoral_Researchers"><a href="#Postdoctoral_Researchers">Postdocs</a></li>
    <li data-magellan-arrival="Graduate_Students"><a href="#Graduate_Students">Grad Students</a></li>
    <li data-magellan-arrival="Undergraduate_Students"><a href="#Undergraduate_Students">Undergrad Students</a></li>
    <li data-magellan-arrival="Alumni"><a href="#Alumni">Alumni</a></li>
    <li data-magellan-arrival="Gallery"><a href="#Gallery">Gallery</a></li>
  </ul>
</div>

<h2 data-magellan-destination="Principal_Investigator">Principal Investigator</h2>
<a name="Principal_Investigator"></a>

{% include team_member
    member_name="Nick"
    full_name="Nick Jackson, PhD"
    bio="Prof. Jackson is an Assistant Professor of Chemistry at UIUC and leader of the AI for Materials Group at the Beckman Institute for Advanced Science and Technology. He obtained his B.A. in Physics from Wesleyan University, followed by a Ph.D. in Chemistry from Northwestern University, working with Prof. Mark Ratner and Prof. Lin Chen. He was subsequently a Named Fellow and Assistant Scientist in the Materials Science Division at Argonne National Laboratory, working with Prof. Juan de Pablo. His group's work at the interface of AI, molecular modeling, and soft materials chemistry has received recognition from Kavli, DOE, Cottrell, Dreyfus, AIChE COMSEF, ACS OpenEye, ACS PRF, and 3M."
    email="jacksonn@illinois.edu"
    pronouns="he/him"
    image="/assets/img/team/nick.png"
%}

<h2 data-magellan-destination="Postdoctoral_Researchers">Postdoctoral Researchers</h2>
<a name="Postdoctoral_Researchers" id="Postdoctoral_Researchers"></a>

<style>
.team-section-table {
  width: 100%;
  margin-bottom: 2rem;
  background: transparent !important;
  border-collapse: collapse;
  border: none;
  table-layout: fixed;
}
.team-section-table tr {
  background: transparent !important;
  background-color: transparent !important;
}
.team-section-table tr:nth-child(even) {
  background: transparent !important;
  background-color: transparent !important;
}
.team-section-table tr:nth-child(odd) {
  background: transparent !important;
  background-color: transparent !important;
}
.team-section-table td {
  background: transparent !important;
  background-color: transparent !important;
  border: none;
  padding: 0.75rem 0.9375rem; /* Consistent padding with content width */
  vertical-align: top;
}
.team-section-table .header-cell {
  font-weight: bold;
  padding-bottom: 1rem;
}
.team-section-table .header-cell h3 {
  margin: 0;
  font-size: 1.375rem;
}
.team-section-table .picture-cell {
  padding: 0.75rem 1rem;
  text-align: center;
}
.team-section-table .picture-cell > div {
  margin-bottom: 0;
}
.team-section-table .picture-cell .columns {
  float: none !important;
  width: 100% !important;
  margin: 0 auto;
}
.team-section-table .picture-cell .team-member-card {
  max-width: 100%;
  margin: 0 auto;
}
.team-section-table .picture-cell .team-member-card p:first-of-type {
  white-space: nowrap;
  margin-left: -0.5rem;
  margin-right: -0.5rem;
  padding-left: 0.5rem;
  padding-right: 0.5rem;
}
.team-section-table .picture-cell .team-member-card p:first-of-type b {
  display: inline-block;
  max-width: 100%;
}

/* Mini-table container - holds multiple mini-tables */
.team-mini-tables-container {
  display: flex;
  flex-wrap: wrap;
  width: 100%;
  margin-bottom: 2rem;
}

/* Each mini-table is 2 columns x 3 rows */
.team-mini-table {
  width: 50%; /* Two mini-tables per row on desktop = 4 columns total */
  display: inline-block;
  vertical-align: top;
  background: transparent !important;
  border-collapse: collapse;
  border: none;
  table-layout: fixed;
}

.team-mini-table tr {
  background: transparent !important;
}

.team-mini-table td {
  background: transparent !important;
  border: none;
  padding: 0.75rem 0.46875rem; /* Half padding: spacing between columns = 0.9375rem, spacing between mini-tables = 0.9375rem */
  vertical-align: top;
  width: 50%; /* 2 columns */
}

.team-mini-table .picture-cell {
  padding: 0.75rem 0.46875rem; /* Match td padding for consistent spacing */
  text-align: center;
}

{% if site.enable_photo_reveal %}
/* Headshot press and hold reveal */
.headshot-press {
  position: relative;
  aspect-ratio: 1 / 1;
  overflow: hidden;
  user-select: none;
  background: #111;
  border-radius: 8px;
}

.headshot-press img {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  transition: opacity 0.3s ease;
}

.headshot-press .normal {
  object-fit: cover;
  object-position: 50% 38%;
}

.headshot-press .goofy {
  object-fit: contain;
  object-position: center;
  opacity: 0;
}

.headshot-press:active .goofy {
  opacity: 1;
}

.headshot-press:active .normal {
  opacity: 0;
}

/* Disable press if card image doesn't exist */
.headshot-press.no-card {
  pointer-events: none;
}
{% endif %}
</style>

{% if site.enable_photo_reveal %}
<script>
(function() {
  // Check all goofy images after page load
  document.addEventListener('DOMContentLoaded', function() {
    var headshotPresses = document.querySelectorAll('.headshot-press');
    headshotPresses.forEach(function(headshot) {
      var goofyImg = headshot.querySelector('.goofy');
      if (goofyImg) {
        // Check if image loaded successfully
        if (goofyImg.complete) {
          // Image already loaded, check dimensions
          if (goofyImg.naturalWidth === 0 || goofyImg.naturalHeight === 0) {
            headshot.classList.add('no-card');
          }
        } else {
          // Wait for image to load or error
          goofyImg.addEventListener('load', function() {
            if (goofyImg.naturalWidth === 0 || goofyImg.naturalHeight === 0) {
              headshot.classList.add('no-card');
            }
          });
          goofyImg.addEventListener('error', function() {
            headshot.classList.add('no-card');
          });
        }
      }
    });
  });
})();
</script>
{% endif %}

<div class="team-mini-tables-container">
  <!-- Mini-table for first 2 postdocs -->
  <table class="team-mini-table">
    <!-- Row 1: Empty header row -->
    <tr>
      <td></td>
      <td></td>
    </tr>
    <!-- Row 2: Images -->
    <tr>
      <td class="picture-cell">
        {% include team_member_grid
            member_name="Katie"
            full_name="Katie Kidder"
            bio="Ph.D. Chemistry - Pennsylvania State University<br>B.A. Chemistry, Mathematics - Franklin and Marshall College"
            email="kkidder@illinois.edu"
            pronouns="she/her"
            role="Postdoctoral Associate"
            image="/assets/img/team/katie.jpg"
        %}
      </td>
      <td class="picture-cell">
        {% include team_member_grid
            member_name="Vishnu"
            full_name="Vishnu Raghuraman"
            bio="Ph.D. Physics - Carnegie Mellon University<br>B.Tech Engineering Physics - IIT Delhi"
            email="vishnura@illinois.edu"
            pronouns="he/him"
            role="Postdoctoral Associate"
            image="/assets/img/team/vishnu.jpg"
        %}
      </td>
    </tr>
  </table>
  
  <!-- Mini-table for Viviana and Hang -->
  <table class="team-mini-table">
    <!-- Row 1: Empty header row -->
    <tr>
      <td></td>
      <td></td>
    </tr>
    <!-- Row 2: Images -->
    <tr>
      <td class="picture-cell">
        {% include team_member_grid
            member_name="Viviana"
            full_name="Viviana<br>Palacio-Betancur"
            bio="Ph.D. Molecular Engineering - University of Chicago<br>B.S. Chemical Engineering and M.S. Materials Science - Universidad Nacional de Colombia Sede Medellin"
            email="vpalacio@illinois.edu"
            pronouns="she/her"
            role="Beckman Postdoctoral Fellow"
            image="/assets/img/team/viviana.jpg"
        %}
      </td>
      <td class="picture-cell">
        {% include team_member_grid
            member_name="Hang"
            full_name="Hang Zhang"
            bio="Ph.D. Chemistry - Princeton University<br>B.S. Chemistry - University of Science and Technology of China"
            email="hz118@illinois.edu"
            pronouns="he/him"
            role="Postdoctoral Associate"
            image="/assets/img/team/hang.jpg"
        %}
      </td>
    </tr>
  </table>
</div>

<hr>

<h2 data-magellan-destination="Graduate_Students">Graduate Students</h2>
<a name="Graduate_Students"></a>

<style>
/* Mini-table container - holds multiple mini-tables */
.team-mini-tables-container {
  display: flex;
  flex-wrap: wrap;
  width: 100%;
  margin-bottom: 2rem;
}

/* Each mini-table is 2 columns x 3 rows */
.team-mini-table {
  width: 50%; /* Two mini-tables per row on desktop = 4 columns total */
  display: inline-block;
  vertical-align: top;
  background: transparent !important;
  border-collapse: collapse;
  border: none;
  table-layout: fixed;
}

.team-mini-table tr {
  background: transparent !important;
}

.team-mini-table td {
  background: transparent !important;
  border: none;
  padding: 0.75rem 0.234375rem; /* Horizontal padding for spacing within columns (half of previous) */
  vertical-align: top;
  width: 50%; /* 2 columns */
}

/* Fixed height for header row to ensure alignment when tables are stacked */
.team-mini-table tr:first-child td {
  height: 3.5rem; /* Fixed height for header row, even when empty */
  min-height: 3.5rem;
  padding-top: 0;
  padding-bottom: 0;
}

.team-mini-table .header-cell {
  font-weight: bold;
  padding-bottom: 1rem;
}

.team-mini-table .header-cell h3 {
  margin: 0;
  font-size: 1.375rem;
}

.team-mini-table .picture-cell {
  padding: 0.75rem 0.46875rem; /* Match td padding for consistent spacing */
  text-align: center;
}

.team-mini-table .picture-cell > div {
  margin-bottom: 0;
}

.team-mini-table .picture-cell .columns {
  float: none !important;
  width: 100% !important;
  margin: 0 auto;
}

.team-mini-table .picture-cell .team-member-card {
  max-width: 100%;
  margin: 0 auto;
}

.team-mini-table .picture-cell .team-member-card p:first-of-type {
  white-space: nowrap;
  margin-left: -0.5rem;
  margin-right: -0.5rem;
  padding-left: 0.5rem;
  padding-right: 0.5rem;
}

.team-mini-table .picture-cell .team-member-card p:first-of-type b {
  display: inline-block;
  max-width: 100%;
}

/* Allow breaking for names with <wbr> tags - override nowrap */
.team-mini-table .picture-cell .team-member-card p:first-of-type:has(wbr) {
  white-space: normal !important;
}

/* Also apply to regular team-section-table for postdocs */
.team-section-table .picture-cell .team-member-card p:first-of-type:has(wbr) {
  white-space: normal !important;
}

/* Mobile: Stack mini-tables vertically and center them */
@media only screen and (max-width: 40em) {
  .team-mini-tables-container {
    display: block;
  }
  
  .team-mini-table {
    width: 100% !important;
    display: block;
    margin: 0 auto 1rem auto; /* Center with equal margins */
    max-width: 100%;
    box-sizing: border-box;
  }
  
  /* Reduce cell width to 45% each to prevent horizontal scroll on mobile */
  .team-mini-table td {
    width: 45% !important;
    padding: 0.5rem !important;
    box-sizing: border-box;
  }
  
  .team-mini-table .picture-cell {
    width: 45% !important;
    padding: 0.5rem !important;
    box-sizing: border-box;
  }
}
</style>

<div class="team-mini-tables-container">
  <!-- Mini-table for G5 (2 members) -->
  <table class="team-mini-table">
    <!-- Row 1: Header, empty -->
    <tr>
      <td class="header-cell">
        <h3 data-magellan-destination="G5">G5</h3>
        <a name="G5"></a>
      </td>
      <td></td>
    </tr>
    <!-- Row 2: Images -->
    <tr>
      <td class="picture-cell">
        {% include team_member_grid
            member_name="Seonghwan"
            full_name="Seonghwan Kim"
            bio="B.S. Physics - Seoul National University"
            email="sk77@illinois.edu"
            pronouns="he/him"
            image="/assets/img/team/seonghwan.jpg"
            role="Co-advised with Prof. Schroeder"
        %}
      </td>
      <td class="picture-cell">
        {% include team_member_grid
            member_name="Archana"
            full_name="Archana Verma"
            bio="B.S. Chemical Engineering - Stanford University"
            email="archana3@illinois.edu"
            pronouns="she/her"
            image="/assets/img/team/archana.jpeg"
            role=""
        %}
      </td>
    </tr>
  </table>
  
  <!-- Mini-table for G4 (1 member) -->
  <table class="team-mini-table">
    <!-- Row 1: Header, empty -->
    <tr>
      <td class="header-cell">
        <h3 data-magellan-destination="G4">G4</h3>
        <a name="G4"></a>
      </td>
      <td></td>
    </tr>
    <!-- Row 2: Image, empty -->
    <tr>
      <td class="picture-cell">
        {% include team_member_grid
            member_name="Shurit"
            full_name="Shruti Iyer"
            bio="Integrated M.S. Chemistry - Pirla Institute of Technology and Science, Pilani"
            email="shrutii2@illinois.edu"
            pronouns="she/her"
            image="/assets/img/team/shruti.jpeg"
            role=""
        %}
      </td>
      <td></td>
    </tr>
  </table>
  
  <!-- Mini-table for G3 (3 members - first 2 in one table, third in another) -->
  <table class="team-mini-table">
    <!-- Row 1: Header, empty -->
    <tr>
      <td class="header-cell">
        <h3 data-magellan-destination="G3">G3</h3>
        <a name="G3"></a>
      </td>
      <td></td>
    </tr>
    <!-- Row 2: Images -->
    <tr>
      <td class="picture-cell">
        {% include team_member_grid
            member_name="Anna"
            full_name="Anna DeBernardo"
            bio="B.S. Chemistry, Mathematics - Case Western Reserve University"
            email="ad60@illinois.edu"
            pronouns="she/her"
            image="/assets/img/team/anna.jpg"
            role=""
        %}
      </td>
      <td class="picture-cell">
        {% include team_member_grid
            member_name="Huihang"
            full_name="Huihang Qiu"
            bio="M.S. Chemical Engineering - University of Tokyo<br>B.S. Chemistry - Shanghai Jiao Tong University"
            email="huihang2@illinois.edu"
            pronouns="he/him"
            image="/assets/img/team/huihang.jpg"
            role=""
        %}
      </td>
    </tr>
  </table>
  
  <!-- Mini-table for G3 continued (3rd member) -->
  <table class="team-mini-table">
    <!-- Row 1: Empty header row -->
    <tr>
      <td></td>
      <td></td>
    </tr>
    <!-- Row 2: Image, empty -->
    <tr>
      <td class="picture-cell">
        {% include team_member_grid
            member_name="Jason"
            full_name="Jason Wu"
            bio="B.S. Chemistry, B.A. Computer Science - Boston College"
            email="jw5235@princeton.edu"
            pronouns="he/him"
            image="/assets/img/team/jason.jpg"
            role="Chemistry at Princeton University<br>Co-advised with Prof. Schroeder"
        %}
      </td>
      <td></td>
    </tr>
  </table>
  
  <!-- Mini-table for G2 (3 members - first 2 in one table, third in another) -->
  <table class="team-mini-table">
    <!-- Row 1: Header, empty -->
    <tr>
      <td class="header-cell">
        <h3 data-magellan-destination="G2">G2</h3>
        <a name="G2"></a>
      </td>
      <td></td>
    </tr>
    <!-- Row 2: Images -->
    <tr>
      <td class="picture-cell">
        {% include team_member_grid
            member_name="Eliza"
            full_name="Eliza Asani"
            bio="B.S. Chemistry, Computer Science - The University of Alabama in Huntsville"
            email="elizaa2@illinois.edu"
            pronouns="she/her"
            image="/assets/img/team/eliza.jpg"
            role=""
        %}
      </td>
      <td class="picture-cell">
        {% include team_member_grid
            member_name="Jingdan"
            full_name="Jingdan Chen"
            bio="B.S. Chemistry - Wuhan University"
            email="jingdan2@illinois.edu"
            pronouns="he/him"
            image="/assets/img/team/jingdan.jpeg"
            role=""
        %}
      </td>
    </tr>
  </table>
  
  <!-- Mini-table for G2 continued (3rd member) -->
  <table class="team-mini-table">
    <!-- Row 1: Empty header row -->
    <tr>
      <td></td>
      <td></td>
    </tr>
    <!-- Row 2: Image, empty -->
    <tr>
      <td class="picture-cell">
        {% include team_member_grid
            member_name="Matthew"
            full_name="Matthew Too"
            bio="B.S. Biochemistry, Mathematics - State University of New York Brockport"
            email="mtoo2@illinois.edu"
            pronouns="he/him"
            image="/assets/img/team/matthew.jpg"
            role=""
        %}
      </td>
      <td></td>
    </tr>
  </table>
  
  <!-- Mini-table for G1 (empty for now) -->
  <table class="team-mini-table">
    <!-- Row 1: Header, empty -->
    <tr>
      <td class="header-cell">
        <h3 data-magellan-destination="G1">G1</h3>
        <a name="G1"></a>
      </td>
      <td></td>
    </tr>
    <!-- Row 2: Empty for now -->
    <tr>
      <td></td>
      <td></td>
    </tr>
  </table>
</div>

<hr>

<h2 data-magellan-destination="Undergraduate_Students">Undergraduate Students</h2>
<a name="Undergraduate_Students"></a>

<div class="team-mini-tables-container">
  <!-- Mini-table for undergraduate students -->
  <table class="team-mini-table">
    <!-- Row 1: Empty header row -->
    <tr>
      <td></td>
      <td></td>
    </tr>
    <!-- Row 2: Images -->
    <tr>
      <td class="picture-cell">
        {% include team_member_grid
            member_name="Reesa"
            full_name="Reesa Espera"
            bio="ChBE - Expected '26"
            email="respera2@illinois.edu"
            pronouns="she/her"
            image="/assets/img/team/reesa.jpg"
        %}
      </td>
      <td class="picture-cell">
        {% include team_member_grid
            member_name="Isaac"
            full_name="Isaac Christensen"
            bio="CS and Chemistry - Expected '26"
            email="ichri2@illinois.edu"
            pronouns="he/him"
            image="/assets/img/team/isaac.jpeg"
        %}
      </td>
    </tr>
  </table>
</div>

<hr>

<h2 data-magellan-destination="Alumni">Alumni</h2>
<a name="Alumni"></a>

<style>
/* Scrollable wrapper for alumni tables on mobile */
.alumni-table-wrapper {
  width: 100%;
  margin-bottom: 2rem;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

.alumni-table {
  width: 100%;
  min-width: 600px; /* Minimum width to prevent collapse */
  margin-bottom: 0;
  background: transparent !important;
  border-collapse: collapse;
  border: none;
  table-layout: fixed;
}

.alumni-table tr {
  background: transparent !important;
  background-color: transparent !important;
}

.alumni-table tr:nth-child(even) {
  background: transparent !important;
  background-color: transparent !important;
}

.alumni-table tr:nth-child(odd) {
  background: transparent !important;
  background-color: transparent !important;
}

.alumni-table td {
  background: transparent !important;
  background-color: transparent !important;
  border: none;
  border-bottom: 1px solid rgba(61, 64, 91, 0.1);
  padding: 0.75rem 1rem;
}

.alumni-table td:first-child {
  width: 15%; /* Reduced from 25% */
  white-space: nowrap; /* Keep on single line */
}

.alumni-table td:nth-child(2) {
  width: 30%; /* Increased from 20% (added 10% from first column) */
  white-space: nowrap; /* Keep on single line */
}

.alumni-table td:nth-child(3) {
  width: 55%; /* Unchanged */
  white-space: nowrap; /* Keep on single line */
  overflow: hidden;
  text-overflow: ellipsis; /* Add ellipsis if text is too long */
}

.alumni-table tr:last-child td {
  border-bottom: none;
}

/* Mobile styles - ensure table is scrollable */
@media only screen and (max-width: 40em) {
  .alumni-table-wrapper {
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
    margin-left: -0.9375rem;
    margin-right: -0.9375rem;
    padding-left: 0.9375rem;
    padding-right: 0.9375rem;
  }
  
  .alumni-table {
    min-width: 600px; /* Ensure table maintains minimum width on mobile */
    width: auto;
  }
  
  .alumni-table td:nth-child(3) {
    overflow: visible; /* Allow full text to be visible when scrolling */
    text-overflow: clip;
  }
}
</style>

<h3>Graduate Students</h3>
<div class="alumni-table-wrapper">
  <table class="alumni-table">
    <tr>
      <td>Charlie Maier</td>
      <td>PhD Physics 2020-2025</td>
      <td>SAI Postdoctoral Fellow at Notre Dame with Prof. Brett Savoie</td>
    </tr>
    <tr>
      <td>David Friday</td>
      <td>PhD Chemistry 2020-2025</td>
      <td>Advisor, Scientific Computing – Bioproduct Research and Development, Lilly</td>
    </tr>
  </table>
</div>

<h3>Postdocs</h3>
<div class="alumni-table-wrapper">
  <table class="alumni-table">
    <tr>
      <td>Chun-I Wang</td>
      <td>PD 2021-2024</td>
      <td>Assistant Professor at CUNY Lehman College</td>
    </tr>
    <tr>
      <td>Zheng Yu</td>
      <td>PD 2022-2024</td>
      <td>CSI Fellow at Princeton University</td>
    </tr>
  </table>
</div>

<h3>Undergraduates</h3>
<div class="alumni-table-wrapper">
  <table class="alumni-table">
    <tr>
      <td>Zylle Constantino</td>
      <td>UG 2024-2025</td>
      <td>UG Researcher in Su Group</td>
    </tr>
    <tr>
      <td>Sofia Sivilotti</td>
      <td>UG 2023-2025</td>
      <td>Technical Implementation Associate at Uncountable</td>
    </tr>
    <tr>
      <td>Aidan Lindsay</td>
      <td>UG 2023-2025</td>
      <td>Ph.D program in Chemistry at the University of Chicago</td>
    </tr>
    <tr>
      <td>Andriy Bilobokyy</td>
      <td>UG 2023</td>
      <td>Associate Software Engineer I at Northrop Grumman</td>
    </tr>
    <tr>
      <td>Andrew Qin</td>
      <td>UG 2022-2023</td>
      <td>Ph.D program in Computer Science at Courant Institute, New York University</td>
    </tr>
    <tr>
      <td>Rohini Ramabadran</td>
      <td>UG 2021</td>
      <td>Software Engineer at SeatGeek</td>
    </tr>
  </table>
</div>

<h2 data-magellan-destination="Gallery">Gallery</h2>
<a name="Gallery"></a>

<p style="text-align: center; margin-top: 2rem;">
  <a href="{{ site.url }}{{ site.baseurl }}/team/gallery/">View Team Gallery →</a>
</p>
