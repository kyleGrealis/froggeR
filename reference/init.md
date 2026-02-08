# Initialize a froggeR Project from the Template

Downloads the latest project scaffold from the
[frogger-templates](https://github.com/kyleGrealis/frogger-templates)
repository and restores any saved user configuration. This is the
recommended way to start a new froggeR project.

## Usage

``` r
init(path = here::here())
```

## Arguments

- path:

  Character. Directory where the project will be created. Must already
  exist. Default is current project root via
  [`here`](https://here.r-lib.org/reference/here.html).

## Value

Invisibly returns the normalized `path`.

## Details

The function performs these steps:

1.  Downloads the latest template zip from GitHub

2.  Unpacks the scaffold into `path`

3.  Restores saved user config (`_variables.yml`, `_brand.yml`,
    `logos/`) from `~/.config/froggeR/` if present

4.  Creates a `data/` directory (gitignored by default)

Global configuration is saved via
[`save_variables`](https://www.kyleGrealis.com/froggeR/reference/save_variables.md)
and
[`save_brand`](https://www.kyleGrealis.com/froggeR/reference/save_brand.md).
If no saved config exists, the template defaults are used as-is.

## See also

[`write_variables`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md),
[`write_brand`](https://www.kyleGrealis.com/froggeR/reference/write_brand.md),
[`save_variables`](https://www.kyleGrealis.com/froggeR/reference/save_variables.md),
[`save_brand`](https://www.kyleGrealis.com/froggeR/reference/save_brand.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Initialize in an existing empty directory
dir.create(file.path(tempdir(), "my-project"))
init(path = file.path(tempdir(), "my-project"))
} # }
```
