# Your Metadata, Your Way

## Introduction

The
[`settings()`](https://www.kyleGrealis.com/froggeR/reference/settings.md)
function is your gateway to effortless metadata management in froggeR.
Whether you’re a researcher publishing papers, a data analyst sharing
reports, or anyone who creates Quarto documents,
[`settings()`](https://www.kyleGrealis.com/froggeR/reference/settings.md)
helps you maintain consistent author information across all your
projects.

## What Metadata Does froggeR Store?

froggeR manages six metadata fields:

1.  **Name** (required): Your full name as it appears in publications
2.  **Email** (required): Your contact email address
3.  **ORCID** (optional): Your ORCID identifier (e.g.,
    0000-0001-2345-6789)
4.  **URL** (optional): Your personal website or profile URL
5.  **GitHub** (optional): Your GitHub username
6.  **Affiliations** (optional): Your institution, department, or
    organization

## The Interactive Workflow

Let’s walk through how
[`settings()`](https://www.kyleGrealis.com/froggeR/reference/settings.md)
works with a real-world example of Dr. Rachel Kim, a neuroscience
researcher.

### First-Time Setup

When Rachel runs
[`settings()`](https://www.kyleGrealis.com/froggeR/reference/settings.md)
for the first time:

``` r
> froggeR::settings()

froggeR Metadata Status
✖ No project-level metadata
✖ No global metadata

What would you like to do?

1: Create or update metadata
2: View current metadata
3: Exit

Selection: 1
```

froggeR guides her through creating metadata:

``` r
Enter your metadata (press Enter to skip optional fields):

Full name
  Your full name as it appears in publications
  : Dr. Rachel Kim

Email address
  Contact email
  : rachel.kim@neuroscience.edu

ORCID
  Optional (e.g., 0000-0001-2345-6789)
  : 0000-0002-1234-5678

Website or profile URL
  Optional (e.g., https://yoursite.com)
  : https://rachelkim.science

GitHub username
  Optional (e.g., octocat)
  : rkim-neuro

Affiliations
  Optional (e.g., Institution, Department)
  : University of Washington, Department of Neuroscience
```

After entering all fields, froggeR shows a preview:

``` r
Your metadata preview:

---
name: Dr. Rachel Kim
email: rachel.kim@neuroscience.edu
orcid: 0000-0002-1234-5678
url: https://rachelkim.science
github: rkim-neuro
affiliations: University of Washington, Department of Neuroscience
---
```

Rachel chooses to save globally so she can reuse it in all future
projects:

``` r
Where would you like to save this metadata?

1: Save to this project only
2: Save globally (reuse in all future projects)
3: Save to both locations
4: Cancel (discard changes)

Selection: 2

✔ Saved to global: /home/rachel/.config/froggeR/_variables.yml

✔ froggeR metadata configured successfully!

ℹ Your metadata will automatically be used in future froggeR projects.
```

## Input Validation

froggeR validates your input and provides helpful error messages:

**Email validation:**

``` r
Email address
  Contact email
  : rachel.kim

  Email must be in format: user@example.com
```

**ORCID validation:**

``` r
ORCID
  Optional (e.g., 0000-0001-2345-6789)
  : 1234-5678

  ORCID must be in format: 0000-0000-0000-0000
```

**URL validation:**

``` r
Website or profile URL
  Optional (e.g., https://yoursite.com)
  : rachelkim.science

  URL must start with http:// or https://
```

**GitHub username validation:**

``` r
GitHub username
  Optional (e.g., octocat)
  : -rkim-

  GitHub username: alphanumeric and hyphens only (no leading/trailing hyphens, max 39 chars)
```

## Updating Existing Metadata

When metadata exists, froggeR asks whether to update or start fresh:

``` r
Metadata already exists. What would you like to do?

1: Update existing metadata
2: Start fresh

Selection: 1
```

When updating, current values appear in brackets. You can press Enter to
keep them or type new values:

``` r
Full name
  Your full name as it appears in publications
  [Dr. Rachel Kim]:

# Press Enter to keep, or type new value

Email address
  Contact email
  [rachel.kim@neuroscience.edu]: rachel.kim@stanford.edu

# Type to change
```

## Project-Specific Overrides

Sometimes you need different metadata for a specific project:

``` r
Selection: 2

# Choose "Start fresh" to override your global settings for this project
```

Now this project has custom metadata while your global settings remain
unchanged.

## Where Is Metadata Stored?

froggeR stores metadata in two locations:

1.  **Project-level**: `_variables.yml` in your project directory
    - Used by current project only
    - Takes precedence over global settings
    - Committed to version control
2.  **Global**: Platform-specific configuration directory
    - Linux/macOS: `~/.config/froggeR/_variables.yml`
    - Windows:
      `C:\Users\<username>\AppData\Local\froggeR/_variables.yml`
    - Used as default for all new projects

## Next Steps

Now that you understand metadata management with
[`settings()`](https://www.kyleGrealis.com/froggeR/reference/settings.md),
explore:

- [Building Your Brand
  Identity](https://www.kyleGrealis.com/froggeR/articles/building-your-brand-identity.md) -
  Learn about
  [`brand_settings()`](https://www.kyleGrealis.com/froggeR/reference/brand_settings.md)
- [Set Once, Use
  Everywhere](https://www.kyleGrealis.com/froggeR/articles/set-once-use-everywhere.md) -
  Understand the global configuration philosophy
- [From Zero to Project in
  Seconds](https://www.kyleGrealis.com/froggeR/articles/from-zero-to-project.md) -
  See how
  [`quarto_project()`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md)
  uses your settings

## Summary

The
[`settings()`](https://www.kyleGrealis.com/froggeR/reference/settings.md)
function provides an interactive way to manage your author metadata:

- **Validates input** with helpful error messages
- **Stores globally** for reuse across all projects
- **Allows project-specific overrides** when needed
- **Shows clear previews** before saving
- **Provides flexible save options** to match your workflow

By configuring metadata once with
[`settings()`](https://www.kyleGrealis.com/froggeR/reference/settings.md),
you eliminate repetitive data entry and ensure consistency across all
your Quarto projects.
