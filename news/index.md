# Changelog

## froggeR 0.6.0 (2025-11-13)

CRAN release: 2025-11-14

### New features

- New function
  [`brand_settings()`](https://www.kyleGrealis.com/froggeR/reference/brand_settings.md)
  provides an interactive workflow for configuring Quarto project
  branding. Supports interactive configuration of core branding elements
  (name, color, logos) and provides options for advanced customization
  via template editing (typography, palettes, etc.). Brand
  configurations can be saved to project-level, global (system-wide), or
  both locations for reuse across projects.

- New function
  [`save_brand()`](https://www.kyleGrealis.com/froggeR/reference/save_brand.md)
  enables saving and restoring brand configurations from the global
  froggeR settings directory.

- [`settings()`](https://www.kyleGrealis.com/froggeR/reference/settings.md)
  function completely redesigned with enhanced interactive workflow:

  - Interactive creation and updating of metadata (name, email, ORCID,
    URL, GitHub username, affiliations)
  - Ability to save metadata to project-level, global, or both locations
  - Improved user feedback and guided workflows, including clearer
    prompts for updating metadata.
  - Better status reporting for existing configurations

- [`write_brand()`](https://www.kyleGrealis.com/froggeR/reference/write_brand.md)
  gains `restore_logos` argument to enable automatic restoration of logo
  content from system configuration (default TRUE).

- [`write_ignore()`](https://www.kyleGrealis.com/froggeR/reference/write_ignore.md)
  now supports creating either a minimal (default) or an aggressive
  `.gitignore` file, providing more flexibility for project needs.

### Bug Fixes

- Fixed a bug in
  [`settings()`](https://www.kyleGrealis.com/froggeR/reference/settings.md)
  where empty optional fields could cause an error during metadata
  cleanup.
- Resolved an issue in
  [`brand_settings()`](https://www.kyleGrealis.com/froggeR/reference/brand_settings.md)
  where empty optional fields could lead to `null` values in
  `_brand.yml`, potentially causing issues with Quarto.
- Addressed potential ‘incomplete line errors’ in
  [`brand_settings()`](https://www.kyleGrealis.com/froggeR/reference/brand_settings.md)
  by sanitizing prompt display for current values.

### Minor improvements

- Implemented automatic, one-time migration of global settings from
  `config.yml` to `_variables.yml` for improved consistency and
  future-proofing.
- Enhanced README with updated documentation for branding, flexible
  `.gitignore` options, and improved clarity. README significantly
  expanded (487 lines) with Table of Contents, better organization,
  “Getting Help” section, and comprehensive feature highlights.
- New comprehensive vignettes guide users through Quarto project setup:
  - `from-zero-to-project.Rmd` - Getting started with froggeR
  - `building-your-brand-identity.Rmd` - Brand management workflows
  - `your-metadata-your-way.Rmd` - Metadata configuration and reuse
  - `set-once-use-everywhere.Rmd` - Leveraging global configurations
- Improved website URL in package documentation to point to Kyle
  Grealis’ website.
- Changed vignette builder from Quarto to knitr for better
  compatibility.
- Enhanced input validation and error messaging for brand colors.
- Code style consistency: Applied tidyverse-adjacent style conventions
  throughout the package for consistent formatting.
- Comprehensive documentation generation: Generated roxygen2
  documentation for all 12 public functions and 30+ internal helper
  functions with [@noRd](https://github.com/noRd) tags. All
  documentation files (.Rd) are CRAN-ready.
- NAMESPACE file updated with proper exports and imports for CRAN
  compliance.

### Testing

- Comprehensive test suite expansion: Added 3,327+ lines of new tests
  across 13 test files (test-brand_settings.R, test-settings.R,
  test-write_brand.R, test-write_quarto.R, test-quarto_project.R,
  test-save_brand.R, test-save_variables.R, test-utils.R,
  test-write_ignore.R, test-write_notes.R, test-write_readme.R,
  test-write_scss.R, test-write_variables.R).
- Test coverage now includes: brand configuration workflows, metadata
  management, edge cases with empty/NA values, error handling, path
  normalization, and file creation logic.
- 255 test cases with 484+ individual assertions across all exported
  functions, providing excellent coverage of new features and refactored
  functions, ensuring robust package behavior across various scenarios.

### Internal Changes

- Refactored `write_*` functions to simplify their public API by
  removing the `.initialize_proj` argument. Core file creation logic is
  now handled by internal `create_*` functions, while exported `write_*`
  functions manage interactive editing.
- Standardized error handling across the package to use
  [`rlang::abort()`](https://rlang.r-lib.org/reference/abort.html) with
  custom error classes, providing more consistent and informative error
  messages.
- Resolved `R CMD check` issues, including fixing example code, ensuring
  proper
  [`usethis::ui_warn`](https://usethis.r-lib.org/reference/ui-legacy-functions.html)
  import, removing unnecessary `:::` calls, and addressing ‘incomplete
  final line’ warnings in template files.
- Significantly updated and expanded the comprehensive test suite to
  cover all refactored `write_*` functions, new internal `create_*`
  functions, and the global configuration migration logic.

------------------------------------------------------------------------

## froggeR 0.5.1

CRAN release: 2025-07-22

### Enhancements

- Minimal spelling corrections to `NEWS` and vignettes. *No
  functionality changes!*

## froggeR 0.5.0

CRAN release: 2025-07-08

### BREAKING!!

- [`write_quarto()`](https://www.kyleGrealis.com/froggeR/reference/write_quarto.md)
  argument `custom_yaml` has been replaced with `example`, defaulting to
  TRUE. The Quarto file templates have been reworked to use Quarto brand
  structure. This simplifies the YAML within the document, but may
  require changes to the project `_quarto.yml` and `_brand.yml` files.

### Enhancements

- 2 new Quarto brand YAML functions have been added:
  [`write_brand()`](https://www.kyleGrealis.com/froggeR/reference/write_brand.md)
  &
  [`save_brand()`](https://www.kyleGrealis.com/froggeR/reference/save_brand.md).
  These functions allow users to add project `_brand.yml` file and save
  the current `_brand.yml` to where your machine stores configuration
  files. There are added arguments to save & restore your brand logos
  (saved as `logos/` directory).
- Modified SCSS template placeholders – some of these are now easier to
  manage in the `_brand.yml` file. Added tweaks for ORCID logo issue
  when rendering with branding on Windows.
- Revised Quarto template YAML – this seems to be a constant work in
  progress. Weighing the value of including defaults versus a more
  minimalistic approach.
- Removed creation of `.Rproj` file in
  [`quarto_project()`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md).

### Bug Fixes

- Corrected logic flow in
  [`write_variables()`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md)
  that caused unintentional stoppage.

------------------------------------------------------------------------

## froggeR 0.4.0

CRAN release: 2025-03-16

### Enhancements

- NEW:
  [`save_variables()`](https://www.kyleGrealis.com/froggeR/reference/save_variables.md)
  is a new function to store the current project-level `_variables.yml`
  to the system configuration file path. It offers to overwrite if the
  system config exists.
- Simplified Quarto templates by removing unnecessary commenting
  throughout the YAML.
- Added section for including multiple authors in Quarto YAML files.
- Simplified README in favor of a more lightweight template.

### Bug Fixes

- Corrected indentation error for `affiliations` in the standard,
  non-custom Quarto template. Created rendering error.

### Documentation

- [`save_variables()`](https://www.kyleGrealis.com/froggeR/reference/save_variables.md)
  documentation added to README

### Internal Changes

- Fixed tests for
  [`write_notes()`](https://www.kyleGrealis.com/froggeR/reference/write_notes.md)
  and
  [`write_readme()`](https://www.kyleGrealis.com/froggeR/reference/write_readme.md)
  to reflect updated content.

------------------------------------------------------------------------

## froggeR 0.3.0

CRAN release: 2025-01-15

### Enhancements

- The
  [`settings()`](https://www.kyleGrealis.com/froggeR/reference/settings.md)
  function replaces `froggeR_settings` and provides a menu-driven
  interface. User’s can now check, view, & get instructions to use
  Quarto metadata within and across projects. Learn how to apply
  user-specific metadata from the global config file, or store local
  project metadata for reuse on future froggeR Quarto projects.
- The suite of `write_*` functions open the created files for immediate
  viewing & editing (in interactive sessions).
- Revised console feedback so users are always informed about how
  froggeR is helping streamline your project.

### Bug Fixes

- *None*

### Documentation

- Fixed roxygen documentation for `@examples` by using
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html) when executing
  functions.
- Used `@inheretParams` across supplemental functions (README, notes,
  ignore, SCSS, variables).

### Internal Changes

- Removed ability to change metadata from the console. Instructions are
  now provided and, for
  [`write_variables()`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md),
  the config file is opened in the interactive session.
- Separated `write_readme`; now includes `write_notes` for a
  project-level progress notes template.
- If any document to be created from the `write_*` functions exists in
  the project, froggeR will now stop and provide a useful message
  *instead* of offering to overwrite from the console. This reduces
  annoying feedback & interaction and encourages the user to make
  deliberate decisions.

------------------------------------------------------------------------

## froggeR 0.2.2

### Enhancements

- **[`quarto_project()`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md)**:
  - Streamlined integration with auxiliary functions for creating
    project-level files.
  - Improved error handling and user feedback when creating Quarto
    projects.
  - Ensured proper connection to
    [`write_variables()`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md)
    for managing `_variables.yml`.
- **[`write_quarto()`](https://www.kyleGrealis.com/froggeR/reference/write_quarto.md)**:
  - Enhanced functionality to automatically call
    [`write_variables()`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md)
    for `_variables.yml` creation.
  - Added clearer messaging for users when froggeR settings are missing,
    guiding them to set up metadata.
- **[`write_variables()`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md)**:
  - Introduced as a new function to create and manage `_variables.yml`
    files in a modular way.
  - Handles automatic population of YAML metadata using froggeR
    settings.
- **Improved User Feedback**:
  - Refined messaging across functions for consistency and clarity,
    including updated `ui_done` and `ui_info` outputs.

### Bug Fixes

- Resolved CRAN `check()` errors related to undefined global variables
  in examples.
- Fixed issues where `_variables.yml` creation would fail under specific
  directory conditions.

### Documentation

- Enhanced roxygen documentation for
  [`write_quarto()`](https://www.kyleGrealis.com/froggeR/reference/write_quarto.md),
  [`quarto_project()`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md),
  and
  [`write_variables()`](https://www.kyleGrealis.com/froggeR/reference/write_variables.md)
  with detailed examples and explanations.
- Updated vignettes to demonstrate the modular design and improved
  workflows.

### Internal Changes

- Consolidated helper functions into `helpers.R` for better
  maintainability and organization.
- Improved modularity of settings and file management functions to align
  with best practices.

🎉 With version 0.2.2, froggeR introduces more robust Quarto project
management, making metadata handling and customization easier and more
intuitive for users.

------------------------------------------------------------------------

## froggeR 0.2.1

### Enhancements

- Improved
  [`write_scss()`](https://www.kyleGrealis.com/froggeR/reference/write_scss.md)
  function for more streamlined YAML updates in Quarto documents.
- Enhanced user feedback in `froggeR_settings()` function, providing
  clearer output of current settings.
- Refined error handling and user guidance in various functions for a
  smoother user experience.
- Updated vignettes with more comprehensive examples and clearer
  explanations of froggeR workflows.

### Documentation

- Expanded and clarified documentation for key functions.
- Added more detailed examples in function documentation to illustrate
  various use cases.
- Updated README with additional information on package usage and
  benefits.

## froggeR 0.2.0

- Renamed `default` parameter to `custom_yaml` in
  [`quarto_project()`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md)
  and
  [`write_quarto()`](https://www.kyleGrealis.com/froggeR/reference/write_quarto.md)
  for clarity.
- Refactored `froggeR_settings()` to use YAML for configuration storage.
- Changed how settings are stored and retrieved. Settings are now stored
  in `~/.config/froggeR/config.yml`.
- Improved user interaction in `froggeR_settings()` function.
- Modified
  [`quarto_project()`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md)
  and
  [`write_quarto()`](https://www.kyleGrealis.com/froggeR/reference/write_quarto.md)
  to use the new YAML-based settings.
- Added `.check_settings()` function to provide user feedback on
  incomplete settings.
- Updated `.update_variables_yml()` function to handle both creation and
  updating of `_variables.yml`.
- Improved error handling and user feedback in various functions.
- Removed `load_data()` function and related utilities.
- Updated documentation and examples to reflect new functionality and
  improve clarity.
- Revised README for better explanation of package workflow and
  features.
- Updated pkgdown site structure to reflect current package
  organization.

## froggeR 0.1.0

### Major Features

- Implemented enhanced Quarto project creation with
  [`quarto_project()`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md)
  - Automated project structure setup
  - Custom YAML integration
  - Built-in .gitignore configuration
  - Project documentation templates
- Added interactive YAML configuration via `froggeR_settings()`
  - Author information management
  - Contact details setup
  - Project metadata configuration
  - TOC preferences
- Created document generation tools
  - [`write_quarto()`](https://www.kyleGrealis.com/froggeR/reference/write_quarto.md)
    for consistent document creation
  - [`write_readme()`](https://www.kyleGrealis.com/froggeR/reference/write_readme.md)
    for structured project documentation
  - [`write_ignore()`](https://www.kyleGrealis.com/froggeR/reference/write_ignore.md)
    for enhanced Git security
  - [`write_scss()`](https://www.kyleGrealis.com/froggeR/reference/write_scss.md)
    for custom styling templates

### Documentation

- Added comprehensive function documentation
- Included detailed examples for all main functions
- Created structured README with clear usage guidelines
- Added function reference table

### Project Structure

- Implemented consistent project organization
- Added template system for Quarto documents
- Created reusable YAML configuration system
- Added custom SCSS styling templates

### Security

- Enhanced data protection through comprehensive .gitignore settings
- Added safeguards for sensitive data files
- Implemented security best practices for R projects
