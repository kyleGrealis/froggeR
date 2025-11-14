# Write Brand YAML for Quarto Projects

This function creates a `_brand.yml` file in a Quarto project and opens
it for editing.

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

Invisibly returns the path to the created file.

## Details

The function will attempt to use the current froggeR settings from the
global config path. If no global configurations exist, a template
`_brand.yml` will be created.

In interactive sessions, the file is opened in the default editor for
immediate customization.

## See also

[`brand_settings`](https://www.kyleGrealis.com/froggeR/reference/brand_settings.md),
[`save_brand`](https://www.kyleGrealis.com/froggeR/reference/save_brand.md),
[`settings`](https://www.kyleGrealis.com/froggeR/reference/settings.md)

## Examples

``` r
# Write the _brand.yml file
if (interactive()) {
  temp_dir <- tempdir()
  # In an interactive session, this would also open the file for editing.
  write_brand(temp_dir)
  # Verify the file was created
  file.exists(file.path(temp_dir, "_brand.yml"))
}
```
