#' Create a project README file
#'
#' This function streamlines project documentation by creating a dated progress notes 
#' file. 
#'
#' @inheritParams write_ignore
#' 
#' @return CA chronological project progress notes tracker.
#' @details
#' The dated_progress_notes.md file is initialized with the current date and is designed
#' to help track project milestones chronologically. If the progress notes file already 
#' exists, the function will stop and warn the user.
#'
#' @examples
#' # Create a temporary directory for testing
#' tmp_dir <- tempdir()
#' 
#' # Write the progress notes file
#' write_notes(path = tmp_dir)
#' 
#' # Confirm the file was created (optional, for user confirmation)
#' file.exists(file.path(tmp_dir, "dated_progress_notes.md"))
#' 
#' # Clean up: Remove the created file
#' unlink(file.path(tmp_dir, "dated_progress_notes.md"))
#' 
#' @export
write_notes <- function(path = here::here(), .initialize_proj = FALSE) {
  
  # Validate path
  if (is.null(path) || is.na(path) || !dir.exists(path)) {
    stop("Invalid `path`. Please enter a valid project directory.")
  }
  
  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)

  # Set up the full destination file path
  the_notes_file <- file.path(path, 'dated_progress_notes.md')

  # Handle notes creation
  if (file.exists(the_notes_file)) {
    stop('A dated_progress_notes.md already exists in the specified path.')
  }
  
  # Write content
  progress_notes_content <- paste0(
    "# Add project updates here\n",
    format(Sys.Date(), "%b %d, %Y"),
    ": project started\n"
  )
  
  writeLines(progress_notes_content, con = the_notes_file)
  ui_done("Created dated_progress_notes.md")

  if (!.initialize_proj) usethis::edit_file(the_notes_file)

  return(invisible(the_notes_file))
}