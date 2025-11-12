# Website Gallery Maintenance Guide

This guide explains how to add and update images in the Team Gallery page.

## Table of Contents

1. [Automated Gallery Updates](#automated-gallery-updates)
2. [Manual Gallery Updates](#manual-gallery-updates)
3. [Gallery Features](#gallery-features)
4. [Troubleshooting](#troubleshooting)

## File Locations

- **Gallery Page**: `pages/team-gallery.md`
- **Gallery Images Directory**: `assets/img/gallery/`
- **Gallery Include Widget**: `_includes/gallery`

## How the Gallery Works

The gallery uses Foundation's Clearing component to create a lightbox effect:

- Thumbnails are displayed in a 4-column grid
- **Thumbnails are automatically cropped from full-size images** - no need to create separate thumbnail files
- Clicking a thumbnail opens a lightbox with the full-size image
- Captions appear below images in the lightbox
- The gallery is responsive and works on all screen sizes

---

## Automated Gallery Updates

**Gallery updates from news posts are now automated!**

When you add a news post with images, the `auto-update-news.yml` workflow automatically:

- Scans the news post for images (in front matter or embedded in content)
- Adds new images to the team gallery
- Renames images with date prefix (YYYY-MM-DD-filename.ext) for chronological sorting
- Generates captions from post title and date
- Updates `pages/team-gallery.md` automatically
- Builds and deploys the site

**What you do**: Just add images to your news post and push to GitHub.

**Image naming tip**: Name images with the same date prefix as the news post (e.g., `2025-11-15-lab-photo.jpg` for post `2025-11-15-lab-meeting.md`) to ensure smooth automatic processing.

**Example workflow**:

1. Create a news post with an image:

   ```markdown
   ---
   layout: page
   title: "Lab Meeting November 2025"
   ---

   November 2025 - This month's lab meeting covered new research directions.

   ![Lab photo](/assets/img/gallery/2025-11-15-lab-photo.jpg)
   ```

2. Commit and push:

   ```bash
   git add _posts/2025-11-15-lab-meeting-november.md
   git commit -m "Add news post: Lab Meeting November 2025"
   git push origin web_test
   ```

3. The workflow automatically:
   - Detects the image in the news post
   - Adds it to `pages/team-gallery.md` with auto-generated caption
   - Renames the image to include date prefix if needed
   - Builds and deploys to staging

**See also**: [WEBSITE_MAINTENANCE.md](WEBSITE_MAINTENANCE.md) for more details on the automated workflow.

### Running the Gallery Script Manually

If you need to update the gallery manually (e.g., to test locally or update without a news post):

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

---

## Manual Gallery Updates

If you want to add images directly to the gallery without a news post, follow these steps:

### Step 1: Prepare Your Images

You only need **one version** of each image:

1. **Full-size image**: The high-resolution version
   - This will be used for both the thumbnail (auto-cropped) and the lightbox display
   - Example: `group_photo_2024.jpg`
   - Recommended: High resolution (2000px+ width) for best quality in lightbox

**No thumbnails needed!** The gallery automatically crops thumbnails from the full-size images using CSS.

### Step 2: Place Images in Directory

Place your images in the gallery directory:

```text
assets/img/gallery/
├── group_photo_2024.jpg
├── canoe_trip_2024.jpg
└── lab_meeting_2024.jpg
```

**Note:** You no longer need to create separate thumbnail files. The gallery automatically crops thumbnails to 200px height while maintaining aspect ratio.

### Step 3: Update the Gallery Page

Edit `pages/team-gallery.md` and add your images to the `gallery` front matter:

```yaml
gallery:
    - image_url: group_photo_2024.jpg
      caption: "Jackson Lab Group Photo 2024 - Full description shown in lightbox"
      hover_caption: "Group Photo 2024"
    - image_url: canoe_trip_2024.jpg
      caption: "Group Canoe Trip 2024"
      # hover_caption will default to caption if not specified
    - image_url: lab_meeting_2024.jpg
      caption: "Weekly Lab Meeting"
```

**Notes**:

- Only specify the full-size image filename in `image_url`
- **Thumbnails are automatically generated** - no need to create separate thumbnail files
- `caption`: Full caption displayed in the lightbox (optional)
- `hover_caption`: Short caption displayed when hovering over thumbnails (optional)
  - If `hover_caption` is not provided, the `caption` will be used for hover
  - Use `hover_caption` for shorter, more concise text that fits better in the thumbnail overlay
- Images are displayed in the order they appear in the list

### Step 4: Rebuild the Site

After adding images, rebuild the Jekyll site:

```bash
bundle exec jekyll build
```

Or if running locally:

```bash
bundle exec jekyll serve
```

### Image Naming Conventions

- Use lowercase letters and underscores or hyphens
- Avoid spaces in filenames
- Use descriptive names: `group_photo_2024.jpg` not `img1.jpg`
- Include dates when relevant: `canoe_trip_2024.jpg`
- **For automatic updates**: Use date prefix format (YYYY-MM-DD-filename.ext) to match news post dates
- **Only one file per image needed** - thumbnails are auto-cropped

### Example: Complete Manual Workflow

1. **Prepare image**:
   - Full-size: `assets/img/gallery/2024-06-01-retreat.jpg` (2000px width)

2. **Update `pages/team-gallery.md`**:

   ```yaml
   gallery:
       - image_url: 2024-06-01-retreat.jpg
         caption: "Jackson Lab Annual Retreat 2024 - Full description for lightbox"
         hover_caption: "Retreat 2024"
   ```

3. **Rebuild site**:

   ```bash
   bundle exec jekyll build
   ```

4. **View result**: Navigate to `/team/gallery/` on your website

**That's it!** The thumbnail will be automatically cropped from the full-size image.

---

## Gallery Features

- **Responsive grid**: Automatically adjusts from 4 columns (desktop) to fewer columns on smaller screens
- **Lightbox**: Click any thumbnail to view full-size image
- **Click outside to close**: Click on the dark background area to close the lightbox
- **Captions**: Display below images in the lightbox
- **Navigation**: Use arrow keys or click navigation arrows in lightbox
- **Keyboard support**: ESC to close lightbox

---

## Troubleshooting

**Images not appearing?**

- Check that the full-size image file exists in `assets/img/gallery/`
- Verify filenames match exactly (case-sensitive)
- Check that images are in `assets/img/gallery/` directory

**Thumbnails look blurry?**

- Make sure source images are high resolution (2000px+ width recommended)
- The auto-crop uses CSS `object-fit: cover` which maintains quality
- Thumbnails are displayed at 200px height, cropped to fit the grid

**Lightbox not working?**

- Ensure Foundation JavaScript is loaded (should be automatic)
- Check browser console for JavaScript errors
- Verify the `data-clearing` attribute is present (it's in the gallery include)

**Gallery not updating automatically?**

- Check that you pushed to the correct branch (`web_test` or `main`)
- Verify the news post contains images in the correct format
- Check the Actions tab in GitHub for workflow errors
- Ensure image paths in news posts are absolute (start with `/`)
