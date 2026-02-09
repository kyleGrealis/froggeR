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

  Character. Directory where the project will be created. If the
  directory does not exist, it will be created. Default is current
  project root via [`here`](https://here.r-lib.org/reference/here.html).

## Value

Invisibly returns the normalized `path`.

## Details

The function performs these steps:

1.  Creates the target directory if it does not exist

2.  Downloads the latest template zip from GitHub

3.  Copies only files that do not already exist (never overwrites)

4.  Restores saved user config (`_variables.yml`, `_brand.yml`,
    `logos/`) from `~/.config/froggeR/` if present

5.  Creates a `data/` directory (gitignored by default)

Existing files are never overwritten. Each created and skipped file is
reported individually so you can see exactly what changed.

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
# Create a new project (directory is created automatically)
init(path = file.path(tempdir(), "my-project"))
} # }
```
