# froggeR <img src="man/figures/logo.png" align="right" height="130"  alt="" />

<!-- badges: start -->
[![R CMD check: passing](https://img.shields.io/badge/R_CMD_check-passing-brightgreen.svg)](https://github.com/kyleGrealis/froggeR)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![Tests: 484 assertions](https://img.shields.io/badge/tests-484_assertions-brightblue.svg)](https://github.com/kyleGrealis/froggeR/tree/main/tests/testthat)
<!-- badges: end -->

> **froggeR version: 0.6.0** — Leap into Quarto with confidence

froggeR is an R package designed to streamline the creation and management of Quarto projects. It provides a suite of tools to automate setup, ensure consistency, and enhance collaboration in data science workflows.

## Table of Contents

- [Why froggeR?](#why-frogger)
- [Key Features](#key-features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Who's it for?](#whos-it-for)
- [Core Workflows](#core-workflows)
  - [Streamlined Project Creation](#-streamlined-quarto-project-creation)
  - [Configuration & Reusability](#-configuration--reusability)
  - [Templated Documents](#-templated-quarto-documents)
  - [Git Protection](#️-enhanced-git-protection)
  - [Custom Styling](#-custom-styling-made-easy)
  - [Project Documentation](#-automated-project-documentation)
- [Function Reference](#function-reference)
- [Input Validation](#input-validation)
- [Examples](#examples)
- [Testing & Quality](#testing--quality)
- [Getting Help](#getting-help)
- [Contributing](#contributing)
- [License](#license)

## Why froggeR?

> Leap ahead in your data science journey with froggeR! Streamline Quarto workflows, create structured projects, and enhance collaboration with ease. 🐸

froggeR simplifies project setup so you can focus on what matters:

* **Efficiency**: Minimize setup time, maximize analysis time
* **Consistency**: Uniform styling and structure across all your projects
* **Reliability**: Prevent common setup issues before they occur
* **Security**: Robust `.gitignore` settings for enhanced data protection
* **Collaboration**: Structured documentation for seamless team onboarding
* **Customization**: Easy-to-use tools for tailoring project aesthetics
* **Reproducibility**: Ensure consistent environments across team members
* **Reusability**: Save metadata and branding once, use everywhere

----

## Key Features

- **One-command Quarto project initialization** - Set up complete projects with `quarto_project(name)`
- **Interactive metadata configuration** - `settings()` manages author info, emails, ORCIDs, affiliations, and GitHub usernames
- **Interactive branding configuration** - `brand_settings()` provides core setup with advanced template editing options
- **Flexible `.gitignore` options** - Choose between minimal or aggressive data protection settings
- **Centralized settings management** - Save to project-level, global (system-wide), or both locations
- **Reusable metadata and branding** - Configure once, apply to all future projects automatically
- **Templated Quarto documents** - Auto-populate author info, branding, and styling
- **Custom YAML and SCSS** - Full control over document appearance and structure
- **Automated project files** - Generate READMs, progress notes, bibliographies, and more
- **Input validation** - Helpful error messages for emails, colors, ORCIDs, and other fields

----

## Installation

### From CRAN

```r
install.packages("froggeR")
```

### Development Version

```r
# Install using pak (recommended)
# install.packages("pak")
pak::pak("kyleGrealis/froggeR")

# Or use remotes
# install.packages("remotes")
remotes::install_github('kyleGrealis/froggeR')
```

## Quick Start

Get started with froggeR in just a few steps:

```r
library(froggeR)

# Step 1: Configure your metadata (one time, reused everywhere)
settings()

# Step 2: Configure your branding (optional, one time, reused everywhere)
brand_settings()

# Step 3: Create your first froggeR project
quarto_project('my_project')
```

----

## Who's it for?

froggeR is ideal for R users who:

* Manage multiple Quarto projects
* Find themselves rewriting the same YAML & project structure repeatedly
* Collaborate in team environments
* Prioritize analysis over setup complexities
* Need rapid project initialization
* Want to maintain consistent branding across documents

----

## Core Workflows

<p align="center">
  <img src="man/figures/custom-yaml-rendered.png" width="85%" alt="Rendered Document Example">
</p>
<p align="center"><i>Example of a rendered Quarto document created with froggeR</i></p>

----

### 🎯 Streamlined Quarto Project Creation

Initialize a comprehensive Quarto project with a single command:

```r
froggeR::quarto_project(name = 'my_new_project')
```

This creates:

* A Quarto document with custom YAML
* A comprehensive `.gitignore`
* Structured `README.md` & progress notes templates
* Reusable `_variables.yml` & `_brand.yml` files
* A `custom.scss` style sheet template
* A `references.bib` for citations

### 🔧 Configuration & Reusability

froggeR uses a two-tier configuration approach that flows from global → project → future projects:

#### Metadata Configuration

Maintain consistent metadata across your documents with `settings()`:

```r
froggeR::settings()
```

This provides an interactive workflow to:

* Create or update author details (name, email, ORCID, affiliations, etc.)
* Add GitHub username for collaboration setup
* Manage contact information and professional URLs
* Save to project-level, global (system-wide), or both locations
* View and update existing metadata with smart defaults

Once configured globally, your metadata is automatically available in all future froggeR projects.

#### Branding Configuration

Configure project branding with `brand_settings()`:

```r
froggeR::brand_settings()
```

This provides an interactive workflow to:

* Set project/organization name
* Define primary brand color (with hex color validation)
* Upload logo paths (large and small versions)
* Access advanced customization options for typography, color palettes, and more
* Save to project-level, global, or both locations

The branding system allows for a quick interactive setup for core elements, while providing a full template for more advanced customization:  
- **Core Elements (Interactive)**: The most common branding elements -- project name, primary color, and logos -- are configured through a simple interactive process.  
- **Advanced Options (Template)**: For more detailed control, you can opt to edit the full branding template, which includes typography, additional color palettes, code styling, and more.  

### 📝 Templated Quarto Documents

Quickly generate new Quarto documents with pre-formatted headers:

```r
froggeR::write_quarto(
  filename = 'data_cleaning',
  example = TRUE  # Add tool templates
)
```

Your saved metadata automatically populates author information and branding.

### 🛡️ Enhanced Git Protection

Set up a `.gitignore` tailored to your project's needs:
```r
# Creates a minimal .gitignore suitable for most R projects
froggeR::write_ignore()

# For projects with sensitive data, create a more comprehensive .gitignore
froggeR::write_ignore(aggressive = TRUE)
```
The default `write_ignore()` excludes common R and Quarto artifacts. The `aggressive` version additionally excludes a wide range of common data file types (e.g., `.csv`, `.xlsx`, `.rds`) to help prevent accidental data exposure.

### 🌟 Custom Styling Made Easy

Generate a SCSS template for custom document styling:

```r
froggeR::write_scss()
```

Provides a formatted stylesheet with:

* SCSS defaults
* SCSS mixins
* SCSS rules

Customize your document's appearance by uncommenting desired styles.

### 📚 Automated Project Documentation

Generate a structured README for your project:

```r
froggeR::write_readme()
```

Includes sections for:

* Project overview
* Setup instructions
* File and directory explanations
* Contribution guidelines

----

## Input Validation

froggeR validates all configuration inputs to ensure data quality and consistency:

### Metadata Validation

**Name**: Minimum 2 characters required  
- Example: "Kyle Grealis"  
  
**Email**: Must include @ symbol and domain  
- Example: "user@example.com"  
- Invalid: "user@example" or "user@.com"  
  
**ORCID** (optional): Must follow standard ORCID format  
- Format: 0000-0000-0000-0000  
- Example: "0000-0002-9223-8854"  
- Leave blank if you don't have one  
  
**URL** (optional): Must start with http:// or https://  
- Valid: "https://yoursite.com", "http://example.org"  
- Invalid: "yoursite.com" or "ftp://example.com"  
  
**GitHub Username** (optional): Alphanumeric characters and hyphens only  
- Rules: Max 39 characters, no leading/trailing hyphens  
- Valid: "octocat", "kyle-grealis", "user123"  
- Invalid: "-username", "username-", "user@name"  
  
### Branding Validation  
  
**Hex Color Format**: Must be valid hexadecimal color  
- Long form: #RRGGBB (e.g., "#0066cc", "#FF5733")  
- Short form: #RGB (e.g., "#06c", "#F57")  
- Invalid: "red", "0066cc", "#GGGGGG"  

----

## Function Reference

| Function | Description |
|----------|-------------|
| `settings()` | Manage persistent Quarto document metadata |
| `brand_settings()` | Manage persistent branding configuration |
| `quarto_project()` | Initialize a complete Quarto project structure |
| `write_quarto()`\* | Create consistently formatted Quarto documents |
| `write_variables()`\* | Re-use metadata across projects & documents |
| `write_brand()`\* | Create project-level `_brand.yml` configs |
| `save_variables()` | Save current `_variables.yml` to system-level configs |
| `save_brand()` | Save current `_brand.yml` to system-level configs |
| `write_ignore()`\* | Create a minimal or aggressive `.gitignore` file |
| `write_readme()`\* | Generate a comprehensive project README |
| `write_notes()`\* | Create a dated progress notes template |
| `write_scss()`\* | Create a customizable SCSS styling template |

\* *These functions are included with `quarto_project()`*

----

## Examples

### Quick Start: Setting Up Metadata

```r
library(froggeR)

# Run this once to set up your author metadata
froggeR::settings()

# Follow the interactive prompts:
# - Enter your name
# - Enter your email
# - Optional: ORCID, website, GitHub username, affiliations
# - Choose to save globally for reuse across all future projects
```

### Quick Start: Configuring Branding

```r
library(froggeR)

# Run this once to set up your project branding
froggeR::brand_settings()

# Follow the interactive prompts:
# - Enter project name
# - Enter primary brand color (hex format)
# - Upload logo paths
# - Optionally edit the full template for advanced options
# - Choose to save globally for reuse across projects
```

### Creating a New Project with Saved Settings

```r
library(froggeR)

# Your saved metadata and branding are automatically available
froggeR::quarto_project('my_analysis')

# The project automatically includes:
# - _variables.yml with your metadata
# - _brand.yml with your branding
# - Quarto document with your author info pre-filled
```

### Reusing Metadata Across Projects

Once you've saved metadata globally, it flows automatically to new projects:

```r
library(froggeR)

# Project 1: Create and save metadata
froggeR::settings()  # Save globally

# Project 2 (new directory): Metadata is already available
froggeR::quarto_project('new_project')  # Uses saved metadata automatically

# Project 3: You can still create project-specific overrides
froggeR::settings()  # Choose "Save to this project only" for local override
```

### Saving and Applying Branding

```r
library(froggeR)

# Step 1: Create your branding once
froggeR::brand_settings()

# Step 2: Save globally to reuse in all future projects
# (Select "Save globally" or "Save to both locations")

# Step 3: Create new projects - branding applies automatically
froggeR::quarto_project('branded_project')

# Step 4: Update branding anytime
froggeR::brand_settings()  # Choose "Update existing branding"
```

----

## Getting Help

**Documentation & Resources:**

- 📚 **Full Package Documentation** - Visit the [froggeR website](https://www.kyleGrealis.com/froggeR/) for complete function references and documentation
- 📖 **Vignettes** - Detailed guides and workflows:
  - [From Zero to Project](https://www.kyleGrealis.com/froggeR/articles/from-zero-to-project.html) - Getting started with froggeR
  - [Building Your Brand Identity](https://www.kyleGrealis.com/froggeR/articles/building-your-brand-identity.html) - Comprehensive branding workflows
  - [Your Metadata, Your Way](https://www.kyleGrealis.com/froggeR/articles/your-metadata-your-way.html) - Metadata configuration and management
  - [Set Once, Use Everywhere](https://www.kyleGrealis.com/froggeR/articles/set-once-use-everywhere.html) - Leveraging global configurations across projects
- 🐛 **Report Issues** - Found a bug or have a feature request? [Open an issue on GitHub](https://github.com/kyleGrealis/froggeR/issues)
- 💬 **Questions?** - Check existing GitHub issues or open a new discussion

**Function Help:**

Get help on any function directly in R:

```r
?froggeR::quarto_project
?froggeR::settings
?froggeR::brand_settings
?froggeR::write_quarto
```

----

## Why froggeR Over Other Tools?

While there are other project management tools for R, froggeR stands out by:

* Focusing specifically on Quarto workflows
* Providing a balance between automation and customization
* Offering a comprehensive suite of tools in a single package
* Emphasizing reproducibility and collaboration
* Supporting centralized configuration with project-level overrides
* New in v0.6.0: Enhanced metadata and branding management with interactive workflows

----

## Testing & Quality

froggeR is thoroughly tested with:

* 484 test assertions across 255 comprehensive test cases
* 100% function coverage (all 12 exported and 30+ internal functions tested)
* Comprehensive test suites for:
  - Settings and metadata management (`test-settings.R`)
  - Branding configuration (`test-brand_settings.R`)
  - YAML generation (`test-write_brand.R`, `test-write_variables.R`)
  - Quarto document creation (`test-write_quarto.R`)
  - Git configuration (`test-write_ignore.R`)
  - Project initialization (`test-quarto_project.R`)
  - Utility functions and validators (`test-utils.R`)
  - Global settings migration and storage (`test-save_brand.R`, `test-save_variables.R`)

All tests pass with 100% success rate. See the [tests directory](https://github.com/kyleGrealis/froggeR/tree/main/tests/testthat) for detailed test examples and patterns.

----

## Upcoming Features

We're constantly improving froggeR. Upcoming feature considerations include:

* Quarto dashboard integration
* Integration with version control systems
* Enhanced team collaboration tools
* More customizable templates for various data science workflows

----

## Contributing

We welcome contributions and ideas! Here's how you can help:

- **Report bugs** - [Open an issue](https://github.com/kyleGrealis/froggeR/issues) with a clear description
- **Suggest features** - Have an idea? [Submit a feature request](https://github.com/kyleGrealis/froggeR/issues)
- **Share feedback** - Let us know how froggeR is working for you
- **Improve documentation** - Help us make docs clearer and more complete

----

## License

froggeR is licensed under the [MIT License](https://choosealicense.com/licenses/mit/). See the LICENSE file for details.

----

## Acknowledgments

froggeR is built with love using R, Quarto, and these amazing packages:  
- [cli](https://cli.r-lib.org/) - User-friendly command line interfaces  
- [fs](https://fs.r-lib.org/) - Cross-platform file system operations  
- [here](https://here.r-lib.org/) - Project-oriented workflows  
- [quarto](https://quarto-dev.github.io/quarto-r/) - Quarto integration for R  
- [usethis](https://usethis.r-lib.org/) - Workflow automation  
- [yaml](https://github.com/vubiostat/r-yaml) - YAML parsing and writing  

---

**Developed by [Kyle Grealis](https://github.com/kyleGrealis)**

froggeR makes your Quarto projects jump for joy! 🐸
