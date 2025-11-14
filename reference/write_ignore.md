# Create an Enhanced .gitignore File

This function creates a `.gitignore` file with either a minimal or
aggressive set of ignore rules and opens it for editing.

## Usage

``` r
write_ignore(path = here::here(), aggressive = FALSE)
```

## Arguments

- path:

  Character. Path to the project directory. Default is current project
  root via [`here`](https://here.r-lib.org/reference/here.html).

- aggressive:

  Logical. If `TRUE`, creates a comprehensive `.gitignore` with
  aggressive rules for sensitive data. If `FALSE` (default), creates a
  minimal `.gitignore` suitable for most R projects.

## Value

Invisibly returns the path to the created file.

## Details

The `aggressive = TRUE` template includes comprehensive rules for common
data file types and sensitive information.

**WARNING**: Always consult your organization's data security team
before using git with any sensitive or protected health information
(PHI). This template helps prevent accidental data exposure but should
not be considered a complete security solution.

## See also

[`quarto_project`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md),
[`write_quarto`](https://www.kyleGrealis.com/froggeR/reference/write_quarto.md)

## Examples

``` r
# Create a temporary directory for testing
tmp_dir <- tempdir()

# Write a minimal .gitignore file (default)
write_ignore(path = tmp_dir)
#> ✔ Created .gitignore (minimal version)

# Clean up the first file before creating the next one
unlink(file.path(tmp_dir, ".gitignore"))

# Write an aggressive .gitignore file
write_ignore(path = tmp_dir, aggressive = TRUE)
#> ✔ Created .gitignore (aggressive version)

# Clean up
unlink(file.path(tmp_dir, ".gitignore"))
```
