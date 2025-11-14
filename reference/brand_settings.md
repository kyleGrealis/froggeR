# Manage Brand Settings for froggeR Quarto Projects

Interactively configure your branding (colors, logos, organization name)
for reuse across multiple Quarto projects.

## Usage

``` r
brand_settings()
```

## Value

Invisibly returns `NULL`. Called for side effects (interactive
configuration).

## Details

This function provides an interactive workflow with three main options:

1.  **Create or update branding**: Interactively configure:

    - Organization/project name

    - Primary brand color (hex format, e.g., \#0066cc)

    - Large logo path

    - Small/icon logo path

    - Optional: Advanced customization through template editing

2.  **View current branding**: Display existing project-level and global
    brand configurations

3.  **Exit**: Return to console

After configuring basic settings, you can choose to:

- Save with the basics (quick setup)

- Edit the full template for advanced options (typography, color
  palettes, links, code styling, headings)

Branding is stored as YAML (`_brand.yml`) in:

- Project-level: `_brand.yml` in the current Quarto project

- Global: System-wide config directory (reused across all projects)

- Both: Saved to both locations

Global branding is automatically applied in new projects via
[`quarto_project`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md)
and
[`write_brand`](https://www.kyleGrealis.com/froggeR/reference/write_brand.md).

## See also

[`settings`](https://www.kyleGrealis.com/froggeR/reference/settings.md),
[`write_brand`](https://www.kyleGrealis.com/froggeR/reference/write_brand.md),
[`save_brand`](https://www.kyleGrealis.com/froggeR/reference/save_brand.md)

## Examples

``` r
# Open interactive brand settings configuration
if (interactive()) {
  froggeR::brand_settings()
}
```
