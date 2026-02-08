# Write Variables YAML for Quarto Projects

Creates or opens a `_variables.yml` file in a Quarto project for
editing. If the file already exists, it is opened directly. If global
froggeR settings exist, those are used as the starting point. Otherwise,
the template is downloaded from the
[frogger-templates](https://github.com/kyleGrealis/frogger-templates)
repository.

## Usage

``` r
write_variables(path = here::here())
```

## Arguments

- path:

  Character. Path to the project directory. Default is current project
  root via [`here`](https://here.r-lib.org/reference/here.html).

## Value

Invisibly returns the path to the file.

## Details

The `_variables.yml` file stores reusable author metadata that Quarto
documents can reference. Available fields:

- `name`: Your full name as it appears in publications

- `email`: Contact email address

- `orcid`: ORCID identifier (e.g., 0000-0001-2345-6789)

- `url`: Personal website or profile URL

- `github`: GitHub username

- `affiliations`: Institution, department, etc.

Use
[`save_variables`](https://www.kyleGrealis.com/froggeR/reference/save_variables.md)
to persist your project-level metadata to the global config directory
for reuse across projects.

## See also

[`save_variables`](https://www.kyleGrealis.com/froggeR/reference/save_variables.md),
[`write_brand`](https://www.kyleGrealis.com/froggeR/reference/write_brand.md),
[`init`](https://www.kyleGrealis.com/froggeR/reference/init.md)

## Examples

``` r
if (FALSE) { # \dontrun{
write_variables()
} # }
```
