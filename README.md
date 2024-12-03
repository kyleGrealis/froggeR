
# froggeR <img src="man/figures/logo.png" align="right" height="130"  alt="" />



[![R-CMD-check](https://img.shields.io/badge/R--CMD--check-passing-brightgreen)](https://github.com/kyleGrealis/froggeR)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Why froggeR?

> Leap ahead in your data science journey with froggeR! Streamline Quarto workflows, catch setup bugs before they happen, and create structured projects that make sharing and collaboration a breeze. 🐸

Because project setup should be simple 🐸

- **Jump Right In**: Spend more time on analysis, less time on setup
- **Consistency**: Maintain uniform document styling and structure across projects
- **No More Setup Bugs**: Complex configs are unnecessary and can reduce efficiency
- **Safety**: Enhanced data protection with comprehensive `.gitignore` settings
- **Friendly for the Whole Team**: Easier team onboarding with structured documentation

## Who's it for?

`froggeR` is especially valuable for R users who:

- Juggle multiple Quarto projects
- Collaborate with team members
- Want to focus on analysis, not setup
- Need a quick way to start new projects

## Installation

You can install `froggeR` from GitHub:

```r
# install.packages("remotes")
remotes::install_github('kyleGrealis/froggeR')
# or the development version
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
- A template `custom.scss` style sheet
- A `.Rproj` file

### 🔄 Reusable YAML Headers

Maintain consistency across your documents with `froggeR_settings()`:

```r
froggeR::froggeR_settings()
```

This interactive function helps you create a `_variables.yml` file containing:

- Author information
- Contact details
- Affiliations
- Project keywords
- Table of Content preferences
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

### 🌟 Custom Styling

No more worrying about a SCSS template for that custom look and use:

```r
froggeR::write_scss()
```

Get a formatted styles sheet with examples for:

- SCSS defaults
- SCSS mixins
- SCSS rules

Uncomment any lines to apply them to your document the next time you render it...it's just that easy!

```
/*-- scss:defaults --*/
// Colors
// $primary: #2c365e;  
// $body-bg: #fefefe;
// $link-color: $primary;
// $code-block-bg: #f8f9fa;

/*-- scss:mixins --*/
// @mixin card-shadow {
//   box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
//   transition: box-shadow 0.3s ease;
//   &:hover {
//     box-shadow: 0 6px 8px rgba(0, 0, 0, 0.15);
//   }
// }


/*-- scss:rules --*/
// Custom theme rules
// .title-block {
//   margin-bottom: 2rem;
//   border-bottom: 3px solid $primary;
// }

// .callout {
//   @include card-shadow;
//   padding: 1.25rem;
//   margin: 1rem 0;
//   border-left: 4px solid $primary;
// }

// code {
//   color: darken($primary, 10%);
//   padding: 0.2em 0.4em;
//   border-radius: 3px;
// }
```

### 📚 Project Documentation

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
| `froggeR_settings()` | Manages Quarto document settings | Persistent configuration management |
| `quarto_project()` | Creates a complete Quarto project structure | One-command project setup |
| `write_quarto()` | Creates templated Quarto documents | Standardized formatting |
| `write_ignore()` | Sets up enhanced `.gitignore` | Better data security |
| `write_readme()` | Creates structured README template | Improved project documentation |
| `write_scss()` | Creates structured SCSS template | Consistent eye-catching reports |

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)

---
Created by [Kyle Grealis](https://github.com/kyleGrealis)