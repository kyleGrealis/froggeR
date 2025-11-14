# From Zero to Project in Seconds

## Introduction

Starting a new Quarto project usually involves multiple tedious steps:
creating directories, copying templates, configuring YAML files, setting
up version control, creating initial documents.

The
[`quarto_project()`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md)
function changes this. With a single command, you get a complete,
production-ready Quarto project with all configuration, styling, and
scaffolding you need to start working immediately.

## What Gets Created?

When you run
[`quarto_project()`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md),
froggeR creates a complete project structure:

    my-project/
    ├── _brand.yml                    # Branding configuration
    ├── _quarto.yml                   # Quarto project configuration
    ├── _variables.yml                # Author metadata
    ├── custom.scss                   # Custom styling
    ├── .gitignore                    # Enhanced version control settings
    ├── README.md                     # Project documentation
    ├── dated_progress_notes.md       # Project tracking
    ├── references.bib                # Bibliography template
    └── my-project.qmd                # Initial Quarto document

Every file is configured, ready to use, and integrated with your global
settings.

## The Basic Workflow

### Step 1: Ensure You Have Quarto 1.6+

froggeR requires Quarto 1.6+ for branding support:

``` r
quarto::quarto_version()
# [1] '1.6.33'
```

If needed, upgrade at <https://quarto.org/docs/download/>.

### Step 2: Configure Your Settings (Recommended)

Configure your global metadata and branding:

``` r
froggeR::settings()
froggeR::brand_settings()
```

This is optional but ensures your projects automatically include your
author information and branding.

### Step 3: Create Your Project

Run
[`quarto_project()`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md)
with a project name:

``` r
froggeR::quarto_project(name = "sleep-analysis")
```

That’s it. froggeR creates the complete project structure and opens it
in a new Positron or RStudio session.

## A Complete Example

Let’s walk through a real-world example with Dr. Rachel Kim.

Rachel has configured global settings:

