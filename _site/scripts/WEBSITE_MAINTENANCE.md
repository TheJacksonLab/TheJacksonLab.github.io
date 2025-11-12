# Website Maintenance Guide

Step-by-step instructions for common website maintenance tasks.

## Table of Contents

1. [Adding a New News Post](#adding-a-new-news-post)
2. [Adding a New Page](#adding-a-new-page)
3. [Adding a New Team Member](#adding-a-new-team-member)
4. [Updating Publications (Automated)](#updating-publications-automated)

For styling instructions, see [WEBSITE_STYLE.md](WEBSITE_STYLE.md).

For gallery maintenance instructions, see [WEBSITE_GALLERY.md](WEBSITE_GALLERY.md).

## Adding a New News Post

News posts are stored in the `_posts/` directory and follow Jekyll's naming convention.

### Steps

1. Create a new file in `_posts/` directory with the naming format:

```
YYYY-MM-DD-title-with-hyphens.md
```

Example: `2025-11-15-lab-meeting-november.md`

2. Add front matter at the top of the file:

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

3. Add your content below the front matter:

```markdown
Your news content goes here. You can use markdown formatting.

- Bullet points
- More information
```

4. **Add images (optional)**:
   - Images can be added in front matter or embedded in content
   - Front matter example:
     ```yaml
     image:
       homepage: "image-name.jpg"
       header: "image-name.jpg"
     ```
   - Or embed in markdown: `![Alt text](image-name.jpg)`
   - **Important for automatic gallery updates**: For images to be automatically added to the gallery, name them with the same date prefix as the news post (YYYY-MM-DD). For example, if your post is `2025-11-15-lab-meeting-november.md`, name your image `2025-11-15-image-name.jpg`. The script will automatically rename images to this format if they don't already have it, but it's recommended to use the date prefix from the start.
   - **Gallery auto-update**: Images in news posts are automatically added to the team gallery when you push changes (see below)

5. **Commit and push to `web_test` branch**:
   ```bash
   git add _posts/2025-11-15-lab-meeting-november.md
   git commit -m "Add news post: Lab Meeting November 2025"
   git push origin web_test
   ```
   - The `auto-update-news.yml` workflow will automatically:
     - Scan the news post for images
     - Add new images to the team gallery (`pages/team-gallery.md`)
     - Copy images to `assets/img/gallery/` if needed
     - Build the Jekyll site
     - Deploy to staging environment for review
   - Review the staging site to verify the news post and gallery updates
   - When ready, merge `web_test` → `main` to deploy to production

6. File locations:
   - News posts: `_posts/YYYY-MM-DD-title.md`
   - Example: `_posts/2025-11-15-lab-meeting-november.md`
   - Gallery page: `pages/team-gallery.md` (auto-updated by workflow)
   - Gallery images: `assets/img/gallery/` (images copied here automatically)

### Automated Gallery Updates

When you add or update a news post with images, the `auto-update-news.yml` workflow automatically:

1. **Scans the news post** for images in:
   - Front matter (`image.homepage`, `image.thumb`, `image.header`)
   - Markdown content (`![alt](url)`)
   - HTML content (`<img src="...">`)

2. **Adds new images to the gallery**:
   - Checks if images already exist in the gallery (won't add duplicates)
   - Copies images to `assets/img/gallery/` if they're in other locations
   - **Renames images with date prefix**: Images are automatically renamed to `YYYY-MM-DD-originalname.ext` format using the date from the news post filename. For example, an image `photo.jpg` in post `2025-11-15-lab-meeting.md` will be renamed to `2025-11-15-photo.jpg` in the gallery.
   - Generates captions from post title and date
   - Updates `pages/team-gallery.md` with new gallery entries
   - Updates image paths in the news post markdown file to point to the renamed gallery image
   - Sorts all gallery images chronologically by date (YYYY-MM-DD)

3. **Builds and deploys** the site with the updated gallery

**Note**: The gallery script is idempotent - it's safe to run multiple times and won't create duplicates. Images are only added if they don't already exist in the gallery.

**Image naming tip**: To ensure smooth automatic processing, name your images with the same date prefix as your news post (e.g., `2025-11-15-image-name.jpg` for post `2025-11-15-title.md`). The script will automatically rename images to this format, but using the date prefix from the start ensures consistent behavior.

### Running the Gallery Script Manually

If you need to run the gallery update script manually (e.g., to test it locally or update the gallery without pushing to GitHub):

```bash
# Basic usage (uses default gallery file: pages/team-gallery.md)
ruby scripts/news_to_gallery.rb

# Or specify a custom gallery file
ruby scripts/news_to_gallery.rb pages/team-gallery.md
```

**On Apple Silicon (ARM64) Macs**, you may need to use:
```bash
arch -x86_64 ruby scripts/news_to_gallery.rb
```

**What the script does**:
- Scans all posts in `_posts/` directory
- Finds images in post front matter or embedded in content
- Checks if images already exist in the gallery (skips duplicates)
- Copies images to `assets/img/gallery/` if they're in other locations
- Adds new images to `pages/team-gallery.md` with auto-generated captions
- Sorts all gallery images chronologically by year
- Updates the gallery file in place

**After running manually**:
- The script modifies `pages/team-gallery.md` directly
- You'll need to commit the changes if you want to save them:
  ```bash
  git add pages/team-gallery.md assets/img/gallery/
  git commit -m "Update gallery from news posts"
  ```

### Example

```markdown
---
layout: page
title: "Lab Meeting November 2025"
teaser: "Monthly lab meeting discussion topics"
header:
    image_fullwidth: "genvis-dna-bg_optimized_v1a.png"
breadcrumb: true
---

November 2025 - This month's lab meeting covered new research directions and upcoming conference presentations.
```

## Adding a New Page

Pages are stored in the `pages/` directory and can be added to the navigation menu.

### Steps

1. Create a new file in `pages/` directory:

```
your-page-name.md
```

Example: `teaching.md`, `resources.md`

2. Add front matter with required fields:

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

3. Add optional Magellan navigation (for pages with multiple sections):

```html
<div data-magellan-expedition="fixed">
  <ul class="sub-nav">
    <li data-magellan-arrival="Section1"><a href="#Section1">Section 1</a></li>
    <li data-magellan-arrival="Section2"><a href="#Section2">Section 2</a></li>
  </ul>
</div>
```

4. Add content sections with anchors:

```html
<h2 data-magellan-destination="Section1">Section 1</h2>
<a name="Section1"></a>

Your content here...
```

5. Add to navigation menu (optional):
   - Edit `_data/navigation.yml`
   - Add entry:

```yaml
- title: Your Page Title
  url: "/your-url-path/"
  side: left
```

6. File locations:
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

## Adding a New Team Member

Team members are added to `pages/team.md` and their social media links are stored in `_data/socialmedia.yml`.

### Steps

1. Add team member image to `assets/img/team/`:
   - File name: `member-name.jpg` or `member-name.png`
   - Recommended size: Square format (e.g., 200x200px or larger)
   - The image will be automatically cropped to a square with rounded corners

2. Add team member entry to `pages/team.md`:

   For Principal Investigator (only one):

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

   For other team members (Postdocs, Graduate Students, Undergraduates):

```liquid
{% include team_member_grid
    member_name="MemberName"
    full_name="Full Name"
    bio="B.S. Degree - University<br>Additional info"
    email="email@illinois.edu"
    pronouns="she/her"
    role="G5"
    image="/assets/img/team/member-name.jpg"
%}
```

3. Add social media links (optional) to `_data/socialmedia.yml`:

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

4. **Place team member in desired location** (you have full control):
   - **Principal Investigator**: Use `team_member` include (appears first, left-image layout)
   - **Postdoctoral Researchers**: Add to "Postdoctoral Researchers" section, use `team_member_grid` include
   - **Graduate Students**: Add to appropriate G* subsection (G5, G4, G3, G2, G1), use `team_member_grid` include
   - **Undergraduate Students**: Add to "Undergraduate Students" section, use `team_member_grid` include

   **Placement Control**: Team members are placed manually in `pages/team.md` using `{% include team_member_grid %}` statements. You control exactly where each member appears by placing the include statement in the desired table cell/position within the appropriate section. The page uses HTML tables with mini-tables for organizing members:
   - Postdocs: Organized in mini-tables (2 columns per mini-table, 2 mini-tables per row = 4 columns total)
   - Graduate Students: Organized by year (G5, G4, G3, G2, G1) in mini-tables
   - Each member's position is determined by which table cell you place their include statement in
   - The workflow (`auto-update-team.yml`) will automatically rebuild and deploy when you make changes, but it does NOT change the order or placement - that's completely under your control

5. Maintain grid layout:
   - Team members are displayed in a 4-column grid on desktop
   - The layout uses HTML tables with specific mini-table structures
   - Empty table cells can be left empty (no placeholder needed)
   - Each section has its own table structure - follow the existing pattern in `pages/team.md`

6. **Commit and push to `web_test` branch**:
   ```bash
   git add pages/team.md _data/socialmedia.yml assets/img/team/member-name.jpg
   git commit -m "Add new team member: MemberName"
   git push origin web_test
   ```
   - The `auto-update-team.yml` workflow will automatically:
     - Build the Jekyll site
     - Deploy to staging environment for review
   - Review the staging site to verify placement and appearance
   - When ready, merge `web_test` → `main` to deploy to production

7. File locations:
   - Team page: `pages/team.md`
   - Team images: `assets/img/team/member-name.jpg`
   - Social media config: `_data/socialmedia.yml`

### Example: Adding a Graduate Student

Step 1: Add image to `assets/img/team/john.jpg`

Step 2: **Choose placement location** in `pages/team.md`:
   - Open `pages/team.md` and find the appropriate G* section (e.g., G3)
   - Look at the existing mini-table structure
   - Decide which table cell position you want (e.g., first cell in a new mini-table, or replace an empty cell)
   - Place the include statement in that exact location

Step 3: Add the include statement to `pages/team.md` in the chosen location:

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

Step 4: Add social media to `_data/socialmedia.yml`:

```yaml
- member_name: John
  social:
  - name: GitHub
    url: https://github.com/johndoe
    class: fa-brands fa-github
    title: "GitHub Profile"
```

### Available Font Awesome Icons

Common icon classes for social media:
- GitHub: `fa-brands fa-github`
- LinkedIn: `fa-brands fa-linkedin`
- Google Scholar: `fa-solid fa-graduation-cap`
- ORCiD: `fa-brands fa-orcid`
- Website: `fa-solid fa-globe`
- Twitter/X: `fa-brands fa-twitter`
- Email: `fa-solid fa-envelope`

See [Font Awesome 6.2.0 icons](https://fontawesome.com/v6/icons) for more options.

### Automated Deployment

The website uses an automated GitHub Actions workflow (`auto-update-team.yml`) to build and deploy when team-related files change. **You have full control over team member placement** - the workflow only handles building and deploying, it does NOT change the order or position of team members.

**Workflow Process**:
1. **Make changes on `web_test` branch**:
   - Edit `pages/team.md`, `_data/socialmedia.yml`, or add team images
   - Push changes to `web_test`
   - GitHub Actions automatically builds and deploys to staging environment

2. **Review staging site**:
   - Wait for GitHub Actions to complete (check Actions tab in GitHub)
   - Review the staging deployment URL
   - Verify team member appears in the correct location

3. **Deploy to production**:
   - Merge `web_test` → `main` (via pull request or direct merge)
   - GitHub Actions automatically builds and deploys to production GitHub Pages

**What the workflow does**:
- Detects changes to `pages/team.md`, `_data/socialmedia.yml`, or `assets/img/team/**`
- Automatically builds the Jekyll site
- Deploys to staging (`web_test` branch) or production (`main` branch)
- **Does NOT modify** the order or placement of team members - that's controlled by where you place the include statements in `pages/team.md`

## Updating Publications (Automated)

The website uses an automated GitHub Actions workflow to generate the publications page from BibTeX files. **You only need to edit the BibTeX files** - the website will automatically rebuild and deploy.

### Branch Structure

- **`web_test` branch**: Staging environment for testing changes
- **`main` branch**: Production environment (stable, deployed to live site)

### Workflow Process

1. **Make changes on `web_test` branch**:
   - Edit BibTeX files (see file locations below)
   - Push changes to `web_test`
   - GitHub Actions automatically:
     - Regenerates `pages/publications.md` from BibTeX files
     - Builds the Jekyll site
     - Deploys to staging environment for review

2. **When ready for production**:
   - Merge `web_test` → `main` (via pull request or direct merge)
   - GitHub Actions automatically:
     - Regenerates `pages/publications.md` from BibTeX files
     - Builds the Jekyll site
     - Deploys to production GitHub Pages

### BibTeX File Locations

- **Preprints**: `assets/jackson_preprints.bib` (appears in "Submitted" section)
- **Old publications**: `assets/jackson_old_pubs.bib` (appears in "Prior to UIUC" section)
- **New publications**: `assets/jackson_pubs.bib` (classified by year, 2021+)

### How to Update Publications

1. **Edit the appropriate BibTeX file**:
   - Add new entries or modify existing ones
   - See [update_pubs.md](update_pubs.md) for detailed BibTeX format requirements

2. **Commit and push to `web_test`**:
   ```bash
   git add assets/jackson_pubs.bib  # or whichever file you edited
   git commit -m "Add new publication"
   git push origin web_test
   ```

3. **Review staging site**:
   - Wait for GitHub Actions to complete (check Actions tab in GitHub)
   - Review the staging deployment URL
   - Verify publications appear correctly

4. **Deploy to production**:
   - Merge `web_test` → `main`:
     ```bash
     git checkout main
     git merge web_test
     git push origin main
     ```
   - Or create a pull request on GitHub and merge it
   - Production site will automatically update

### What Gets Auto-Generated

The workflow automatically:
- Parses all three BibTeX files
- Formats author names (converts to "Initials Last" format)
- Assigns publication numbers (chronological order)
- Groups publications by year/section
- Generates the `pages/publications.md` file with proper Jekyll includes
- Builds and deploys the site

### Manual Override (If Needed)

If you need to manually run the generation script locally:

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

### GitHub Environments Setup

The workflow uses two GitHub environments:

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

### Detailed BibTeX Instructions

For complete BibTeX format requirements, field descriptions, and examples, see [update_pubs.md](update_pubs.md).

## Notes

- After making changes, rebuild the site: `bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch`
- On Apple Silicon Macs, use: `arch -x86_64 bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch`
- Always test locally before pushing changes
- Use consistent naming conventions (lowercase with hyphens for files)
- Images should be optimized before uploading
