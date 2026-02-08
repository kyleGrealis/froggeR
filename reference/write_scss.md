# Create a Quarto SCSS File

Creates or opens a `www/custom.scss` file in a Quarto project. If the
file already exists, it is opened directly. Otherwise, the template is
downloaded from the
[frogger-templates](https://github.com/kyleGrealis/frogger-templates)
repository.

## Usage

``` r
write_scss(path = here::here())
```

## Arguments

- path:

  Character. Path to the project directory. Default is current project
  root via [`here`](https://here.r-lib.org/reference/here.html).

## Value

Invisibly returns the path to the file.

## Details

The function creates a `www/custom.scss` file with styling variables,
mixins, and rules for customizing Quarto document appearance. The `www/`
directory is created automatically if it does not exist.

## See also

[`init`](https://www.kyleGrealis.com/froggeR/reference/init.md),
[`write_quarto`](https://www.kyleGrealis.com/froggeR/reference/write_quarto.md)

## Examples

``` r
if (FALSE) { # \dontrun{
write_scss()
} # }
```
