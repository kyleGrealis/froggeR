
# froggeR <img src="man/figures/logo.png" align="right" height="130"  alt="" />


> Enhance your Quarto workflows with reusable templates and project structures and get a *jump* on your R data science projects.


[![R-CMD-check](https://img.shields.io/badge/R--CMD--check-passing-brightgreen)](https://github.com/kyleGrealis/froggeR)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Overview

`froggeR` is an R package designed to streamline your Quarto workflows by enabling seamless reuse of YAML headers, consistent project structures, and automated setup of essential project files. It's particularly valuable for data scientists and R users who:

- Work on multiple Quarto projects
- Value consistency across their documentation
- Collaborate with others
- Want to reduce repetitive setup tasks

## Installation

You can install the development version of `froggeR` from GitHub:

```r
# install.packages("remotes")
remotes::install_github('kyleGrealis/froggeR@dev')
```

## Key Features

### 🎯 Enhanced Quarto Project Creation

The `quarto_project()` function supercharges your project setup:

```r
froggeR::quarto_project(
  name = "my_new_project",
  default = TRUE  # Use custom YAML from _variables.yml
)
```

This creates a new Quarto project with:
- A custom YAML-enabled `.qmd` file
- A comprehensive `.gitignore`
- A structured `README.md`
- A reusable `_variables.yml`
- A `.Rproj` file

### 🔄 Reusable YAML Headers

Maintain consistency across your documents with `write_variables()`:

```r
froggeR::write_variables()
```

This interactive function helps you create a `_variables.yml` file containing:
- Author information
- Contact details
- Affiliations
- Project keywords
- TOC preferences
- And more!

### 📝 Templated Quarto Documents

Create new Quarto documents with pre-formatted headers:

```r
froggeR::write_quarto(
  filename = "analysis",
  default = TRUE  # Use variables from _variables.yml
)
```

### 🛡️ Enhanced Git Protection

Set up a comprehensive `.gitignore` for R projects:

```r
froggeR::write_ignore()
```

Features enhanced data security by default:
- Ignores R data files (`.RData`, `.rda`, `.rds`)
- Excludes common data formats (CSV, Excel, text files)
- Protects sensitive information

### 📚 Project Documentation

Create a RStudio project:

```r
froggeR::write_rproj()
```

Generate structured README files:

```r
froggeR::write_readme()
```

Includes sections for:
- Project description
- Setup instructions
- File descriptions
- Directory structure
- And more!

## Function Reference

| Function | Description | Key Benefit |
|----------|-------------|-------------|
| `quarto_project()` | Creates a complete Quarto project structure | One-command project setup |
| `write_variables()` | Generates reusable YAML variables | Consistent document metadata |
| `write_quarto()` | Creates templated Quarto documents | Standardized formatting |
| `write_ignore()` | Sets up enhanced `.gitignore` | Better data security |
| `write_readme()` | Creates structured README template | Improved project documentation |
| `write_rproj()` | Sets up a RStudio project | Improved project workflow |

## Why froggeR?

- **Consistency**: Maintain uniform document styling and structure across projects
- **Efficiency**: Reduce time spent on repetitive setup tasks
- **Security**: Enhanced data protection with comprehensive `.gitignore` settings
- **Collaboration**: Easier onboarding with structured documentation
- **Flexibility**: Use default templates or customize to your needs

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)

---
Created by [Kyle Grealis](https://github.com/kyleGrealis)