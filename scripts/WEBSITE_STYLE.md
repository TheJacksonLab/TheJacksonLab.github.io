# Website Styling Guide

Instructions for customizing website fonts, colors, and hover effects.

The website uses SCSS (Sass) files for styling. All style variables and customizations are located in the `_sass/` directory.

## File Structure

- Colors: `_sass/_01_settings_colors.scss`
- Typography: `_sass/_02_settings_typography.scss`
- Link Styles and Hover Effects: `_sass/_06_typography.scss`
- Layout Styles: `_sass/_07_layout.scss`
- Font Loading: `_includes/_head.html`

## Changing Fonts

### Step 1: Update Font Loading

Edit `_includes/_head.html` to load your desired fonts from Google Fonts:

```html
<script>
    WebFont.load({
        google: {
            families: [ 'Your+Font+Name:400,500,600,700:latin', 'Another+Font:400,700:latin' ]
        }
    });
</script>

<noscript>
    <link href='http://fonts.googleapis.com/css?family=Your+Font+Name:400,500,600,700|Another+Font:400,700' rel='stylesheet' type='text/css'>
</noscript>
```

Example (current fonts):
- Body font: `Zalando+Sans:400,500,600,700:latin`
- Header font: `Trocchi:400,700:latin`

### Step 2: Update Font Variables

Edit `_sass/_02_settings_typography.scss`:

```scss
$font-family-sans-serif: "Your Font Name", "Helvetica Neue", Helvetica, Arial, sans-serif;
$font-family-serif: "Your Serif Font", Georgia, Times, serif;
$font-family-monospace: "Lucida Console", Monaco, monospace;

$body-font-family: $font-family-sans-serif;
$header-font-family: $font-family-serif;
```

Current settings:
- Body font: `"Zalando Sans"` (sans-serif)
- Header font: `"Trocchi"` (serif)

### Step 3: Adjust Font Sizes (Optional)

In `_sass/_02_settings_typography.scss`, modify:

```scss
$base-font-size: 16px;
$font-size-h1: 2.441em;
$font-size-h2: 1.953em;
$font-size-h3: 1.563em;
$font-size-h4: 1.25em;
$font-size-h5: 1.152em;
```

## Changing Colors

### Color Palette Variables

Edit `_sass/_01_settings_colors.scss` to change the color scheme:

```scss
/* Corporate Identity Colorpalette */
$eggshell: #f4f1de;
$burnt-sienna: #e07a5f;
$delft-blue: #3d405b;
$cambridge-blue: #81b29a;
$sunset: #f2cc8f;

// Legacy ci variables mapped to new palette
$ci-1: $delft-blue;
$ci-2: $cambridge-blue;
$ci-3: $sunset;
$ci-4: $burnt-sienna;
$ci-5: $burnt-sienna;
$ci-6: $cambridge-blue;
```

### Text and Background Colors

```scss
$text-color: #3d405b;
$body-font-color: $text-color;
$body-bg: #f4f1de;
```

### Navigation Colors

```scss
$topbar-link-color: $delft-blue;
$topbar-link-color-hover: $delft-blue;
$topbar-link-bg-hover: $cambridge-blue;
$topbar-link-bg-active: $cambridge-blue;
```

### Footer Colors

```scss
$footer-bg: $delft-blue;
$footer-color: $eggshell;
$footer-link-color: $cambridge-blue;
```

### Foundation Component Colors

```scss
$primary-color: $delft-blue;
$secondary-color: $cambridge-blue;
$alert-color: $burnt-sienna;
$success-color: $cambridge-blue;
$warning-color: $sunset;
$info-color: $delft-blue;
```

## Changing Hover Actions

### Link Hover Effects

Edit `_sass/_06_typography.scss` to customize link hover styles:

```scss
a:hover {
    color: lighten( $ci-1, 40% );
}

a:focus {
    color: lighten( $ci-1, 20% );
}

a:active {
    color: darken( $ci-1, 20% );
}
```

Custom hover example:

```scss
a:hover {
    color: $cambridge-blue;
    text-decoration: underline;
    transition: all 0.3s ease;
}
```

### Navigation Hover Effects

In `_sass/_01_settings_colors.scss`:

```scss
$topbar-link-color-hover: $delft-blue;
$topbar-link-bg-hover: $cambridge-blue;
$topbar-dropdown-link-bg-hover: $cambridge-blue;
```

### Button Hover Effects

Button hover colors are automatically calculated based on base colors, but can be customized in `_sass/foundation-components/_buttons.scss`:

```scss
$button-bg-hover: scale-color($button-bg-color, $lightness: $button-function-factor);
```

To customize specific button hover colors:

```scss
$button-bg-hover: #your-color;
$secondary-button-bg-hover: #your-color;
$success-button-bg-hover: #your-color;
$alert-button-bg-hover: #your-color;
```

### Social Icon Hover Effects

Social icons hover effects are defined in `_sass/_07_layout.scss`:

```scss
.social-icons {
  a {
    &:hover {
      background: $footer-bg;
      color: #fff;
    }
  }
}
```

To customize:

```scss
.social-icons {
  a {
    &:hover {
      background: $cambridge-blue;
      color: $eggshell;
      transform: scale(1.1);
      transition: all 0.3s ease;
    }
  }
}
```

### Image Caption Link Hover

In `_sass/_06_typography.scss`:

```scss
figcaption a:hover,
.masthead-caption a:hover {
    border-bottom: 2px solid $primary-color;
    color: $primary-color;
}
```

## Common Styling Tasks

### Change Link Color Globally

1. Edit `_sass/_06_typography.scss`
2. Modify the `a:hover`, `a:focus`, `a:active` selectors

### Change Navigation Bar Colors

1. Edit `_sass/_01_settings_colors.scss`
2. Modify `$topbar-*` variables

### Change Footer Colors

1. Edit `_sass/_01_settings_colors.scss`
2. Modify `$footer-*` variables

### Add Custom Hover Transitions

Add to any hover selector:

```scss
transition: all 0.3s ease;
```

### Change Button Colors

1. Edit `_sass/_01_settings_colors.scss`
2. Modify `$primary-color`, `$secondary-color`, etc.
3. Or edit `_sass/foundation-components/_buttons.scss` for specific button styles

## Testing Style Changes

1. Rebuild the site after making SCSS changes:

```bash
bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch
```

On Apple Silicon Macs:

```bash
arch -x86_64 bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch
```

2. Clear browser cache (Ctrl+Shift+R or Cmd+Shift+R) to see changes

3. Check compiled CSS in `_site/assets/css/styles_feeling_responsive.css` (generated file)

## File Locations Summary

- Color variables: `_sass/_01_settings_colors.scss`
- Typography variables: `_sass/_02_settings_typography.scss`
- Link styles and hover: `_sass/_06_typography.scss`
- Layout styles: `_sass/_07_layout.scss`
- Font loading: `_includes/_head.html`
- Button styles: `_sass/foundation-components/_buttons.scss`

## Notes

- After making changes, rebuild the site: `bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch`
- On Apple Silicon Macs, use: `arch -x86_64 bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch`
- Always test locally before pushing changes
- Clear browser cache to see style changes immediately
