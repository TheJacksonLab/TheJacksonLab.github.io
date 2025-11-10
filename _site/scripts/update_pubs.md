# Publications Automation

This directory contains scripts for automating the generation of the publications page from BibTeX files.

## Overview

The publications workflow consists of two steps:
1. **Clean the BibTeX file** - Remove unnecessary fields, keeping only essential publication information
2. **Generate the publications page** - Convert the cleaned BibTeX file into the Jekyll `publications.md` page format

## File Locations

- **BibTeX file**: `assets/jackson_pubs.bib`
- **Cleaned BibTeX file**: `assets/jackson_pubs.bib` (overwrites original)
- **Generated publications page**: `pages/publications.md`
- **Backup files**: Automatically created with timestamps (e.g., `pages/publications.md.backup.20251110_103437`)

## Prerequisites

1. Install the required gems:
   ```bash
   bundle install
   ```

2. Ensure your BibTeX file contains entries with the following fields:
   - `author` (required)
   - `title` (required)
   - `journal` or `booktitle` or `publisher` (required)
   - `year` or `date` (optional, defaults to "Older" if missing)
   - `doi` (optional)
   - `pmid` (optional)
   - `month` (optional, used for journal formatting)
   - `volume`, `number`, `pages`, `issue`, `journal-iso` (optional)

## Step 1: Clean the BibTeX File

The `clean_bibtex.rb` script removes all fields except the essential ones listed above.

### Usage

```bash
# Clean the BibTeX file (overwrites original, creates backup)
ruby scripts/clean_bibtex.rb assets/jackson_pubs.bib assets/jackson_pubs.bib

# Or specify a different output file
ruby scripts/clean_bibtex.rb assets/jackson_pubs.bib assets/jackson_pubs_cleaned.bib
```

### What it does

1. Reads the BibTeX file from `assets/jackson_pubs.bib`
2. Removes all fields except: `author`, `journal`, `title`, `year`, `doi`, `volume`, `issue`, `journal-iso`, `number`, `pages`
3. Creates a backup of the original file before overwriting
4. Writes the cleaned file (default: overwrites the input file)

### Notes

- **The script will overwrite the input file** if output file is not specified
- **A backup is automatically created** before overwriting (saved as `filename.backup.YYYYMMDD_HHMMSS`)
- All other metadata (affiliations, funding, keywords, etc.) is removed

## Step 2: Generate the Publications Page

The `bibtex_to_publications.rb` script converts the cleaned BibTeX file into the Jekyll publications page format.

### Usage

```bash
# Basic usage (outputs to pages/publications.md)
arch -x86_64 bundle exec ruby scripts/bibtex_to_publications.rb assets/jackson_pubs.bib

# Specify custom output file
arch -x86_64 bundle exec ruby scripts/bibtex_to_publications.rb assets/jackson_pubs.bib pages/publications.md
```

**Note**: On Apple Silicon (ARM64) Macs, use `arch -x86_64` prefix for compatibility with native extensions.

### What it does

1. Parses the BibTeX file using the `bibtex-ruby` gem
2. Extracts publications and groups them by year
3. Generates the Magellan navigation bar with year links
4. Creates Liquid `{% include publication %}` statements for each entry
5. Preserves the front matter (YAML header) from the existing `publications.md` file
6. Writes the generated content to the output file

### BibTeX Entry Types Supported

- `@article`
- `@inproceedings`
- `@incollection`
- `@book`
- `@chapter`

Other entry types are skipped.

### Notes

- **The script will overwrite the output file** (default: `pages/publications.md`)
- **A backup is automatically created** before overwriting (saved as `pages/publications.md.backup.YYYYMMDD_HHMMSS`)
- Publications without a year are grouped under "Older"
- The script preserves the front matter (YAML header) from the existing file
- DOI and PMID fields are optional
- The navigation bar shows the most recent 10 years plus "Older" and "All" links
- Special characters in titles and authors are escaped for Liquid syntax

## Complete Workflow

To update the publications page from a new BibTeX file:

```bash
# 1. Clean the BibTeX file (if needed)
ruby scripts/clean_bibtex.rb assets/jackson_pubs.bib assets/jackson_pubs.bib

# 2. Generate the publications page
arch -x86_64 bundle exec ruby scripts/bibtex_to_publications.rb assets/jackson_pubs.bib pages/publications.md

# 3. Rebuild Jekyll site to see changes
arch -x86_64 bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch
```

## Example BibTeX Entry

```bibtex
@article{example2024,
  author = {Smith, John and Doe, Jane},
  title = {Example Publication Title},
  journal = {Journal of Examples},
  year = {2024},
  volume = {10},
  number = {5},
  pages = {123-456},
  doi = {10.1234/example.2024.001},
  pmid = {12345678}
}
```

This will generate:

```liquid
{% include publication authors="Smith, John and Doe, Jane" title="Example Publication Title" journal="Journal of Examples" doi="10.1234/example.2024.001" pmid="12345678"%}
```

