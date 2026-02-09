# Create a Quarto SCSS File

Creates or opens an SCSS file in the `www/` directory. If the file
already exists, it is opened directly. Otherwise, the template is
downloaded from the
[frogger-templates](https://github.com/kyleGrealis/frogger-templates)
repository.

## Usage

``` r
write_scss(filename = "custom", path = here::here())
```

## Arguments

- filename:

  Character. The name of the file without the `.scss` extension. A
  `www/` prefix and `.scss` extension are stripped automatically if
  provided, so `"custom2"` and `"www/custom2.scss"` are equivalent. Only
  letters, numbers, hyphens, and underscores are allowed. Default is
  `"custom"`.

- path:

  Character. Path to the project directory. Default is current working
  directory via [`here`](https://here.r-lib.org/reference/here.html).

## Value

Invisibly returns the path to the file.

## Details

The file is written to `www/<filename>.scss`. The `www/` directory is
created automatically if it does not exist.

## See also

[`init`](https://www.kyleGrealis.com/froggeR/reference/init.md),
[`write_quarto`](https://www.kyleGrealis.com/froggeR/reference/write_quarto.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Create the default custom.scss
write_scss()

# Create a second SCSS file
write_scss("custom2")
# These are equivalent
write_scss("www/custom2.scss")
} # }
```
