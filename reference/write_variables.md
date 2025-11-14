# Write Variables YAML for Quarto Projects

This function creates a `_variables.yml` file in a Quarto project and
opens it for editing.

## Usage

``` r
write_variables(path = here::here())
```

## Arguments

- path:

  Character. Path to the project directory. Default is current project
  root via [`here`](https://here.r-lib.org/reference/here.html).

## Value

Invisibly returns the path to the created file.

## Details

The function will attempt to use the current froggeR settings from the
global config path. If no global configurations exist, a template
`_variables.yml` will be created. This file stores reusable metadata
(author name, email, ORCID, etc.) that can be referenced throughout
Quarto documents.

## See also

[`settings`](https://www.kyleGrealis.com/froggeR/reference/settings.md),
[`save_variables`](https://www.kyleGrealis.com/froggeR/reference/save_variables.md),
[`brand_settings`](https://www.kyleGrealis.com/froggeR/reference/brand_settings.md),
[`quarto_project`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md)

## Examples

``` r
# Write the _variables.yml file
if (interactive()) {
  temp_dir <- tempdir()
  # In an interactive session, this would also open the file for editing.
  write_variables(temp_dir)
  # Verify the file was created
  file.exists(file.path(temp_dir, "_variables.yml"))
}
```
