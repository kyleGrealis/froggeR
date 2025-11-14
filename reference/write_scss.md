# Create a Quarto SCSS File

This function creates a `.scss` file for custom Quarto styling and opens
it for editing.

## Usage

``` r
write_scss(path = here::here())
```

## Arguments

- path:

  Character. Path to the project directory. Default is current project
  root via [`here`](https://here.r-lib.org/reference/here.html).

## Value

Invisibly returns the path to the created file.

## Details

The function creates a `custom.scss` file with styling variables,
mixins, and rules for customizing Quarto document appearance.

## See also

[`quarto_project`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md),
[`write_quarto`](https://www.kyleGrealis.com/froggeR/reference/write_quarto.md)

## Examples

``` r
# Create a temporary directory for testing
tmp_dir <- tempdir()

# Write the SCSS file
write_scss(path = tmp_dir)
#> ✔ Created custom.scss

# Confirm the file was created
file.exists(file.path(tmp_dir, "custom.scss"))
#> [1] TRUE

# Clean up
unlink(file.path(tmp_dir, "custom.scss"))
```
