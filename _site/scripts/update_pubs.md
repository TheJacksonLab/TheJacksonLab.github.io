# Publications Automation

This directory contains scripts for automating the generation of the publications page from BibTeX files.

## Overview

The publications workflow consists of two steps:
1. **Clean the BibTeX file** - Remove unnecessary fields, keeping only essential publication information
2. **Generate the publications page** - Convert the cleaned BibTeX file into the Jekyll `publications.md` page format

## File Locations

- **Preprints BibTeX file**: `assets/jackson_preprints.bib` (all entries go to "Submitted" section, appears first)
- **Old publications BibTeX file**: `assets/jackson_old_pubs.bib` (all entries go to "Prior to UIUC" section)
- **New publications BibTeX file**: `assets/jackson_pubs.bib` (classified by year)
- **Cleaned BibTeX files**: Same as above (overwrites originals when cleaned)
- **Generated publications page**: `pages/publications.md`
- **Backup files**: Automatically created (e.g., `pages/publications.md.backup` - only one backup is kept, overwritten on each run)

## Prerequisites

1. Install the required gems:
   ```bash
   bundle install
   ```

2. Ensure your BibTeX file contains entries with the following fields:
   - `author` (required)
   - `title` (required)
   - `journal` or `booktitle` or `publisher` (required for published papers)
   - `year` or `date` (optional, defaults to "Older" if missing)
   - `doi` (optional)
   - `pmid` (optional)
   - `month` (optional, used for journal formatting)
   - `volume`, `number`, `pages`, `issue`, `journal-iso` (optional)
   - `location` (optional, for manual control of publication numbering/ordering)
   - `arxiv` (optional, for preprints: full URL or ID for arXiv, ChemRxiv, or bioRxiv)
   - `status` (optional, for preprints: "in review", "submitted", or "in press")

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
2. Removes all fields except: `author`, `journal`, `title`, `year`, `doi`, `volume`, `issue`, `journal-iso`, `number`, `pages`, `location`, `arxiv`, `status`
3. Creates a backup of the original file before overwriting
4. Writes the cleaned file (default: overwrites the input file)

### Notes

- **The script will overwrite the input file** if output file is not specified
- **A backup is automatically created** before overwriting (saved as `filename.backup.YYYYMMDD_HHMMSS`)
- All other metadata (affiliations, funding, keywords, etc.) is removed
- The `location`, `arxiv`, and `status` fields are preserved if present (used for publication numbering and preprint information)

## Step 2: Generate the Publications Page

The `bibtex_to_publications.rb` script converts the cleaned BibTeX files into the Jekyll publications page format. It processes three files:
- **Preprints** (`jackson_preprints.bib`): All entries go to the "Submitted" section (appears first, before year sections). Entries should include `arxiv` (full URL or ID) and `status` ("in review", "submitted", or "in press") fields.
- **Old publications** (`jackson_old_pubs.bib`): All entries go to the "Prior to UIUC" section
- **New publications** (`jackson_pubs.bib`): Entries are classified by year (2021+)

### Usage

```bash
# Basic usage (uses default file names, outputs to pages/publications.md)
arch -x86_64 bundle exec ruby scripts/bibtex_to_publications.rb

# Specify custom files
arch -x86_64 bundle exec ruby scripts/bibtex_to_publications.rb assets/jackson_preprints.bib assets/jackson_old_pubs.bib assets/jackson_pubs.bib pages/publications.md
```

**Note**: On Apple Silicon (ARM64) Macs, use `arch -x86_64` prefix for compatibility with native extensions.

### What it does

1. Reads and parses all three BibTeX files using the `bibtex-ruby` gem
2. Processes preprints file: All entries are assigned to "Submitted" section (appears first)
3. Processes old publications file: All entries are assigned to "Prior to UIUC" section
4. Processes new publications file: Extracts publications and groups them by year
5. Formats author names:
   - Converts from "Last, First" or "First Last" format to "Initials Last" format (e.g., "Nicholas Jackson" → "N. Jackson")
   - Handles hyphenated names: "Chun-I" → "C.-I."
   - Preserves names already in initials format (e.g., "J.L. Wu" stays as "J.L. Wu")
   - Separates multiple authors with commas, except the last two authors use "and"
   - Special case: For entries with "..." and "et al.", formats as "First Author,..., Last Author Before Et Al, et al."
6. Assigns publication numbers:
   - **Submitted**: Continuous numbering starting from 1 (oldest first)
   - **2021+ publications**: Continuous numbering starting from 1 (oldest publication in 2021)
   - **Prior to UIUC**: Restarts numbering at 1 (oldest first)
   - If `location` (or `chron_order` for backward compatibility) is specified in BibTeX, uses that number
   - Otherwise, auto-assigns sequential numbers based on chronological order
7. Generates the Magellan navigation bar with section links
8. Creates Liquid `{% include publication %}` statements for each entry with numbering
9. Preserves the front matter (YAML header) from the existing `publications.md` file
10. Writes the generated content to the output file

### BibTeX Entry Types Supported

