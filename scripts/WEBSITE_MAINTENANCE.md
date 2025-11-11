# Website Maintenance Guide

This guide provides step-by-step instructions for common website maintenance tasks.

## Table of Contents
1. [Adding a New News Post](#adding-a-new-news-post)
2. [Adding a New Page](#adding-a-new-page)
3. [Adding a New Team Member](#adding-a-new-team-member)

For styling instructions (fonts, colors, hover effects), see [WEBSITE_STYLE.md](WEBSITE_STYLE.md).

For gallery maintenance instructions, see [WEBSITE_GALLERY.md](WEBSITE_GALLERY.md).

---

## Adding a New News Post

News posts are stored in the `_posts/` directory and follow Jekyll's naming convention.

### Steps:

1. **Create a new file** in `_posts/` directory with the naming format:
   ```
   YYYY-MM-DD-title-with-hyphens.md
   ```
   Example: `2025-11-15-lab-meeting-november.md`

2. **Add front matter** at the top of the file:
   ```yaml
   ---
   layout: page
   title: "Your News Title"
   teaser: "Brief description that appears in news listings"
   header:
       image_fullwidth: "genvis-dna-bg_optimized_v1a.png"
   breadcrumb: true
   ---
   ```

3. **Add your content** below the front matter:
   ```markdown
   Your news content goes here. You can use markdown formatting.
   
   - Bullet points
   - More information
   ```

4. **File locations:**
   - News posts: `_posts/YYYY-MM-DD-title.md`
   - Example: `_posts/2025-11-15-lab-meeting-november.md`

### Example:

```markdown
---
layout: page
title: "Lab Meeting November 2025"
teaser: "Monthly lab meeting discussion topics"
header:
    image_fullwidth: "genvis-dna-bg_optimized_v1a.png"
breadcrumb: true
---

November 2025 – This month's lab meeting covered new research directions and upcoming conference presentations.
```

---

## Adding a New Page

Pages are stored in the `pages/` directory and can be added to the navigation menu.

### Steps:

1. **Create a new file** in `pages/` directory:
   ```
   your-page-name.md
   ```
   Example: `teaching.md`, `resources.md`

2. **Add front matter** with required fields:
   ```yaml
   ---
   layout: page-fullwidth
   title: "Page Title"
   meta_title: ""
   subheadline: ""
   teaser: ""
   permalink: "/your-url-path/"
   header:
       image_fullwidth: "genvis-dna-bg_optimized_v1a.png"
   ---
   ```

3. **Add optional Magellan navigation** (for pages with multiple sections):
   ```html
   <div data-magellan-expedition="fixed">
     <ul class="sub-nav">
       <li data-magellan-arrival="Section1"><a href="#Section1">Section 1</a></li>
       <li data-magellan-arrival="Section2"><a href="#Section2">Section 2</a></li>
     </ul>
   </div>
   ```

4. **Add content sections** with anchors:
   ```html
   <h2 data-magellan-destination="Section1">Section 1</h2>
   <a name="Section1"></a>
   
   Your content here...
   ```

5. **Add to navigation menu** (optional):
   - Edit `_data/navigation.yml`
   - Add entry:
     ```yaml
     - title: Your Page Title
       url: "/your-url-path/"
       side: left
     ```

6. **File locations:**
   - Page file: `pages/your-page-name.md`
   - Navigation config: `_data/navigation.yml`

### Example:

```markdown
---
layout: page-fullwidth
title: "Teaching"
meta_title: ""
subheadline: ""
teaser: ""
permalink: "/teaching/"
header:
    image_fullwidth: "genvis-dna-bg_optimized_v1a.png"
---

Your page content here.
```

---

## Adding a New Team Member

Team members are added to `pages/team.md` and their social media links are stored in `_data/socialmedia.yml`.

### Steps:

1. **Add team member image** to `assets/img/team/`:
   - File name: `member-name.jpg` or `member-name.png`
   - Recommended size: Square format (e.g., 200x200px or larger)
   - The image will be automatically cropped to a square with rounded corners

2. **Add team member entry** to `pages/team.md`:
   
   **For Principal Investigator** (only one):
   ```liquid
   {% include team_member
       member_name="MemberName"
       full_name="Full Name, PhD"
       bio="Bio information here. Use <br> for line breaks."
       email="email@illinois.edu"
       pronouns="he/him"
       image="/assets/img/team/member-name.jpg"
   %}
   ```
   
   **For other team members** (Postdocs, Graduate Students, Undergraduates):
   ```liquid
   {% include team_member_grid
       member_name="MemberName"
       full_name="Full Name"
       bio="B.S. Degree - University<br>Additional info"
       email="email@illinois.edu"
       pronouns="she/her"
       role="G5"  # Optional: e.g., "G5", "Postdoctoral Associate", etc.
       image="/assets/img/team/member-name.jpg"
   %}
   ```

3. **Add social media links** (optional) to `_data/socialmedia.yml`:
   ```yaml
   - member_name: MemberName
     social:
     - name: GitHub
       url: https://github.com/username
       class: fa-brands fa-github
       title: "GitHub Profile"
     - name: LinkedIn
       url: https://www.linkedin.com/in/username
       class: fa-brands fa-linkedin
       title: "LinkedIn Profile"
     - name: Google Scholar
       url: https://scholar.google.com/citations?user=USERID
       class: fa-solid fa-graduation-cap
       title: "Google Scholar"
     - name: Website
       url: https://example.com
       class: fa-solid fa-globe
       title: "Website"
   ```

4. **Place team member in appropriate section**:
   - **Principal Investigator**: Use `team_member` include (appears first, left-image layout)
   - **Postdoctoral Researchers**: Add to "Postdoctoral Researchers" section, use `team_member_grid` include
   - **Graduate Students**: Add to appropriate G* subsection (G5, G4, G3, G2, G1), use `team_member_grid` include
   - **Undergraduate Students**: Add to "Undergraduate Students" section, use `team_member_grid` include

5. **Maintain grid layout**:
   - Team members are displayed in a 4-column grid
   - If a row has fewer than 4 members, add empty placeholder divs:
     ```html
     <div class="small-12 medium-6 large-3 columns"></div>
     ```
   - Ensure each row is wrapped in `<div class="row">` tags

6. **File locations:**
   - Team page: `pages/team.md`
   - Team images: `assets/img/team/member-name.jpg`
   - Social media config: `_data/socialmedia.yml`

### Example: Adding a Graduate Student

**Step 1:** Add image to `assets/img/team/john.jpg`

**Step 2:** Add to `pages/team.md` in the appropriate G* section:
```liquid
{% include team_member_grid
    member_name="John"
    full_name="John Doe"
    bio="B.S. Chemistry - University of Illinois<br>Research interests: computational chemistry"
    email="johndoe@illinois.edu"
    pronouns="he/him"
    role="G3"
    image="/assets/img/team/john.jpg"
%}
```

**Step 3:** Add social media to `_data/socialmedia.yml`:
```yaml
- member_name: John
  social:
  - name: GitHub
    url: https://github.com/johndoe
    class: fa-brands fa-github
    title: "GitHub Profile"
```

### Available Font Awesome Icons:

Common icon classes for social media:
- GitHub: `fa-brands fa-github`
- LinkedIn: `fa-brands fa-linkedin`
- Google Scholar: `fa-solid fa-graduation-cap`
- ORCiD: `fa-brands fa-orcid`
- Website: `fa-solid fa-globe`
- Twitter/X: `fa-brands fa-twitter`
- Email: `fa-solid fa-envelope`

See [Font Awesome 6.2.0 icons](https://fontawesome.com/v6/icons) for more options.

---

## Notes

- After making changes, rebuild the site: `bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch`
- On Apple Silicon Macs, use: `arch -x86_64 bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch`
- Always test locally before pushing changes
- Use consistent naming conventions (lowercase with hyphens for files)
- Images should be optimized before uploading

