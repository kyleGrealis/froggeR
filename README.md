# froggeR <img src="man/figures/logo.png" align="right" height="130"  alt="" />

<!-- badges: start -->
[![R CMD check: passing](https://img.shields.io/badge/R_CMD_check-passing-brightgreen.svg)](https://github.com/kyleGrealis/froggeR)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![Tests: passing](https://img.shields.io/badge/tests-passing-brightblue.svg)](https://github.com/kyleGrealis/froggeR/tree/main/tests/testthat)
[![CRAN downloads](https://cranlogs.r-pkg.org/badges/grand-total/froggeR)](https://cran.r-project.org/package=froggeR)
<!-- badges: end -->

> **froggeR**: Structured project standards for R and Quarto

Most programming languages have conventions for where files belong. R rarely agrees on one, and it shows. Scripts, Quarto documents, stylesheets, and data files pile up in root directories like laundry on a chair. `{froggeR}` offers a standard: `R/` for scripts, `pages/` for Quarto documents, `data/` for data files, `www/` for assets. Build habits that carry over whether you're writing an analysis, building an R package, or picking up a new language entirely.

```r
install.packages("froggeR")
froggeR::init(path = "my_project")
```

## Why `{froggeR}`?

`{froggeR}` gives every project the same enforced layout so you spend time analyzing, not organizing:

* **Structure by default**: `init()` downloads the latest scaffold and you're working in seconds. Scripts go in `R/`, Quarto documents in `pages/`, assets in `www/`, data in `data/`. Every project, every time.
* **Opinionated starting points**: `R/_load.R`, `R/_libraries.R`, and `R/_data_dictionary.R` give every project a consistent entry point. `write_quarto()` creates pre-formatted `.qmd` files with your author info and branding baked in.
* **Configure once, reuse everywhere**: `write_variables()` and `write_brand()` create your metadata and branding files. Save globally with `save_variables()` and `save_brand()`, and every future project picks them up automatically.
* **Protected by default**: An opinionated `.gitignore` and pre-commit hooks keep sensitive data and common R artifacts out of version control.
* **Transferable habits**: The same directory conventions used here mirror what you'll find in R packages, Shiny frameworks like golem and rhino, and other languages entirely. Good habits compound.

----

## Installation

```r
install.packages("froggeR")
```

## Project Creation

Initialize a complete project with a single command:

```r
froggeR::init(path = "my_new_project")
```

This creates:

```
my_new_project/
├── R/
│   ├── _data_dictionary.R    # Variable labels and metadata
│   ├── _libraries.R          # Centralized package loading
│   └── _load.R               # Sources everything. Your entry point.
├── pages/ 
│   ├── index.qmd             # Main Quarto document
│   └── references.bib        # Bibliography
├── www/
│   ├── custom.scss           # Custom styling
│   └── tables.js             # Table enhancements
├── logos/                    # Brand logos
├── data/                     # Data files (gitignored)
├── _brand.yml                # Quarto brand configuration
├── _quarto.yml               # Quarto project configuration
├── _variables.yml            # Author metadata
├── .gitignore                # Opinionated git protection
├── .pre-commit-config.yaml   # Pre-commit hook configuration
└── README.md
```

## Configuration & Reusability

`{froggeR}` stores configuration at two levels: global (system-wide) and project-local. Set it up once, and every future project inherits your settings.

```r
froggeR::write_variables() # Create/edit _variables.yml (author metadata)
froggeR::write_brand()     # Create/edit _brand.yml (colors, logos, typography)
```

Both functions create the file if it does not exist, or open it for editing if it does. New files start from your global config or the remote template. When you're happy, persist to global config:

```r
froggeR::save_variables()  # Save project metadata for reuse
froggeR::save_brand()      # Save project branding for reuse
```

Global settings populate every new project created with `init()`. Edit the project copy directly when you need something specific.

## Templated Quarto Documents

Quickly generate new Quarto documents with pre-formatted headers:

```r
froggeR::write_quarto(filename = "monthly_report")
```

Your saved metadata automatically populates author information and branding.

## Enhanced Git Protection

`{froggeR}` includes a `.gitignore` that covers R artifacts, Quarto build files, data files, and common sensitive patterns:

```r
froggeR::write_ignore()
```

One set of rules. Comprehensive by default. If your project needs additional exclusions, edit `.gitignore` directly.

## Custom Styling Made Easy

Generate a SCSS template for custom document styling:

```r
froggeR::write_scss()
froggeR::write_scss("tables")
```

Provides a formatted stylesheet with:

* SCSS defaults
* SCSS mixins
* SCSS rules

Customize your document's appearance by uncommenting desired styles.

----

## Function Reference

| Function | Description |
|----------|-------------|
| `init()` | Initialize a complete project from the latest remote template |
| `write_quarto()` | Create a Quarto document in `pages/` |
| `write_variables()` | Create a `_variables.yml` metadata file |
| `write_brand()` | Create a `_brand.yml` brand configuration file |
| `save_variables()` | Save project `_variables.yml` to global config |
| `save_brand()` | Save project `_brand.yml` to global config |
| `write_ignore()` | Create an opinionated `.gitignore` |
| `write_scss()` | Create a `custom.scss` styling template in `www/` |

----

## Getting Help

* **Documentation**: [froggeR website](https://www.kyleGrealis.com/froggeR/) for full function references and vignettes
* **Vignettes**:
  * [From Zero to Project](https://www.kyleGrealis.com/froggeR/articles/from-zero-to-project.html)
  * [Every File in Its Place](https://www.kyleGrealis.com/froggeR/articles/every-file-in-its-place.html)
* **Issues**: Found a bug or have a feature request? [Open an issue](https://github.com/kyleGrealis/froggeR/issues)

----

## Contributing

We welcome contributions and ideas! Here's how you can help:

* **Report bugs** - [Open an issue](https://github.com/kyleGrealis/froggeR/issues) with a clear description
* **Suggest features** - Have an idea? [Submit a feature request](https://github.com/kyleGrealis/froggeR/issues)
* **Share feedback** - Let us know how `{froggeR}` is working for you
* **Improve documentation** - Help us make docs clearer and more complete

----

## License

`{froggeR}` is licensed under the [MIT License](https://choosealicense.com/licenses/mit/). See the LICENSE file for details.

---

**Developed by [Kyle Grealis](https://github.com/kyleGrealis)**
