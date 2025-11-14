# Set Once, Use Everywhere

## The Problem: Repetitive Metadata Entry

Have you ever found yourself typing the same author information into
every new Quarto project? Or copying and pasting your ORCID, email, and
affiliations from one `_variables.yml` file to another?

You’re not alone. This repetitive work is tedious, error-prone, and
takes time away from your actual research or analysis.

## The Solution: Global Configuration

froggeR introduces a simple but powerful concept: **configure your
metadata once, use it everywhere**.

With
[`settings()`](https://www.kyleGrealis.com/froggeR/reference/settings.md)
and
[`brand_settings()`](https://www.kyleGrealis.com/froggeR/reference/brand_settings.md),
you can:

- Store your author information globally on your system
- Reuse it automatically in every new froggeR project
- Override with project-specific settings when needed
- Never type your ORCID again (unless you want to)

## How It Works

froggeR uses two storage locations for your configuration:

1.  **Project-level**: Stored in your current project directory
    - `_variables.yml` for author metadata
    - `_brand.yml` for branding configuration
2.  **Global**: Stored in your system’s configuration directory
    - Automatically reused in all new froggeR projects
    - Platform-specific location (managed by the `rappdirs` package)
    - Overridden by project-level settings if they exist

## Key Takeaways

1.  **Configure once**: Use
    [`settings()`](https://www.kyleGrealis.com/froggeR/reference/settings.md)
    and
    [`brand_settings()`](https://www.kyleGrealis.com/froggeR/reference/brand_settings.md)
    to set up your global configuration
2.  **Use everywhere**: All new froggeR projects automatically include
    your settings
3.  **Override flexibly**: Project-level settings take precedence when
    you need customization
4.  **View anytime**: Check your current configuration at any time
5.  **Save time**: Eliminate repetitive metadata entry from your
    workflow

## Next Steps

Ready to configure your metadata? See the [Your Metadata, Your
Way](https://www.kyleGrealis.com/froggeR/articles/your-metadata-your-way.md)
vignette for a detailed guide to the
[`settings()`](https://www.kyleGrealis.com/froggeR/reference/settings.md)
function.

Interested in branding? Check out [Building Your Brand
Identity](https://www.kyleGrealis.com/froggeR/articles/building-your-brand-identity.md)
for the complete
[`brand_settings()`](https://www.kyleGrealis.com/froggeR/reference/brand_settings.md)
workflow.

Want to see the full project setup in action? Read [From Zero to Project
in
Seconds](https://www.kyleGrealis.com/froggeR/articles/from-zero-to-project.md)
to understand how
[`quarto_project()`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md)
brings everything together.
