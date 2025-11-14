# Manage froggeR Metadata Settings

Interactively create or update your froggeR metadata for reuse across
Quarto projects.

## Usage

``` r
settings()
```

## Value

Invisibly returns `NULL`. Called for side effects.

## Details

This function provides an interactive workflow to:

- Create new metadata (name, email, ORCID, affiliations, etc.)

- Update existing metadata from project or global configurations

- View current metadata

- Save to project-level, global (system-wide), or both locations

Metadata is stored as YAML and automatically used by
[`write_variables`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md)
in future Quarto projects.

## See also

[`brand_settings`](https://www.kyleGrealis.com/froggeR/reference/brand_settings.md),
[`write_variables`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md),
[`save_variables`](https://www.kyleGrealis.com/froggeR/reference/save_variables.md)

## Examples

``` r
# Only run in an interactive environment
if (interactive()) froggeR::settings()
```
