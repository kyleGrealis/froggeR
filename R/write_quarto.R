#' Create a New 'Quarto' Document
#'
#' This function creates a new 'Quarto' document (.qmd file) with either a custom
#' or standard YAML header. When using a custom header, it integrates with 
#' `froggeR::settings()` for reusable metadata across documents.
#'
#' @inheritParams write_ignore
#' @param filename Character string. The name of the file without the '.qmd' extension.
#'   Only letters, numbers, hyphens, and underscores are allowed.
#' @param custom_yaml Logical. If TRUE (default), creates a 'Quarto' document with a
#'   custom YAML header using values from `_variables.yml`. If FALSE, creates a
#'   standard 'Quarto' document.
#'
#' @return Invisibly returns NULL after creating the 'Quarto' document.
#'
#' @details
#' When `custom_yaml = TRUE`, the function will check if  `_variables.yml` exists. This
#' file is needed to supply Quarto document metadata in the `path` project. The user will
#' be prompted with help if they don't already exist, and a Quarto document with the 
#' default template will be supplied instead.
#'
#' @examples
#' # Create a temporary directory for testing
#' tmp_dir <- tempdir()
#' 
#' # Write the Quarto & associated files for a custom YAML with reusable metadata
#' write_quarto(path = tempdir(), filename = "frog_analysis")
#'
#' # Write the Quarto file with a template requiring more DIY
#' write_quarto(path = tempdir(), filename = "frog_analysis_basic", custom_yaml = FALSE)
#' 
#' # Confirm the file was created (optional, for user confirmation)
#' file.exists(file.path(tmp_dir, "frog_analysis.qmd"))
#' file.exists(file.path(tmp_dir, "frog_analysis_basic.qmd"))
#' 
#' # Clean up: Remove the created file
#' unlink(list.files(tempdir(), full.names = TRUE), recursive = TRUE)
#' 
#' @export
write_quarto <- function(
  filename = 'frogs', path = here::here(), custom_yaml = TRUE, .initialize_proj = FALSE
) {
  
  # Validate path
  if (is.null(path) || is.na(path) || !dir.exists(path)) {
    stop("Invalid `path`. Please enter a valid project directory.")
  }

  # Validate filename
  if (!is.character(filename)) stop('Invalid filename: must be character.')
  if (!grepl('^[a-zA-Z0-9_-]+$', filename)) {
    stop('Invalid filename. Use only letters, numbers, hyphens, and underscores.')
  }

  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)

  # Set up full file path
  the_quarto_file <- file.path(path, paste0(filename, '.qmd'))

  # Check if Quarto doc exists
  if (file.exists(the_quarto_file)) {
    stop(sprintf("%s.qmd already exists in the specified path.", filename))
  }

  # Handle custom YAML
  if (custom_yaml) {

    # Project-level settings
    settings_file <- file.path(path, '_variables.yml')
    # Global froggeR settings
    config_path <- rappdirs::user_config_dir("froggeR")
    config_file <- file.path(config_path, "config.yml")

    # Do they exist?
    project_settings <- file.exists(settings_file)
    froggeR_settings <- file.exists(config_file)

    if (!.initialize_proj) {
      .check(config_file, project_settings, froggeR_settings)
    } else if (!froggeR_settings) {
      ui_oops(sprintf('No global %s config file found', col_green('froggeR')))
    }

    if (!project_settings) {
      # The _variables.yml file will be created by using either:
      # 1) the ~/.config/froggeR/config.yml file --or--
      # 2) the inst/gists/config.yml template
      write_variables(path = path, .initialize_proj = TRUE)
      
      # Now recheck that _variables.yml exists so the path gets all the necessary files
      if (file.exists(settings_file)) {
        project_settings <- TRUE

      } else {
        ui_oops(
          'UH OH! Encoutered an unexpected snag while writing the `_variables.yml file.'
        )
        message(sprintf(
          "\nSee %s and %s for more help.", 
          col_green('?froggeR::write_variables'), 
          col_green('?froggeR::write_quarto')
        ))
        # Reset for default template
        custom_yaml <- FALSE
      }
    }
    
    if (project_settings && !.initialize_proj) {
      # Create _quarto.yml & SCSS if they do not exist
      # Use .initialize_project = TRUE here to silence & not open the files
      .ensure_auxiliary_files(path = path, .initialize_proj = TRUE)
      if (!file.exists(settings_file)) write_variables(path=path, .initialize_proj=TRUE)
    }
  }

  # Write the Quarto file based on template
  template_path <- if (custom_yaml) {
    system.file('gists/custom_quarto.qmd', package = 'froggeR')
  } else {
    system.file('gists/basic_quarto.qmd', package = 'froggeR')
  }

  if (template_path == "") {
    stop("Could not find Quarto template in package installation")
  }

  file.copy(from = template_path, to = the_quarto_file, overwrite = FALSE)
  ui_done(sprintf(
    "Created %s.qmd %s", filename, ifelse(custom_yaml, col_green("with custom YAML"), "")
  ))

  # Open the file if...
  same_dir <- here::here() == path
  if (same_dir && !.initialize_proj && interactive()) usethis::edit_file(the_quarto_file)

  invisible(NULL)
}
