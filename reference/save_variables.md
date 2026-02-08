# Save Metadata Configuration to Global froggeR Settings

This function saves the current `_variables.yml` file from an existing
froggeR Quarto project to your global (system-wide) froggeR
configuration. This allows you to reuse metadata across multiple
projects.

## Usage

``` r
save_variables()
```

## Value

Invisibly returns `NULL` after saving configuration file.

## Details

This function:

- Reads the project-level `_variables.yml` file

- Saves it to your system-wide froggeR config directory

- Prompts for confirmation if a global configuration already exists

The saved configuration is stored in
`rappdirs::user_config_dir('froggeR')` and will automatically be used in
new froggeR projects created with
[`init`](https://www.kyleGrealis.com/froggeR/reference/init.md) or
[`write_variables`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md).

This is useful for maintaining consistent author metadata (name, email,
affiliations, etc.) across all your projects without having to re-enter
it each time.

## See also

[`write_variables`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md),
[`save_brand`](https://www.kyleGrealis.com/froggeR/reference/save_brand.md)

## Examples

``` r
# Save metadata from current project to global config
if (interactive()) save_variables()
```
