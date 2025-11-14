#' Write Variables YAML for Quarto Projects
#'
#' This function creates a \code{_variables.yml} file in a Quarto project
#' and opens it for editing.
#'
#' @param path Character. Path to the project directory. Default is current project
#'   root via \code{\link[here]{here}}.
#'
#' @return Invisibly returns the path to the created file.
#'
#' @details
#' The function will attempt to use the current froggeR settings from the global
#' config path. If no global configurations exist, a template \code{_variables.yml}
#' will be created. This file stores reusable metadata (author name, email, ORCID, etc.)
#' that can be referenced throughout Quarto documents.
#'
#' @examples
#' # Write the _variables.yml file
#' if (interactive()) {
#'   temp_dir <- tempdir()
#'   # In an interactive session, this would also open the file for editing.
#'   write_variables(temp_dir)
#'   # Verify the file was created
#'   file.exists(file.path(temp_dir, "_variables.yml"))
#' }
#'
#' @seealso \code{\link{settings}}, \code{\link{save_variables}},
#'   \code{\link{brand_settings}}, \code{\link{quarto_project}}
#' @export
write_variables <- function(path = here::here()) {
  the_variables_file <- create_variables(path)
  if (interactive()) {
    usethis::edit_file(the_variables_file)
  }
  invisible(the_variables_file)
}

#' Create Variables YAML for Quarto Projects (internal worker)
#'
#' Internal helper that creates \code{_variables.yml} file from template or global config.
#'
#' @param path Character. Path to the project directory.
#'
#' @return Path to the created file.
#' @noRd
create_variables <- function(path) {
  # Validate and normalize path
  path <- .validate_and_normalize_path(path)

  # Set up full destination file path
  the_variables_file <- file.path(path, '_variables.yml')

  # Handle _variables.yml creation
  if (file.exists(the_variables_file)) {
    rlang::abort(
      '_variables.yml already exists in the specified path.',
      class = 'froggeR_file_exists'
    )
  }

  # Global froggeR settings
  config_path <- rappdirs::user_config_dir('froggeR')
  config_file <- .handle_global_variables_migration(config_path)
  # Does it exist?
  froggeR_settings <- file.exists(config_file)

  # Write the config file based on template: if there's a .config/froggeR file,
  # use that or else use the template found here in the package
  template_path <- if (froggeR_settings) {
    # Display message if using the .config/froggeR/config.yml file
    ui_info(sprintf('Copying existing %s settings...', col_green('froggeR')))
    config_file
  } else {
    system.file('gists/config.yml', package = 'froggeR')
  }

  if (template_path == '') {
    rlang::abort(
      'Could not find config template in package installation.',
      class = 'froggeR_template_not_found'
    )
  }

  file.copy(from = template_path, to = the_variables_file, overwrite = FALSE)
  ui_done('Created _variables.yml')

  return(normalizePath(the_variables_file, mustWork = TRUE))
}