- **Metadata**: Name, email, ORCID, affiliation (via
  [`settings()`](https://www.kyleGrealis.com/froggeR/reference/settings.md))
- **Branding**: Kim Lab name, logo, and blue color (via
  [`brand_settings()`](https://www.kyleGrealis.com/froggeR/reference/brand_settings.md))

She’s starting a new analysis project:

``` r
> froggeR::quarto_project(name = "sleep-deprivation-study", path = "~/research", example = TRUE)

✔ Created Quarto project directory: sleep-deprivation-study
✔ Created _quarto.yml
ℹ Copying existing froggeR settings...
✔ Created _variables.yml
ℹ Copying existing froggeR brand settings...
✔ Created _brand.yml
✔ Created custom.scss
✔ Created .gitignore
✔ Created README.md
✔ Created dated_progress_notes.md
✔ Created sleep-deprivation-study.qmd with examples
✔ Created references.bib
✔ froggeR project setup complete. Opening in new session...
```

A new Positron or RStudio session opens with the complete project ready
to go.

## What Was Created?

Each file serves a specific purpose:

**`_quarto.yml`** - Project configuration with sensible defaults for
HTML rendering, table of contents, code folding, and bibliography
support; references variables from `_variables.yml`

**`_variables.yml`** - Author metadata automatically populated from
global settings

**`_brand.yml`** - Branding configuration automatically copied from
global settings (see [Building Your Brand
Identity](https://www.kyleGrealis.com/froggeR/articles/building-your-brand-identity.md)
for details)

**`custom.scss`** - SCSS template for custom styling, ready for
customization

**`.gitignore`** - Pre-configured to exclude R and Quarto artifacts

**`README.md`** - Template for project documentation

**`dated_progress_notes.md`** - Dated file for tracking project progress

**`references.bib`** - Template bibliography file for citations

**`sleep-deprivation-study.qmd`** - Initial Quarto document with
examples (because `example = TRUE`)

## Function Parameters

### `name` (required)

The project name. Used for directory name, .qmd filename, and project
title.

**Rules**: Only letters, numbers, hyphens, and underscores

``` r
# Good
froggeR::quarto_project(name = "my-analysis")
froggeR::quarto_project(name = "study_2024")

# Bad
froggeR::quarto_project(name = "my analysis")  # Spaces not allowed
froggeR::quarto_project(name = "study@2024")  # Special characters not allowed
```

### `path` (optional)

Where to create the project. Defaults to current working directory.

``` r
# Create in current directory
froggeR::quarto_project(name = "analysis")

# Create in specific location
froggeR::quarto_project(name = "analysis", path = "~/research/projects")
```

### `example` (optional, default = `TRUE`)

Whether to include examples in the initial `.qmd` file.

- `example = TRUE`: Includes example content showing Quarto features
- `example = FALSE`: Creates a minimal Quarto document

``` r
# With examples (default)
froggeR::quarto_project(name = "learning-project")

# Minimal document
froggeR::quarto_project(name = "analysis", example = FALSE)
```

## How It Works

The execution sequence:

1.  **Validate inputs**: Check Quarto version, path validity, project
    name format
2.  **Create project directory**: Call
    [`quarto::quarto_create_project()`](https://quarto-dev.github.io/quarto-r/reference/quarto_create_project.html)
3.  **Remove default files**: Delete Quarto’s default files
4.  **Add custom `_quarto.yml`**: Copy froggeR’s template with title
    updated
5.  **Write configuration files**: Call helper functions in sequence
    - [`write_variables()`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md) -
      Author metadata
    - [`write_brand()`](https://www.kyleGrealis.com/froggeR/reference/write_brand.md) -
      Branding configuration
    - [`write_scss()`](https://www.kyleGrealis.com/froggeR/reference/write_scss.md) -
      Custom styling
    - [`write_ignore()`](https://www.kyleGrealis.com/froggeR/reference/write_ignore.md) -
      Version control settings
    - [`write_readme()`](https://www.kyleGrealis.com/froggeR/reference/write_readme.md) -
      Documentation template
    - [`write_notes()`](https://www.kyleGrealis.com/froggeR/reference/write_notes.md) -
      Progress tracking
    - [`write_quarto()`](https://www.kyleGrealis.com/froggeR/reference/write_quarto.md) -
      Initial Quarto document
6.  **Copy references template**: Add `references.bib`
7.  **Open in new session**: Launch Positron or RStudio with the new
    project

## Global Settings Integration

When
[`write_variables()`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md)
and
[`write_brand()`](https://www.kyleGrealis.com/froggeR/reference/write_brand.md)
run, they check for global settings:

- If global `config.yml` exists → copy to project `_variables.yml`
- If global `_brand.yml` exists → copy to project `_brand.yml`
- If neither exists → create minimal templates

This is why configuring global settings first is powerful—your projects
automatically inherit them.

## Time Savings

Comparison: Manual vs. froggeR

**Manual process** (15-20 minutes):  
1. Create project directory  
2. Initialize Quarto project  
3. Create and configure `_quarto.yml`  
4. Create `_variables.yml` and type author info  
5. Create `_brand.yml`  
6. Create and configure `custom.scss`  
7. Set up `.gitignore`  
8. Create README, progress file, initial document  
9. Create `references.bib`  
10. Test render and fix configuration errors

**froggeR process** (30 seconds): 1. Run
`froggeR::quarto_project(name = "my-project")`

**Annual savings** (20 projects/year):  
- Manual: 20 × 17.5 min = 350 min (5.8 hours)  
- froggeR: 20 × 0.5 min = 10 min  
- **Saved: 340 minutes per year**

## Error Handling

### “You need Quarto version 1.6 or greater”

Upgrade Quarto at <https://quarto.org/docs/download/>

### “Invalid `path`. Please enter a valid project directory.”

The `path` parameter must point to an existing directory:

``` r
# Create directory if needed
dir.create("~/research", recursive = TRUE)

# Then create project
froggeR::quarto_project(name = "analysis", path = "~/research")
```

### “Directory named ‘my-project’ exists”

Choose a different name or remove the existing directory:

``` r
# Different name
froggeR::quarto_project(name = "my-project-v2")

# Or remove existing (be careful!)
unlink("~/research/my-project", recursive = TRUE)
```

### “Invalid project name”

Project names must use only letters, numbers, hyphens, and underscores:

``` r
# Good
froggeR::quarto_project(name = "my-analysis")
froggeR::quarto_project(name = "study_2024")

# Bad
froggeR::quarto_project(name = "my analysis!")
```

## Customizing After Creation

After
[`quarto_project()`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md)
creates your project, you can customize:

- **`_quarto.yml`**: Modify project-level defaults (table of contents
  depth, code folding, layout, and references variables from
  `_variables.yml`)
- **`custom.scss`**: Add custom styling for callouts, figures, custom
  classes
- **`references.bib`**: Add your citations
- **`dated_progress_notes.md`**: Track project progress
- **`README.md`**: Document your project

## Integration with Version Control

The `.gitignore` is pre-configured for R and Quarto projects:

``` bash
cd my-project
git init
git add .
git commit -m "Initial project setup with froggeR"
```

What gets committed:  
- All configuration files  
- All templates  
- Initial Quarto document  
- Progress notes

What gets ignored:  
- R session data (`.RData`, `.Rhistory`, etc.)  
- Quarto build artifacts (`/.quarto/`, `/_site/`)  
- Rendered HTML files (unless modified)

## Next Steps

Explore how
[`quarto_project()`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md)
integrates with the broader froggeR ecosystem:

- [Set Once, Use
  Everywhere](https://www.kyleGrealis.com/froggeR/articles/set-once-use-everywhere.md) -
  Understand global settings
- [Your Metadata, Your
  Way](https://www.kyleGrealis.com/froggeR/articles/your-metadata-your-way.md) -
  Deep dive into
  [`settings()`](https://www.kyleGrealis.com/froggeR/reference/settings.md)
- [Building Your Brand
  Identity](https://www.kyleGrealis.com/froggeR/articles/building-your-brand-identity.md) -
  Deep dive into
  [`brand_settings()`](https://www.kyleGrealis.com/froggeR/reference/brand_settings.md)

## Summary

The
[`quarto_project()`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md)
function transforms project creation from 15-20 minutes to 30 seconds:

- **Creates complete project structure** with all necessary files
- **Integrates global settings** for metadata and branding
- **Provides working examples** (optional) for learning
- **Configures version control** appropriately
- **Opens in new session** for immediate productivity

Key parameters:

- `name`: Project name (required)
- `path`: Where to create project (optional, defaults to current
  directory)
- `example`: Include example content (optional, defaults to `TRUE`)

By combining
[`settings()`](https://www.kyleGrealis.com/froggeR/reference/settings.md),
[`brand_settings()`](https://www.kyleGrealis.com/froggeR/reference/brand_settings.md),
and
[`quarto_project()`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md),
you create a powerful workflow that eliminates repetitive setup and lets
you focus on your actual work.
