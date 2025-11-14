#' Create a Quarto SCSS File
#'
#' This function creates a \code{.scss} file for custom Quarto styling and opens it
#' for editing.
#'
#' @param path Character. Path to the project directory. Default is current project
#'   root via \code{\link[here]{here}}.
#'
#' @return Invisibly returns the path to the created file.
#'
#' @details
#' The function creates a \code{custom.scss} file with styling variables, mixins,
#' and rules for customizing Quarto document appearance.
#'
#' @examples
#' # Create a temporary directory for testing
#' tmp_dir <- tempdir()
#'
#' # Write the SCSS file
#' write_scss(path = tmp_dir)
#'
#' # Confirm the file was created
#' file.exists(file.path(tmp_dir, "custom.scss"))
#'
#' # Clean up
#' unlink(file.path(tmp_dir, "custom.scss"))
#'
#' @seealso \code{\link{quarto_project}}, \code{\link{write_quarto}}
#' @export
write_scss <- function(path = here::here()) {
  the_scss_file <- create_scss(path)
  if (interactive()) {
    usethis::edit_file(the_scss_file)
  }
  invisible(the_scss_file)
}

#' Create a Quarto SCSS File (internal worker)
#'
#' Internal helper that creates \code{custom.scss} file from template.
#'
#' @param path Character. Path to the project directory.
#'
#' @return Path to the created file.
#' @noRd
create_scss <- function(path) {
  # Validate and normalize path
  path <- .validate_and_normalize_path(path)

  # Set up full destination file path
  the_scss_file <- file.path(path, 'custom.scss')

  # Handle custom.scss creation
  if (file.exists(the_scss_file)) {
    rlang::abort(
      'A SCSS file already exists in the specified path.',
      class = 'froggeR_file_exists'
    )
  }

  # Get scss template path
  template_path <- system.file('gists/custom.scss', package = 'froggeR')
  if (template_path == '') {
    rlang::abort(
      'Could not find SCSS template in package installation.',
      class = 'froggeR_template_not_found'
    )
  }

  file.copy(from = template_path, to = the_scss_file, overwrite = FALSE)
  ui_done('Created custom.scss')

  return(normalizePath(the_scss_file, mustWork = TRUE))
}