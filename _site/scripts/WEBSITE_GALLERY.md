# Website Gallery Maintenance Guide

This guide explains how to add and update images in the Team Gallery page.

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

## Automatic Gallery Updates from News Posts

**NEW:** You can automatically add images from news posts to the gallery!

If a news post contains images (in front matter or embedded in content), you can run a script to automatically add them to the gallery:

```bash
ruby scripts/news_to_gallery.rb
```

This script will:
- Scan all posts in `_posts/` directory
- Find images in post front matter (`image.homepage`, `image.thumb`, `image.header`) or embedded in content (Markdown `![alt](url)` or HTML `<img>` tags)
- Check if images already exist in the gallery
- Copy images to `assets/img/gallery/` if they're in other locations
- Add new images to the gallery with captions generated from post title and date
- Sort all gallery images chronologically by year

**Note:** The script will only add images that are not already in the gallery, so it's safe to run multiple times.

### Manual Method: Adding Images to the Gallery

### Step 1: Prepare Your Images

You only need **one version** of each image:

1. **Full-size image**: The high-resolution version
   - This will be used for both the thumbnail (auto-cropped) and the lightbox display
   - Example: `group_photo_2024.jpg`
   - Recommended: High resolution (2000px+ width) for best quality in lightbox

**No thumbnails needed!** The gallery automatically crops thumbnails from the full-size images using CSS.

### Step 2: Place Images in Directory

Place your images in the gallery directory:
```
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

**Notes:**
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

## Image Naming Conventions

- Use lowercase letters and underscores or hyphens
- Avoid spaces in filenames
- Use descriptive names: `group_photo_2024.jpg` not `img1.jpg`
- Include dates when relevant: `canoe_trip_2024.jpg`
- **Only one file per image needed** - thumbnails are auto-cropped

## Example: Complete Workflow

1. **Prepare image**:
   - Full-size: `assets/img/gallery/retreat_2024.jpg` (2000px width)

2. **Update `pages/team-gallery.md`**:
   ```yaml
   gallery:
       - image_url: retreat_2024.jpg
         caption: "Jackson Lab Annual Retreat 2024 - Full description for lightbox"
         hover_caption: "Retreat 2024"
   ```

3. **Rebuild site**:
   ```bash
   bundle exec jekyll build
   ```

4. **View result**: Navigate to `/team/gallery/` on your website

**That's it!** The thumbnail will be automatically cropped from the full-size image.

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

## Gallery Features

- **Responsive grid**: Automatically adjusts from 4 columns (desktop) to fewer columns on smaller screens
- **Lightbox**: Click any thumbnail to view full-size image
- **Captions**: Display below images in the lightbox
- **Navigation**: Use arrow keys or click navigation arrows in lightbox
- **Keyboard support**: ESC to close lightbox

