#' Create a Project README File
#'
#' This function streamlines project documentation by creating a \code{README.md} file
#' and opening it for editing.
#'
#' @param path Character. Path to the project directory. Default is current project
#'   root via \code{\link[here]{here}}.
#'
#' @return Invisibly returns the path to the created file.
#'
#' @details
#' The \code{README.md} template includes structured sections for:
#' \itemize{
#'   \item Project description (study name, principal investigator, author)
#'   \item Project setup steps for reproducibility
#'   \item File and directory descriptions
#'   \item Miscellaneous project notes
#' }
#'
#' @examples
#' # Create a temporary directory for testing
#' tmp_dir <- tempdir()
#'
#' # Write the README file
#' write_readme(path = tmp_dir)
#'
#' # Confirm the file was created
#' file.exists(file.path(tmp_dir, "README.md"))
#'
#' # Clean up
#' unlink(file.path(tmp_dir, "README.md"))
#'
#' @seealso \code{\link{quarto_project}}, \code{\link{write_notes}}
#' @export
write_readme <- function(path = here::here()) {
  the_readme_file <- create_readme(path)
  if (interactive()) {
    usethis::edit_file(the_readme_file)
  }
  invisible(the_readme_file)
}

#' Create a Project README File (internal worker)
#'
#' Internal helper that creates \code{README.md} file from template.
#'
#' @param path Character. Path to the project directory.
#'
#' @return Path to the created file.
#' @noRd
create_readme <- function(path) {
  # Validate and normalize path
  path <- .validate_and_normalize_path(path)

  # Set up the full destination path
  the_readme_file <- file.path(path, 'README.md')

  # Handle README creation
  if (file.exists(the_readme_file)) {
    rlang::abort(
      'A README.md already exists in the specified path.',
      class = 'froggeR_file_exists'
    )
  }

  # Get README template path
  readme_path <- system.file('gists/README.md', package = 'froggeR')
  if (readme_path == '') {
    rlang::abort(
      'Could not find README template in package installation.',
      class = 'froggeR_template_not_found'
    )
  }

  file.copy(from = readme_path, to = the_readme_file, overwrite = TRUE)
  ui_done('Created README.md')

  return(normalizePath(the_readme_file, mustWork = TRUE))
}
