# froggeR 0.4.0

## Enhancements
* NEW: `save_variables()` is a new function to store the current project-level `_variables.yml` to the system configuration file path. It offers to overwrite if the system config exists.
* Simplified Quarto templates by removing unnecessary commenting throughout the YAML.
* Added section for including multiple authors in Quarto YAML files.
* Simplified README in favor of a more lightweight template.

## Bug Fixes
* Corrected indentation error for `affiliations` in the standard, non-custom Quarto template. Created rendering error.

## Documentation
* `save_variables()` documentation added to README

## Internal Changes
* Fixed tests for `write_notes()` and `write_readme()` to reflect updated content.


# froggeR 0.3.0

## Enhancements
* The `settings()` function replaces `froggeR_settings` and provides a menu-driven interface. User's can now check, view, & get instructions to use Quarto metadata within and across projects. Learn how to apply user-specific metadata from the global config file, or store local project metadata for reuse on future froggeR Quarto projects.
* The suite of `write_*` functions open the created files for immediate viewing & editing (in interactive sessions).
* Revised console feedback so users are always informed about how froggeR is helping streamline your project.

## Bug Fixes 
* *None*

## Documentation
* Fixed roxygen documentation for `@examples` by using `tempdir()` when executing functions.
* Used `@inheretParams` across supplemental functions (README, notes, ignore, SCSS, variables).

## Internal Changes
* Removed abililty to change metadata from the console. Instructions are now provided and, for `write_variables()`, the config file is opened in the interactive session.
* Separated `write_readme`; now includes `write_notes` for a project-level progress notes template.
* If any document to be created from the `write_*` functions exists in the project, froggeR will now stop and provide a useful message *instead* of offering to overwrite from the console. This reduces annoying feedback & interaction and encourages the user to make deliberate decions.


# froggeR 0.2.2

## Enhancements
* **`quarto_project()`**:
  - Streamlined integration with auxiliary functions for creating project-level files.
  - Improved error handling and user feedback when creating Quarto projects.
  - Ensured proper connection to `write_variables()` for managing `_variables.yml`.

* **`write_quarto()`**:
  - Enhanced functionality to automatically call `write_variables()` for `_variables.yml` creation.
  - Added clearer messaging for users when froggeR settings are missing, guiding them to set up metadata.

* **`write_variables()`**:
  - Introduced as a new function to create and manage `_variables.yml` files in a modular way.
  - Handles automatic population of YAML metadata using froggeR settings.

* **Improved User Feedback**:
  - Refined messaging across functions for consistency and clarity, including updated `ui_done` and `ui_info` outputs.

## Bug Fixes
* Resolved CRAN `check()` errors related to undefined global variables in examples.
* Fixed issues where `_variables.yml` creation would fail under specific directory conditions.

## Documentation
* Enhanced roxygen documentation for `write_quarto()`, `quarto_project()`, and `write_variables()` with detailed examples and explanations.
* Updated vignettes to demonstrate the modular design and improved workflows.

## Internal Changes
* Consolidated helper functions into `helpers.R` for better maintainability and organization.
* Improved modularity of settings and file management functions to align with best practices.

🎉 With version 0.2.2, froggeR introduces more robust Quarto project management, making metadata handling and customization easier and more intuitive for users.


# froggeR 0.2.1

## Enhancements
* Improved `write_scss()` function for more streamlined YAML updates in Quarto documents.
* Enhanced user feedback in `froggeR_settings()` function, providing clearer output of current settings.
* Refined error handling and user guidance in various functions for a smoother user experience.
* Updated vignettes with more comprehensive examples and clearer explanations of froggeR workflows.

## Documentation
* Expanded and clarified documentation for key functions.
* Added more detailed examples in function documentation to illustrate various use cases.
* Updated README with additional information on package usage and benefits.

# froggeR 0.2.0
* Renamed `default` parameter to `custom_yaml` in `quarto_project()` and `write_quarto()` for clarity.
* Refactored `froggeR_settings()` to use YAML for configuration storage.
* Changed how settings are stored and retrieved. Settings are now stored in `~/.config/froggeR/config.yml`.
* Improved user interaction in `froggeR_settings()` function.
* Modified `quarto_project()` and `write_quarto()` to use the new YAML-based settings.
* Added `.check_settings()` function to provide user feedback on incomplete settings.
* Updated `.update_variables_yml()` function to handle both creation and updating of `_variables.yml`.
* Improved error handling and user feedback in various functions.
* Removed `load_data()` function and related utilities.
* Updated documentation and examples to reflect new functionality and improve clarity.
* Revised README for better explanation of package workflow and features.
* Updated pkgdown site structure to reflect current package organization.

# froggeR 0.1.0

## Major Features
* Implemented enhanced Quarto project creation with `quarto_project()`
  - Automated project structure setup
  - Custom YAML integration
  - Built-in .gitignore configuration
  - Project documentation templates
  
* Added interactive YAML configuration via `froggeR_settings()`
  - Author information management
  - Contact details setup
  - Project metadata configuration
  - TOC preferences

* Created document generation tools
  - `write_quarto()` for consistent document creation
  - `write_readme()` for structured project documentation
  - `write_ignore()` for enhanced Git security
  - `write_scss()` for custom styling templates

## Documentation
* Added comprehensive function documentation
* Included detailed examples for all main functions
* Created structured README with clear usage guidelines
* Added function reference table

## Project Structure
* Implemented consistent project organization
* Added template system for Quarto documents
* Created reusable YAML configuration system
* Added custom SCSS styling templates

## Security
* Enhanced data protection through comprehensive .gitignore settings
* Added safeguards for sensitive data files
* Implemented security best practices for R projects