# froggeR

[![CRAN
status](https://www.r-pkg.org/badges/version/froggeR)](https://CRAN.R-project.org/package=froggeR)
[![CRAN
downloads](https://cranlogs.r-pkg.org/badges/froggeR)](https://cran.r-project.org/package=froggeR)
[![CRAN
downloads](https://cranlogs.r-pkg.org/badges/grand-total/froggeR)](https://cran.r-project.org/package=froggeR)

> **froggeR**: Leap into structured Quarto projects

R has strong conventions for packages, but analytical projects have not
always had the same structure. My own projects were no exception.
Scripts, Quarto documents, stylesheets, and data files piled up in root
directories like laundry on a chair. Inspired by the [research
compendium](https://doi.org/10.1080/00031305.2017.1375986) (Marwick,
Boettiger, & Mullen, 2018),
[froggeR](https://kylegrealis.github.io/froggeR/) gives your Quarto
projects a predictable layout: `R/` for scripts, `analysis/` for Quarto
(and .Rmd) documents, `data/` for data files, `www/` for assets. The
same conventions carry over whether you’re writing an analysis, building
an R package, or picking up a new language.

``` r

install.packages("froggeR")
froggeR::init(path = "my_project")
```

## Why `{froggeR}`?

[froggeR](https://kylegrealis.github.io/froggeR/) gives every project a
consistent layout so you spend time analyzing, not organizing:

- **Structure by default**:
  [`init()`](https://kylegrealis.github.io/froggeR/reference/init.md)
  downloads the latest scaffold and you’re working in seconds. Scripts
  go in `R/`, Quarto documents in `analysis/`, assets in `www/`, data in
  `data/`.
- **Opinionated starting points**: `R/_load.R`, `R/_libraries.R`, and
  `R/_data_dictionary.R` give every project a consistent entry point.
  [`write_quarto()`](https://kylegrealis.github.io/froggeR/reference/write_quarto.md)
  creates pre-formatted `.qmd` files with your author info and branding
  baked in.
- **Configure once, reuse everywhere**:
  [`write_variables()`](https://kylegrealis.github.io/froggeR/reference/write_variables.md)
  and
  [`write_brand()`](https://kylegrealis.github.io/froggeR/reference/write_brand.md)
  create your metadata and branding files. Save globally with
  [`save_variables()`](https://kylegrealis.github.io/froggeR/reference/save_variables.md)
  and
  [`save_brand()`](https://kylegrealis.github.io/froggeR/reference/save_brand.md),
  and every future project picks them up automatically.
- **Protected by default**: An opinionated `.gitignore` keeps sensitive
  data and common R artifacts out of version control.
- **AI agent ready**: Includes `AGENTS.md` (`CLAUDE.md`, `GEMINI.md`)
  and `.agents/skills/` (`frogger-workflow`, `frogger-brand`,
  `frogger-devlog`, `frogger-commit`) so AI coding assistants follow
  your project conventions automatically.
- **Transferable habits**: The same directory conventions used here
  mirror what you’ll find in R packages, Shiny frameworks like rhino,
  and other languages entirely.

------------------------------------------------------------------------

## Installation

``` r

install.packages("froggeR")
```

## Project Creation

Initialize a complete project with a single command:

``` r

froggeR::init(path = "my_new_project")
```

This creates:

    my_new_project/
    ├── .agents/                  # AI agent skills (workflow, brand, devlog, commit)
    ├── R/
    │   ├── _data_dictionary.R    # Variable labels and metadata
    │   ├── _libraries.R          # Centralized package loading
    │   └── _load.R               # Sources everything. Your entry point.
    ├── analysis/
    │   ├── index.qmd             # Main Quarto document
    │   └── references.bib        # Bibliography
    ├── www/
    │   ├── custom.scss           # Custom styling
    │   └── tables.js             # Table enhancements
    ├── logos/                    # Brand logos
    ├── data/                     # Data files (gitignored)
    ├── AGENTS.md                 # Project conventions for AI coding assistants
    ├── CLAUDE.md                 # Pointer to AGENTS.md and .agents/skills/
    ├── GEMINI.md                 # Pointer to AGENTS.md and .agents/skills/
    ├── _brand.yml                # Quarto brand configuration
    ├── _quarto.yml               # Quarto project configuration
    ├── _variables.yml            # Author metadata
    ├── .gitignore                # Opinionated git protection
    └── README.md

## Configuration & Reusability

[froggeR](https://kylegrealis.github.io/froggeR/) stores configuration
at two levels: global (system-wide) and project-local. Set it up once,
and every future project inherits your settings.

``` r

froggeR::write_variables() # Create/edit _variables.yml (author metadata)
froggeR::write_brand()     # Create/edit _brand.yml (colors, logos, typography)
```

Both functions create the file if it does not exist, or open it for
editing if it does. New files start from your global config or the
remote template. When you’re happy, persist to global config:

``` r

froggeR::save_variables()  # Save project metadata for reuse
froggeR::save_brand()      # Save project branding for reuse
```

Global settings populate every new project created with
[`init()`](https://kylegrealis.github.io/froggeR/reference/init.md).
Edit the project copy directly when you need something specific.

## Templated Quarto Documents

Quickly generate new Quarto documents with pre-formatted headers:

``` r

froggeR::write_quarto(filename = "monthly_report")
```

Your saved metadata automatically populates author information and
branding.

## Enhanced Git Protection

[froggeR](https://kylegrealis.github.io/froggeR/) includes a
`.gitignore` that covers R artifacts, Quarto build files, data files,
and common sensitive patterns:

``` r

froggeR::write_ignore()
```

One set of rules. Comprehensive by default. If your project needs
additional exclusions, edit `.gitignore` directly.

## Custom Styling Made Easy

Generate a SCSS template for custom document styling:

``` r

froggeR::write_scss()
froggeR::write_scss("tables")
```

Provides a formatted stylesheet with:

- SCSS defaults
- SCSS mixins
- SCSS rules

Customize your document’s appearance by uncommenting desired styles.

------------------------------------------------------------------------

## Function Reference

| Function | Description |
|----|----|
| [`init()`](https://kylegrealis.github.io/froggeR/reference/init.md) | Initialize a complete project from the latest remote template |
| [`write_quarto()`](https://kylegrealis.github.io/froggeR/reference/write_quarto.md) | Create a Quarto document in `analysis/` |
| [`write_variables()`](https://kylegrealis.github.io/froggeR/reference/write_variables.md) | Create a `_variables.yml` metadata file |
| [`write_brand()`](https://kylegrealis.github.io/froggeR/reference/write_brand.md) | Create a `_brand.yml` brand configuration file |
| [`save_variables()`](https://kylegrealis.github.io/froggeR/reference/save_variables.md) | Save project `_variables.yml` to global config |
| [`save_brand()`](https://kylegrealis.github.io/froggeR/reference/save_brand.md) | Save project `_brand.yml` to global config |
| [`write_ignore()`](https://kylegrealis.github.io/froggeR/reference/write_ignore.md) | Create an opinionated `.gitignore` |
| [`write_scss()`](https://kylegrealis.github.io/froggeR/reference/write_scss.md) | Create a `custom.scss` styling template in `www/` |

------------------------------------------------------------------------

## Getting Help

- **Documentation**: [froggeR
  website](https://kylegrealis.github.io/froggeR/) for full function
  references and vignettes
- **Vignettes**:
  - [From Zero to
    Project](https://kylegrealis.github.io/froggeR/articles/from-zero-to-project.html)
  - [Every File in Its
    Place](https://kylegrealis.github.io/froggeR/articles/every-file-in-its-place.html)
- **Issues**: Found a bug or have a feature request? [Open an
  issue](https://github.com/kyleGrealis/froggeR/issues)

------------------------------------------------------------------------

## Contributing

We welcome contributions and ideas! Here’s how you can help:

- **Report bugs** - [Open an
  issue](https://github.com/kyleGrealis/froggeR/issues) with a clear
  description
- **Suggest features** - Have an idea? [Submit a feature
  request](https://github.com/kyleGrealis/froggeR/issues)
- **Share feedback** - Let us know how
  [froggeR](https://kylegrealis.github.io/froggeR/) is working for you
- **Improve documentation** - Help us make docs clearer and more
  complete

------------------------------------------------------------------------

## License

[froggeR](https://kylegrealis.github.io/froggeR/) is licensed under the
[MIT License](https://choosealicense.com/licenses/mit/). See the LICENSE
file for details.

------------------------------------------------------------------------

**Developed by [Kyle Grealis](https://github.com/kyleGrealis)**
