#' Create a Dated Progress Notes File
#'
#' This function streamlines project documentation by creating a dated progress
#' notes file and opening it for editing.
#'
#' @param path Character. Path to the project directory. Default is current project
#'   root via \code{\link[here]{here}}.
#'
#' @return Invisibly returns the file path after creating a dated progress notes file.
#'
#' @details
#' The \code{dated_progress_notes.md} file is initialized with the current date and is
#' designed to help track project milestones chronologically. This file supports markdown
#' formatting for rich documentation of project progress.
#'
#' @examples
#' # Create a temporary directory for testing
#' tmp_dir <- tempdir()
#'
#' # Write the progress notes file
#' write_notes(path = tmp_dir)
#'
#' # Confirm the file was created
#' file.exists(file.path(tmp_dir, "dated_progress_notes.md"))
#'
#' # Clean up
#' unlink(file.path(tmp_dir, "dated_progress_notes.md"))
#'
#' @seealso \code{\link{quarto_project}}, \code{\link{write_readme}}
#' @export
write_notes <- function(path = here::here()) {
  the_notes_file <- create_notes(path)
  if (interactive()) {
    usethis::edit_file(the_notes_file)
  }
  invisible(the_notes_file)
}

#' Create a Dated Progress Notes File (internal worker)
#'
#' Internal helper that creates \code{dated_progress_notes.md} file.
#'
#' @param path Character. Path to the project directory.
#'
#' @return Path to the created file.
#' @noRd
create_notes <- function(path) {
  # Validate and normalize path
  path <- .validate_and_normalize_path(path)

  # Set up the full destination file path
  the_notes_file <- file.path(path, 'dated_progress_notes.md')

  # Handle notes creation
  if (file.exists(the_notes_file)) {
    rlang::abort(
      'A dated_progress_notes.md already exists in the specified path.',
      class = 'froggeR_file_exists'
    )
  }

  # Write content
  progress_notes_content <- paste0(
    '# Project updates\n\n* ',
    format(Sys.Date(), '%b %d, %Y'),
    ': project started'
  )

  writeLines(progress_notes_content, con = the_notes_file)
  ui_done('Created dated_progress_notes.md')

  return(normalizePath(the_notes_file, mustWork = TRUE))
}
