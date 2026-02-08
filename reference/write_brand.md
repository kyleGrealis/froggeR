# Write Brand YAML for Quarto Projects

Creates or opens a `_brand.yml` file in a Quarto project for editing. If
the file already exists, it is opened directly. If global froggeR brand
settings exist, those are used as the starting point. Otherwise, the
template is downloaded from the
[frogger-templates](https://github.com/kyleGrealis/frogger-templates)
repository.

## Usage

``` r
write_brand(path = here::here(), restore_logos = TRUE)
```

## Arguments

- path:

  Character. Path to the project directory. Default is current project
  root via [`here`](https://here.r-lib.org/reference/here.html).

- restore_logos:

  Logical. Restore logo content from system configuration. Default is
  `TRUE`.

## Value

Invisibly returns the path to the file.

## Details

The `_brand.yml` file defines your visual identity for Quarto documents:
colors, logos, typography, and more. See the [brand.yml
specification](https://posit-dev.github.io/brand-yml/) for the full list
of available options.

Use
[`save_brand`](https://www.kyleGrealis.com/froggeR/reference/save_brand.md)
to persist your project-level brand configuration to the global config
directory for reuse across projects.

## See also

[`save_brand`](https://www.kyleGrealis.com/froggeR/reference/save_brand.md),
[`write_variables`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md),
[`init`](https://www.kyleGrealis.com/froggeR/reference/init.md)

## Examples

``` r
if (FALSE) { # \dontrun{
write_brand()
} # }
```