- `@article`
- `@inproceedings`
- `@incollection`
- `@book`
- `@chapter`

Other entry types are skipped.

### Publication Numbering

The script automatically numbers publications for display. You can control the exact order by adding a `location` field to BibTeX entries:

- **With `location`**: The number you specify will be used exactly as provided
- **Without `location`**: The script auto-assigns sequential numbers based on chronological order (oldest first)
- **Numbering scheme**:
  - **Submitted**: Continuous numbering starting from 1 (oldest first)
  - **2021+ publications**: Continuous numbering starting from 1 for oldest in 2021
  - **Prior to UIUC**: Restarts numbering at 1 (oldest first)
- **Display order**: 
  - **Submitted** section appears first
  - Then year sections (newest first)
  - Then "Prior to UIUC" section
  - Within each section, publications are displayed newest first (highest number first)

### Notes

- **The script will overwrite the output file** (default: `pages/publications.md`)
- **A backup is automatically created** before overwriting (saved as `pages/publications.md.backup`)
- Publications without a year are grouped under "Older"
- The script preserves the front matter (YAML header) from the existing file
- DOI and PMID fields are optional
- The navigation bar shows "Submitted" first (if present), then the most recent 10 years, then "Prior to UIUC" link
- Special characters in titles and authors are escaped for Liquid syntax

## Complete Workflow

To update the publications page from BibTeX files:

```bash
# 1. Clean the BibTeX files (if needed)
ruby scripts/clean_bibtex.rb assets/jackson_preprints.bib assets/jackson_preprints.bib
ruby scripts/clean_bibtex.rb assets/jackson_old_pubs.bib assets/jackson_old_pubs.bib
ruby scripts/clean_bibtex.rb assets/jackson_pubs.bib assets/jackson_pubs.bib

# 2. Generate the publications page (uses default file names)
arch -x86_64 bundle exec ruby scripts/bibtex_to_publications.rb

# Or specify custom files:
arch -x86_64 bundle exec ruby scripts/bibtex_to_publications.rb assets/jackson_preprints.bib assets/jackson_old_pubs.bib assets/jackson_pubs.bib pages/publications.md

# 3. Rebuild Jekyll site to see changes
arch -x86_64 bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch
```

## Example BibTeX Entries

### Basic Entry (Auto-numbered)

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

This will generate (with auto-assigned number based on chronological order, authors formatted as "Initials Last"):

```liquid
{% include publication number="18" authors="J. Smith and J. Doe" title="Example Publication Title" journal="Journal of Examples" doi="10.1234/example.2024.001" pmid="12345678"%}
```

### Entry with Manual Ordering

```bibtex
@article{example2024manual,
  author = {Smith, John and Doe, Jane},
  title = {Example Publication Title},
  journal = {Journal of Examples},
  year = {2024},
  location = {25},
  doi = {10.1234/example.2024.001}
}
```

This will generate (using the specified `location`, authors formatted as "Initials Last"):

```liquid
{% include publication number="25" authors="J. Smith and J. Doe" title="Example Publication Title" journal="Journal of Examples" doi="10.1234/example.2024.001"%}
```

**Note**: When using `location`, the script will use your specified number exactly. For entries without `location`, numbers are auto-assigned sequentially based on chronological order.

### Preprint Entry (Submitted Section)

```bibtex
@article{example2024preprint,
  author = {Smith, John and Doe, Jane},
  title = {Example Preprint Title},
  year = {2024},
  arxiv = {2301.12345},
  status = {in review}
}
```

Or with full URL:

```bibtex
@article{example2024preprint,
  author = {Smith, John and Doe, Jane},
  title = {Example Preprint Title},
  year = {2024},
  arxiv = {https://arxiv.org/abs/2301.12345},
  status = {submitted}
}
```

For ChemRxiv or bioRxiv, use full URLs:

```bibtex
@article{example2024chemrxiv,
  author = {Smith, John and Doe, Jane},
  title = {Example Preprint Title},
  year = {2024},
  arxiv = {https://chemrxiv.org/engage/chemrxiv/article-details/...},
  status = {in press}
}
```

This will generate (appears in "Submitted" section, authors formatted as "Initials Last"):

```liquid
{% include publication number="1" authors="J. Smith and J. Doe" title="Example Preprint Title" status="in review" arxiv="2301.12345"%}
```

### Author Formatting Examples

The script automatically converts author names to "Initials Last" format:

- **"Last, First" format**: `{Jackson, Nicholas}` → `N. Jackson`
- **"First Last" format**: `{Nicholas Jackson}` → `N. Jackson`
- **Hyphenated names**: `{Chun-I Wang}` → `C.-I. Wang`
- **Already initials**: `{J.L. Wu}` → `J.L. Wu` (preserved as-is)
- **Multiple authors**: `{Smith, John and Doe, Jane and Brown, Bob}` → `J. Smith, J. Doe and B. Brown`
- **Special case with "..." and "et al."**: `{Ferguson, Andrew and ... and Jackson, Nick and et al.}` → `A. Ferguson,..., N. Jackson, et al.`

