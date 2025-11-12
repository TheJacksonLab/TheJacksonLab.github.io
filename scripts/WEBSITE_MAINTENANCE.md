# Website Maintenance Guide

Step-by-step instructions for common website maintenance tasks.

## Table of Contents

1. [Automated Tasks (GitHub Actions)](#automated-tasks-github-actions)
2. [Creating a New Page](#creating-a-new-page)
3. [Manual Instructions](#manual-instructions)

For styling instructions, see [WEBSITE_STYLE.md](WEBSITE_STYLE.md).

For gallery maintenance instructions, see [WEBSITE_GALLERY.md](WEBSITE_GALLERY.md).

---

## Automated Tasks (GitHub Actions)

The website uses **GitHub Actions workflows** to automatically build and deploy when you make changes. You only need to edit files and push to GitHub - the workflows handle the rest.

### How It Works

- **`web_test` branch**: Staging environment for testing changes
- **`main` branch**: Production environment (stable, deployed to live site)
- **Workflow process**: Edit files → Push to `web_test` → Review staging → Merge to `main` → Production updates

### 1. Updating Publications

**Workflow**: `auto-update-refs.yml`

**What you do**: Edit BibTeX files

**What happens automatically**:

- `pages/publications.md` is regenerated from BibTeX files
- Site builds and deploys to staging/production

**Files to edit**:

- `assets/jackson_preprints.bib` (appears in "Submitted" section)
- `assets/jackson_old_pubs.bib` (appears in "Prior to UIUC" section)
- `assets/jackson_pubs.bib` (classified by year, 2021+)

**Example**:

```bash
# Edit the BibTeX file
vim assets/jackson_pubs.bib

# Add your entry, then commit and push
git add assets/jackson_pubs.bib
git commit -m "Add new publication"
git push origin web_test
```

**See also**: [update_pubs.md](update_pubs.md) for detailed BibTeX format requirements.

---

### 2. Adding News Posts

**Workflow**: `auto-update-news.yml`

**What you do**: Create a new markdown file in `_posts/`

**What happens automatically**:

- Images from the post are automatically added to the team gallery
- Images are renamed with date prefix (YYYY-MM-DD-filename.ext)
- Gallery is updated and sorted chronologically
- Site builds and deploys

**File naming**: `YYYY-MM-DD-title-with-hyphens.md`

**Example**:

```markdown
---
layout: page
title: "Lab Meeting November 2025"
teaser: "Monthly lab meeting discussion topics"
header:
    image_fullwidth: "genvis-dna-bg_optimized_v1a.png"
breadcrumb: true
---

November 2025 - This month's lab meeting covered new research directions.

![Lab photo](/assets/img/gallery/2025-11-15-lab-photo.jpg)
```

**Image naming tip**: Name images with the same date prefix as the post (e.g., `2025-11-15-lab-photo.jpg` for post `2025-11-15-lab-meeting.md`) to ensure smooth automatic processing.

**Commit and push**:

```bash
git add _posts/2025-11-15-lab-meeting-november.md
git commit -m "Add news post: Lab Meeting November 2025"
git push origin web_test
```

---

### 3. Adding Blog Posts

**Workflow**: `auto-update-blog.yml`

**What you do**: Create a new markdown file in `_nicks_blog/`

**What happens automatically**:

- Site builds and deploys with the new blog post

**Example**:

```markdown
---
title: "My Blog Post Title"
date: 2025-11-15
---

Your blog content here.
```

**Commit and push**:

```bash
git add _nicks_blog/2025-11-15-my-post.md
git commit -m "Add blog post"
git push origin web_test
```

---

### 4. Adding Team Members

**Workflow**: `auto-update-team.yml`

**What you do**:

1. Add image to `assets/img/team/`
2. Add team member entry to `pages/team.md`
3. Add social media links to `_data/socialmedia.yml`

**What happens automatically**:

- Site builds and deploys

**Example - Graduate Student**:

1. Add image: `assets/img/team/john.jpg`

2. Add to `pages/team.md` in desired location:

   ```liquid
   {% include team_member_grid
    member_name="John"
    full_name="John Doe"
    bio="B.S. Chemistry - University of Illinois<br>B.A. ..."
    email="johndoe@illinois.edu"
    pronouns="he/him"
    role="Additional details: fellowship, coadvised..."
    image="/assets/img/team/john.jpg"
    %}
   ```

3. Add to `_data/socialmedia.yml`:

   ```yaml
   - member_name: John
     social:
       - name: GitHub
         url: https://github.com/johndoe
         class: fa-brands fa-github
         title: "GitHub Profile"
   ```

**Placement control**: You have full control over where team members appear. Place the `{% include team_member_grid %}` statement in the desired table cell position within the appropriate section (Postdocs, G5, G4, G3, G2, G1, Undergraduates).

**Commit and push**:

```bash
git add pages/team.md _data/socialmedia.yml assets/img/team/john.jpg
git commit -m "Add new team member: John Doe"
git push origin web_test
```

**Available Font Awesome icons**: `fa-brands fa-github`, `fa-brands fa-linkedin`, `fa-solid fa-graduation-cap`, `fa-brands fa-orcid`, `fa-solid fa-globe`, `fa-brands fa-twitter`, `fa-solid fa-envelope`. See [Font Awesome 6.2.0 icons](https://fontawesome.com/v6/icons) for more.

---

## Creating a New Page

Pages are stored in the `pages/` directory and can be added to the navigation menu.

### Steps

1. **Create a new file** in `pages/` directory:

   ```text
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

6. **File locations**:

   - Page file: `pages/your-page-name.md`
   - Navigation config: `_data/navigation.yml`

### Example

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

## Manual Instructions

### Running Scripts Manually

#### Gallery Update Script

If you need to update the gallery manually (e.g., to test locally):

```bash
# Basic usage
ruby scripts/news_to_gallery.rb

# Or specify a custom gallery file
ruby scripts/news_to_gallery.rb pages/team-gallery.md
```

**On Apple Silicon (ARM64) Macs**:

```bash
arch -x86_64 ruby scripts/news_to_gallery.rb
```

**What the script does**:

- Scans all posts in `_posts/` directory
- Finds images in post front matter or embedded in content
- Checks if images already exist in the gallery (skips duplicates)
- Copies images to `assets/img/gallery/` if they're in other locations
- Adds new images to `pages/team-gallery.md` with auto-generated captions
- Sorts all gallery images chronologically by date
- Updates the gallery file in place

**After running manually**:

```bash
git add pages/team-gallery.md assets/img/gallery/
git commit -m "Update gallery from news posts"
```

#### Publications Generation Script

If you need to regenerate publications manually:

```bash
# Generate publications page
arch -x86_64 bundle exec ruby scripts/bibtex_to_publications.rb

# Or with custom file paths
arch -x86_64 bundle exec ruby scripts/bibtex_to_publications.rb \
  assets/jackson_preprints.bib \
  assets/jackson_old_pubs.bib \
  assets/jackson_pubs.bib \
  pages/publications.md
```

**Note**: On Apple Silicon (ARM64) Macs, use `arch -x86_64` prefix for compatibility.

### Local Development

**Build and serve locally**:

```bash
bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch
```

**On Apple Silicon Macs**:

```bash
arch -x86_64 bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch
```

### GitHub Environments Setup

The workflows use two GitHub environments:

1. **`staging`**: For `web_test` branch deployments
   - Go to: Repository → Settings → Environments
   - Create new environment: `staging`
   - Optional: Add protection rules (e.g., require approval)

2. **`github-pages`**: For `main` branch deployments (usually auto-created)
   - This is the production environment
   - Should already exist if GitHub Pages is enabled

### Troubleshooting

- **Workflow not running?**: Check that you pushed to the correct branch (`web_test` or `main`)
- **Build failing?**: Check the Actions tab in GitHub for error messages
- **Publications not updating?**: Verify BibTeX syntax is correct (see [update_pubs.md](update_pubs.md))
- **Staging not deploying?**: Ensure the `staging` environment exists in repository settings

### General Notes

- Always test locally before pushing changes
- Use consistent naming conventions (lowercase with hyphens for files)
- Images should be optimized before uploading
- After making changes, rebuild the site locally to verify
