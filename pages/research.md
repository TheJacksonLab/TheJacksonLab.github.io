---
layout: page-fullwidth
title: "Research"
meta_title: ""
subheadline: ""
teaser: ""
permalink: "/research/"
header:
    # Banner image uses site.background_banner from _config.yml (can override per page if needed)
---

<style>
.research-section-heading {
  margin-top: 1.25rem;
  margin-bottom: 1rem;
}

.project-divider {
  margin-top: 1.25rem;
  margin-bottom: 0;
}

.project-divider + .research-section-heading {
  margin-top: 1rem;
}
</style>

<div data-magellan-expedition="fixed">
  <ul class="sub-nav">
    <li data-magellan-arrival="Overview"><a href="#Overview">Overview</a></li>
    <li data-magellan-arrival="Electronic_Coarse_Graining"><a href="#Electronic_Coarse_Graining">Electronic Coarse-Graining</a></li>
    <li data-magellan-arrival="AIGuided_Soft_Materials_Design"><a href="#AIGuided_Soft_Materials_Design">AI for Soft Materials</a></li>
    <li data-magellan-arrival="Doping_Mixed_Conduction_Organic_Semiconductors"><a href="#Doping_Mixed_Conduction_Organic_Semiconductors">Organic Electronics Theory</a></li>
    <li data-magellan-arrival="Comp_Resources"><a href="#Comp_Resources">Resources</a></li>
    <li data-magellan-arrival="Funding"><a href="#Funding">Funding</a></li>
    
  </ul>
</div>

<h2 class="research-section-heading" data-magellan-destination="Overview" id="Overview">Overview</h2>
The Jackson Lab models electronic processes (e.g. reactivity, conductivity, optical properties) in soft materials (e.g. polymers, liquid crystals, glasses) using AI and molecular modeling. There is a strong effort devoted to method developments that enable electronic predictions in disordered systems using physics-based modeling and AI.

Two good introductions to the broad themes and interests of the group can be found here:
- [A Quantum Mechanical Frontier for Polymer Science.](https://www.acs.org/meetings/acs-meetings/past-meetings/kavli-lecture-series/quantum-mechanical-frontier.html) Kavli Emerging Leader in Chemistry Lecture at <em>ACS Spring Meeting</em> <strong>2025</strong>.
- Perspective Article: Wang, C.-I.; Jackson, N.E.<sup>*</sup> [Bringing Quantum Mechanics to Coarse-Grained Soft Materials Modeling.](https://pubs.acs.org/doi/10.1021/acs.chemmater.2c03712) <em>Chem. Mater.</em> <strong>2023</strong>, 35, 4, 1470-1486.

<h2 class="research-section-heading" data-magellan-destination="Electronic_Coarse_Graining" id="Electronic_Coarse_Graining">Electronic Coarse-Graining: Quantum Mechanics Beyond Atomic Resolution</h2>

{% include project
  title=""
  description="Nearly every method in quantum chemistry inherits a single assumption — that all atomic positions must be specified before anything can be said about the electrons. That requirement is why simulating even a nanometer chunk of a plastic solar cell or a battery electrode can consume a supercomputer, and why materials whose usefulness depends on quantum mechanical behavior remain difficult to design rather than discover by trial and error. Our group is developing a different approach called Electronic Coarse-Graining, in which the electronic behavior of a material is predicted directly from a simplified, lower-resolution description that leaves out most of the atomic detail to make calculations dramatically cheaper. Building these methods requires integrating ideas from quantum mechanics, statistical mechanics, and machine learning. If successful, calculations that are currently impossible become routine, opening up the design of soft electronic materials at the length scales where they actually operate."

  image="/assets/img/research/ECG_Logo_2.png"

%}

<h2 class="research-section-heading" data-magellan-destination="AIGuided_Soft_Materials_Design" id="AIGuided_Soft_Materials_Design">AI for Soft Materials</h2>


{% include project
  title=""

  description="Artificial intelligence has reshaped fields where data are plentiful and the goal is easy to state. Soft materials chemistry is neither: the molecules are large, defective, and flexible, the properties we care about emerge only from collective behavior, and the space of possible chemistries is enormous but constrained by what a chemist can actually synthesize. We develop both forward and inverse AI approaches designed around those realities. In the forward direction, we build models that predict complex behavior from molecular structure. In the inverse direction, we work backward from a desired property to the molecules that could deliver it, searching not the space of everything imaginable but the smaller space of what is actually reachable through known chemistry from available starting materials. Together these efforts aim to shorten the path from an idea for a soft material to a specific chemical reaction worth performing."

  image="/assets/img/research/CLT.png"

%}

<h2 class="research-section-heading" data-magellan-destination="Doping_Mixed_Conduction_Organic_Semiconductors" id="Doping_Mixed_Conduction_Organic_Semiconductors">Organic Electronics Theory</h2>

{% include project
  title=""

  description="Semiconducting molecules and polymers combine the mechanical and thermophysical advantages of soft materials with optoelectronic functionality common to inorganic semiconductors (e.g. Silicon, GaAs).  In recent years, the application of these materials classes in biological systems as signal transducers at neural interfaces has emerged.  To design materials for these systems requires the challenging multiscale prediction of morphological structure, electronic conductivity, and ionic conductivity.  Our research goal is to develop computational models capable of efficiently describing the strong coupling between electronic, ionic, and mesoscopic degrees of freedom in organic materials and to use these models to understand the fundamental tradeoffs between electronic and ionic conductivity in polymeric materials. "

  image="/assets/img/research/MixedConduction-1200x696.png"

%}

<h2 class="research-section-heading" data-magellan-destination="Comp_Resources" id="Comp_Resources">Computational Resources</h2>

We benefit from the many computational resources on campus. Primarily, we use our private group cluster, “scruggs”, and the community cluster, [lop](https://answers.uillinois.edu/scs/scs-clusters), run out of the School of Chemical Sciences. If further resources are required, we utilize NCSA clusters [Delta](https://www.ncsa.illinois.edu/research/project-highlights/delta/) and [Hal](https://wiki.ncsa.illinois.edu/display/ISL20/HAL+cluster ) or resources nearby at Argonne National Laboratory.


<h2 class="research-section-heading" data-magellan-destination="Funding" id="Funding">Funding</h2>

We are very thankful for generous support from the following research sponsors.

<img src="/assets/img/funding/FundingLogo_070125.png" alt="Funding Logos" style="width: 100%; max-width: 100%; height: auto;">
