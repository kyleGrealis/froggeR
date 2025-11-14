# Save Brand Configuration to Global froggeR Settings

This function saves the current `_brand.yml` file from an existing
froggeR Quarto project to your global (system-wide) froggeR
configuration. This allows you to reuse brand settings across multiple
projects.

## Usage

``` r
save_brand(save_logos = TRUE)
```

## Arguments

- save_logos:

  Logical. Should logo files from the `logos` directory also be saved to
  global configuration? Default is `TRUE`.

## Value

Invisibly returns `NULL` after saving configuration file.

## Details

This function:

- Reads the project-level `_brand.yml` file

- Saves it to your system-wide froggeR config directory

- Optionally copies the `logos` directory for reuse in future projects

- Prompts for confirmation if a global configuration already exists

The saved configuration is stored in
`rappdirs::user_config_dir('froggeR')` and will automatically be used in
new froggeR projects created with
[`quarto_project`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md)
or
[`write_brand`](https://www.kyleGrealis.com/froggeR/reference/write_brand.md).

## See also

[`brand_settings`](https://www.kyleGrealis.com/froggeR/reference/brand_settings.md),
[`write_brand`](https://www.kyleGrealis.com/froggeR/reference/write_brand.md),
[`save_variables`](https://www.kyleGrealis.com/froggeR/reference/save_variables.md)

## Examples

``` r
# Save brand settings from current project to global config
if (interactive()) save_brand()

# Save brand settings but skip logos
if (interactive()) save_brand(save_logos = FALSE)
```
