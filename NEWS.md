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