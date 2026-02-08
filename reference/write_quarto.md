# Create a New Quarto Document

Downloads the Quarto template from the
[frogger-templates](https://github.com/kyleGrealis/frogger-templates)
repository and writes it to the `pages/` directory. Errors if a file
with the same name already exists.

## Usage

``` r
write_quarto(filename = "Untitled-1", path = here::here())
```

## Arguments

- filename:

  Character. The name of the file without the `.qmd` extension. Only
  letters, numbers, hyphens, and underscores are allowed. Default is
  `"Untitled-1"`.

- path:

  Character. Path to the project directory. Default is current project
  root via [`here`](https://here.r-lib.org/reference/here.html).

## Value

Invisibly returns the path to the created Quarto document.

## Details

The file is written to `pages/<filename>.qmd`. The `pages/` directory is
created automatically if it does not exist.

## See also

[`init`](https://www.kyleGrealis.com/froggeR/reference/init.md),
[`write_variables`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md),
[`write_brand`](https://www.kyleGrealis.com/froggeR/reference/write_brand.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Create a Quarto document with the default name
write_quarto()

# Create a Quarto document with a custom name
write_quarto(filename = "analysis")
} # }
```
