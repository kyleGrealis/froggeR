# Create a Custom Quarto Project

This function creates a new Quarto project directory with additional
froggeR features. It first calls
[`quarto::quarto_create_project()`](https://quarto-dev.github.io/quarto-r/reference/quarto_create_project.html)
to set up the basic structure, then enhances it with froggeR-specific
files and settings.

## Usage

``` r
quarto_project(name, path = here::here(), example = TRUE)
```

## Arguments

- name:

  Character. The name of the Quarto project directory and initial `.qmd`
  file. Must contain only letters, numbers, hyphens, and underscores.

- path:

  Character. Path to the parent directory where project will be created.
  Default is current project root via
  [`here`](https://here.r-lib.org/reference/here.html).

- example:

  Logical. If `TRUE` (default), creates a Quarto document with brand
  logo positioning and examples of within-document cross-referencing,
  links, and references.

## Value

Invisibly returns the path to the created project directory.

## Details

This function creates a Quarto project with the following enhancements:

- `_brand.yml`: Stores Quarto project branding

- `logos`: Quarto project branding logos directory

- `_variables.yml`: Stores reusable YAML variables

- `.gitignore`: Enhanced settings for R projects

- `README.md`: Template README file

- `dated_progress_notes.md`: For project progress tracking

- `custom.scss`: Custom Quarto styling

- `references.bib`: Bibliography template

The function requires Quarto version 1.6 or greater. Global froggeR
settings are automatically applied if available.

## See also

[`write_quarto`](https://www.kyleGrealis.com/froggeR/reference/write_quarto.md),
[`settings`](https://www.kyleGrealis.com/froggeR/reference/settings.md),
[`brand_settings`](https://www.kyleGrealis.com/froggeR/reference/brand_settings.md),
[`write_brand`](https://www.kyleGrealis.com/froggeR/reference/write_brand.md),
[`write_variables`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md),
[`save_brand`](https://www.kyleGrealis.com/froggeR/reference/save_brand.md),
[`save_variables`](https://www.kyleGrealis.com/froggeR/reference/save_variables.md)

## Examples

``` r
if (interactive() && quarto::quarto_version() >= "1.6") {

  # Create the Quarto project with custom YAML & associated files
  quarto_project("frogs", path = tempdir(), example = TRUE)

  # Confirm files were created
  file.exists(file.path(tempdir(), "frogs", "frogs.qmd"))
  file.exists(file.path(tempdir(), "frogs", "_quarto.yml"))

}
```
