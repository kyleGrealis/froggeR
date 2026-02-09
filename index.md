# froggeR

> **froggeR**: Structured project standards for R and Quarto

Most programming languages have conventions for where files belong. R
rarely agrees on one, and it shows. Scripts, Quarto documents,
stylesheets, and data files pile up in root directories like laundry on
a chair. froggeR offers a standard: `R/` for scripts, `pages/` for
Quarto documents, `data/` for data files, `www/` for assets. Build
habits that carry over whether you’re writing an analysis, building an R
package, or picking up a new language entirely.

## Table of Contents

- [Why froggeR?](#why-frogger)
- [Installation](#installation)
- [Project Creation](#id_-project-creation)
- [Configuration & Reusability](#id_-configuration--reusability)
- [Templated Quarto Documents](#id_-templated-quarto-documents)
- [Git Protection](#id_%EF%B8%8F-enhanced-git-protection)
- [Custom Styling](#id_-custom-styling-made-easy)
- [Function Reference](#function-reference)
- [Getting Help](#getting-help)
- [Contributing](#contributing)
- [License](#license)

## Why froggeR?

froggeR gives every project the same enforced layout so you spend time
analyzing, not organizing:

- **Structure by default**:
  [`init()`](https://www.kyleGrealis.com/froggeR/reference/init.md)
  downloads the latest scaffold and you’re working in seconds. Scripts
  go in `R/`, Quarto documents in `pages/`, assets in `www/`, data in
  `data/`. Every project, every time.
- **Opinionated starting points**: `R/_load.R`, `R/_libraries.R`, and
  `R/_data_dictionary.R` give every project a consistent entry point.
  [`write_quarto()`](https://www.kyleGrealis.com/froggeR/reference/write_quarto.md)
  creates pre-formatted `.qmd` files with your author info and branding
  baked in.
- **Configure once, reuse everywhere**:
  [`write_variables()`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md)
  and
  [`write_brand()`](https://www.kyleGrealis.com/froggeR/reference/write_brand.md)
  create your metadata and branding files. Save globally with
  [`save_variables()`](https://www.kyleGrealis.com/froggeR/reference/save_variables.md)
  and
  [`save_brand()`](https://www.kyleGrealis.com/froggeR/reference/save_brand.md),
  and every future project picks them up automatically.
- **Protected by default**: An opinionated `.gitignore` and pre-commit
  hooks keep sensitive data and common R artifacts out of version
  control.
- **Transferable habits**: The same directory conventions used here
  mirror what you’ll find in R packages, Shiny frameworks like golem and
  rhino, and other languages entirely. Good habits compound.

------------------------------------------------------------------------

## Installation

``` r
install.packages("froggeR")
```

## 🎯 Project Creation

Initialize a complete project with a single command:

``` r
froggeR::init(path = "my_new_project")
```

This creates:

    my_new_project/
    ├── R/
    │   ├── _data_dictionary.R   # Variable labels and metadata
    │   ├── _libraries.R         # Centralized package loading
    │   └── _load.R              # Sources everything. Your entry point.
    ├── pages/
    │   ├── index.qmd            # Main Quarto document
    │   └── references.bib       # Bibliography
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

## 🔧 Configuration & Reusability

froggeR stores configuration at two levels: global (system-wide) and
project-local. Set it up once, and every future project inherits your
settings.

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
[`init()`](https://www.kyleGrealis.com/froggeR/reference/init.md). Edit
the project copy directly when you need something specific.

## 📝 Templated Quarto Documents

Quickly generate new Quarto documents with pre-formatted headers:

``` r
froggeR::write_quarto(filename = "monthly_report")
```

Your saved metadata automatically populates author information and
branding.

## 🛡️ Enhanced Git Protection

froggeR includes a `.gitignore` that covers R artifacts, Quarto build
files, data files, and common sensitive patterns:

``` r
froggeR::write_ignore()
```

One set of rules. Comprehensive by default. If your project needs
additional exclusions, edit `.gitignore` directly.

## 🌟 Custom Styling Made Easy

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

| Function                                                                                | Description                                                                                |
|-----------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|
| [`init()`](https://www.kyleGrealis.com/froggeR/reference/init.md)                       | Initialize a complete project from the latest remote template                              |
| [`quarto_project()`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md)   | **Removed.** Use [`init()`](https://www.kyleGrealis.com/froggeR/reference/init.md) instead |
| [`write_quarto()`](https://www.kyleGrealis.com/froggeR/reference/write_quarto.md)       | Create a Quarto document in `pages/`                                                       |
| [`write_variables()`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md) | Create a `_variables.yml` metadata file                                                    |
| [`write_brand()`](https://www.kyleGrealis.com/froggeR/reference/write_brand.md)         | Create a `_brand.yml` brand configuration file                                             |
| [`save_variables()`](https://www.kyleGrealis.com/froggeR/reference/save_variables.md)   | Save project `_variables.yml` to global config                                             |
| [`save_brand()`](https://www.kyleGrealis.com/froggeR/reference/save_brand.md)           | Save project `_brand.yml` to global config                                                 |
| [`write_ignore()`](https://www.kyleGrealis.com/froggeR/reference/write_ignore.md)       | Create an opinionated `.gitignore`                                                         |
| [`write_scss()`](https://www.kyleGrealis.com/froggeR/reference/write_scss.md)           | Create a `custom.scss` styling template in `www/`                                          |

------------------------------------------------------------------------

## Getting Help

- **Documentation**: [froggeR
  website](https://www.kyleGrealis.com/froggeR/) for full function
  references and vignettes
- **Vignettes**:
  - [From Zero to
    Project](https://www.kyleGrealis.com/froggeR/articles/from-zero-to-project.html)
  - [Every File in Its
    Place](https://www.kyleGrealis.com/froggeR/articles/every-file-in-its-place.html)
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
- **Share feedback** - Let us know how froggeR is working for you
- **Improve documentation** - Help us make docs clearer and more
  complete

------------------------------------------------------------------------

## License

froggeR is licensed under the [MIT
License](https://choosealicense.com/licenses/mit/). See the LICENSE file
for details.

------------------------------------------------------------------------

## Acknowledgments

froggeR is built with these excellent packages: -
[cli](https://cli.r-lib.org/) - User-friendly command line interfaces -
[fs](https://fs.r-lib.org/) - Cross-platform file system operations -
[here](https://here.r-lib.org/) - Project-oriented workflows -
[usethis](https://usethis.r-lib.org/) - Workflow automation -
[rappdirs](https://rappdirs.r-lib.org/) - Cross-platform configuration
paths

------------------------------------------------------------------------

**Developed by [Kyle Grealis](https://github.com/kyleGrealis)**
