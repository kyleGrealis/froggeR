#' Create an Enhanced .gitignore File
#'
#' This function creates a \code{.gitignore} file with either a minimal or aggressive
#' set of ignore rules and opens it for editing.
#'
#' @param path Character. Path to the project directory. Default is current project
#'   root via \code{\link[here]{here}}.
#' @param aggressive Logical. If \code{TRUE}, creates a comprehensive \code{.gitignore}
#'   with aggressive rules for sensitive data. If \code{FALSE} (default), creates
#'   a minimal \code{.gitignore} suitable for most R projects.
#'
#' @return Invisibly returns the path to the created file.
#'
#' @details
#' The \code{aggressive = TRUE} template includes comprehensive rules for common data
#' file types and sensitive information.
#'
#' \strong{WARNING}: Always consult your organization's data security team before using git
#' with any sensitive or protected health information (PHI). This template helps
#' prevent accidental data exposure but should not be considered a complete
#' security solution.
#'
#' @examples
#' # Create a temporary directory for testing
#' tmp_dir <- tempdir()
#'
#' # Write a minimal .gitignore file (default)
#' write_ignore(path = tmp_dir)
#'
#' # Clean up the first file before creating the next one
#' unlink(file.path(tmp_dir, ".gitignore"))
#'
#' # Write an aggressive .gitignore file
#' write_ignore(path = tmp_dir, aggressive = TRUE)
#'
#' # Clean up
#' unlink(file.path(tmp_dir, ".gitignore"))
#'
#' @seealso \code{\link{quarto_project}}, \code{\link{write_quarto}}
#' @export
write_ignore <- function(path = here::here(), aggressive = FALSE) {
  the_ignore_file <- create_ignore(path, aggressive)
  if (interactive()) {
    usethis::edit_file(the_ignore_file)
  }
  invisible(the_ignore_file)
}

#' Create an Enhanced .gitignore File (internal worker)
#'
#' Internal helper that creates \code{.gitignore} file from template.
#'
#' @param path Character. Path to the project directory.
#' @param aggressive Logical. Whether to use aggressive ignore rules.
#'
#' @return Path to the created file.
#' @noRd
create_ignore <- function(path, aggressive = FALSE) {
  # Validate and normalize path
  path <- .validate_and_normalize_path(path)

  # Set up full destination file path
  the_ignore_file <- file.path(path, '.gitignore')

  # Handle ignore creation/overwrite
  if (file.exists(the_ignore_file)) {
    rlang::abort(
      'A .gitignore file already exists in the specified path.',
      class = 'froggeR_file_exists'
    )
  }

  # Get .gitignore template path
  template_name <- if (aggressive) 'gitignore_aggressive' else 'gitignore_minimal'
  template_path <- system.file(file.path('gists', template_name), package = 'froggeR')

  if (template_path == '') {
    rlang::abort(
      sprintf('Could not find %s template in package installation.', template_name),
      class = 'froggeR_template_not_found'
    )
  }

  file.copy(from = template_path, to = the_ignore_file, overwrite = FALSE)
  ui_done(sprintf('Created .gitignore (%s version)', if (aggressive) 'aggressive' else 'minimal'))

  return(normalizePath(the_ignore_file, mustWork = TRUE))
}
