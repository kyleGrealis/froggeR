#' Create a New Quarto Document
#'
#' This function creates a new Quarto document (\code{.qmd} file) with either a
#' custom or standard YAML header and opens it for editing.
#'
#' @param filename Character. The name of the file without the \code{.qmd}
#'   extension. Only letters, numbers, hyphens, and underscores are allowed.
#'   Default is \code{"Untitled-1"}.
#' @param path Character. Path to the project directory. Default is current project
#'   root via \code{\link[here]{here}}.
#' @param example Logical. If \code{TRUE}, creates a Quarto document with examples
#'   and ensures that auxiliary files (\code{_variables.yml}, \code{_quarto.yml},
#'   \code{custom.scss}) exist in the project. Default is \code{FALSE}.
#'
#' @return Invisibly returns the path to the created Quarto document.
#'
#' @details
#' When \code{example = TRUE}, the function automatically creates necessary
#' auxiliary files if they don't exist. The created document includes example
#' content demonstrating cross-references, links, and bibliography integration.
#'
#' @examples
#' if (interactive()) {
#'   # Create a temporary directory for testing
#'   tmp_dir <- tempdir()
#'
#'   # Write a Quarto document with examples
#'   write_quarto(path = tmp_dir, filename = "analysis", example = TRUE)
#'
#'   # Verify the file was created
#'   file.exists(file.path(tmp_dir, "analysis.qmd"))
#'
#'   # Clean up
#'   unlink(list.files(tmp_dir, full.names = TRUE), recursive = TRUE)
#' }
#'
#' @seealso \code{\link{quarto_project}}, \code{\link{write_variables}},
#'   \code{\link{write_brand}}
#' @export
write_quarto <- function(
  filename = "Untitled-1", path = here::here(), example = FALSE
) {
  # If creating an example doc, ensure auxiliary files are present
  if (example) {
    # Use tryCatch to suppress errors if files already exist, since the
    # goal is just to ensure they are present for the user.
    tryCatch(
      create_variables(path = path),
      froggeR_file_exists = function(c) invisible(NULL)
    )
    .ensure_auxiliary_files(path = path)
  }

  # Create the actual .qmd file
  the_quarto_file <- create_quarto(filename, path, example)

  # Open the file for editing if in an interactive session
  if (interactive()) {
    # Open only if the file is in the current project directory for safety
    same_dir <- normalizePath(path) == normalizePath(here::here())
    if (same_dir) {
      usethis::edit_file(the_quarto_file)
    }
  }

  invisible(the_quarto_file)
}


#' Create a New Quarto Document (internal worker)
#'
#' Internal helper that creates \code{.qmd} file from template.
#'
#' @param filename Character. The name of the file.
#' @param path Character. Path to the project directory.
#' @param example Logical. If \code{TRUE}, uses the example template.
#'
#' @return Path to the created file.
#' @noRd
create_quarto <- function(filename, path, example) {
  # Validate and normalize path
  path <- .validate_and_normalize_path(path)

  # Validate filename
  if (!is.character(filename)) {
    rlang::abort('Invalid filename: must be a character string.')
  }
  if (!grepl('^[a-zA-Z0-9_-]+$', filename)) {
    rlang::abort('Invalid filename. Use only letters, numbers, hyphens, and underscores.')
  }

  # Set up full file path
  the_quarto_file <- file.path(path, paste0(filename, '.qmd'))

  # Check if Quarto doc exists
  if (file.exists(the_quarto_file)) {
    rlang::abort(
      sprintf('%s.qmd already exists in the specified path.', filename),
      class = 'froggeR_file_exists'
    )
  }

  # Write the Quarto file based on template
  template_path <- if (example) {
    system.file('gists/custom_quarto.qmd', package = 'froggeR')
  } else {
    system.file('gists/basic_quarto.qmd', package = 'froggeR')
  }

  if (template_path == '') {
    rlang::abort(
      'Could not find Quarto template in package installation.',
      class = 'froggeR_template_not_found'
    )
  }

  file.copy(from = template_path, to = the_quarto_file, overwrite = FALSE)
  ui_done(sprintf(
    'Created %s.qmd %s', filename, ifelse(example, col_green('with examples'), '')
  ))

  return(normalizePath(the_quarto_file, mustWork = TRUE))
}