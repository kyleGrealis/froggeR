#' Write Variables YAML for 'Quarto' Projects
#'
#' This function creates or updates the `_variables.yml` file in a Quarto project
#' directory using froggeR settings, if they exist in the config path.
#'
#' @inheritParams write_ignore
#'
#' @return Invisibly returns `NULL` after creating or updating the `_variables.yml` file.
#' @details
#' The function will attempt to use the current froggeR settings from the config path. If
#' no global configurations exist, a template `_variables.yml` will be created.
#'
#' @examples
#' 
#' # Write the _variables.yml file
#' if (interactive()) {
#'   temp_dir <- tempdir()
#'   write_variables(temp_dir)
#' }
#' 
#' @export
write_variables <- function(path = here::here(), .initialize_proj = FALSE) {

  # Validate path
  if (is.null(path) || is.na(path) || !dir.exists(path)) {
    stop("Invalid `path`. Please enter a valid project directory.")
  }

  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)

  # Set up full destination file path
  the_variables_file <- file.path(path, '_variables.yml')

  # Handle _variables.yml creation
  if (file.exists(the_variables_file)) {
    stop('_variables.yml already exists in the specified path.')
  }

  # Global froggeR settings
  config_path <- rappdirs::user_config_dir("froggeR")
  config_file <- file.path(config_path, "config.yml")
  # Does it exist?
  froggeR_settings <- file.exists(config_file)

  # Write the config file based on template: if there's a .config/froggeR file,
  # use that or else use the template found here in the package
  template_path <- if (froggeR_settings) {
    config_file
  } else {
    system.file('gists/config.yml', package = 'froggeR')
  }

  # Display message if using the .config/froggeR/config.yml file
  if (froggeR_settings) {
    ui_info(sprintf('Copying existing %s settings...', col_green('froggeR')))
  }

  if (template_path == "") {
    stop("Could not find config template in package installation")
  }

  file.copy(from = template_path, to = the_variables_file, overwrite = FALSE)
  ui_done("Created _variables.yml")

  if (!.initialize_proj) usethis::edit_file(the_variables_file)

  return(invisible(NULL))
}

