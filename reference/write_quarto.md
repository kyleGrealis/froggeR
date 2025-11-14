# Create a New Quarto Document

This function creates a new Quarto document (`.qmd` file) with either a
custom or standard YAML header and opens it for editing.

## Usage

``` r
write_quarto(filename = "Untitled-1", path = here::here(), example = FALSE)
```

## Arguments

- filename:

  Character. The name of the file without the `.qmd` extension. Only
  letters, numbers, hyphens, and underscores are allowed. Default is
  `"Untitled-1"`.

- path:

  Character. Path to the project directory. Default is current project
  root via [`here`](https://here.r-lib.org/reference/here.html).

- example:

  Logical. If `TRUE`, creates a Quarto document with examples and
  ensures that auxiliary files (`_variables.yml`, `_quarto.yml`,
  `custom.scss`) exist in the project. Default is `FALSE`.

## Value

Invisibly returns the path to the created Quarto document.

## Details

When `example = TRUE`, the function automatically creates necessary
auxiliary files if they don't exist. The created document includes
example content demonstrating cross-references, links, and bibliography
integration.

## See also

[`quarto_project`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md),
[`write_variables`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md),
[`write_brand`](https://www.kyleGrealis.com/froggeR/reference/write_brand.md)

## Examples

``` r
if (interactive()) {
  # Create a temporary directory for testing
  tmp_dir <- tempdir()

  # Write a Quarto document with examples
  write_quarto(path = tmp_dir, filename = "analysis", example = TRUE)

  # Verify the file was created
  file.exists(file.path(tmp_dir, "analysis.qmd"))

  # Clean up
  unlink(list.files(tmp_dir, full.names = TRUE), recursive = TRUE)
}
```
