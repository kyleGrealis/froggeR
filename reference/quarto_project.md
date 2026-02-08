# Create a Custom Quarto Project

**Deprecated.** `quarto_project()` has been replaced by
[`init()`](https://www.kyleGrealis.com/froggeR/reference/init.md), which
downloads the latest opinionated scaffold from GitHub. This function now
creates the project directory and delegates to
[`init()`](https://www.kyleGrealis.com/froggeR/reference/init.md).

## Usage

``` r
quarto_project(name, path = here::here(), example = TRUE)
```

## Arguments

- name:

  Character. The name of the Quarto project directory.

- path:

  Character. Path to the parent directory where project will be created.
  Default is current project root via
  [`here`](https://here.r-lib.org/reference/here.html).

- example:

  Logical. Ignored. Kept for backward compatibility.

## Value

Invisibly returns the path to the created project directory.

## See also

[`init`](https://www.kyleGrealis.com/froggeR/reference/init.md)

## Examples

``` r
if (FALSE) { # \dontrun{
quarto_project("frogs", path = tempdir())
} # }
```
