#' Create a project README file
#'
#' This function streamlines project documentation by creating and managing both README.md
#' and dated_progress_notes.md files. It provides interactive prompts for existing files
#' and maintains consistent project documentation structure.
#'
#' @param path The destination directory for the progress notes file. Defaults to the 
#' current project's base directory (ie, value of \code{here::here()}).
#' @return Creates a chronological project progress notes tracker
#'
#' @details
#' The dated_progress_notes.md file is initialized with the current date and is designed
#' to help track project milestones chronologically. If the progress notes file already 
#' exists, the function will stop and warn the user.
#'
#' @export
#' @examples
#' # Create new progress note file in temporary directory
#' tmp <- tempdir()
#' write_notes(path = tmp)
 
write_notes <- function(path = here::here()) {
  
  # Validate path
  if (is.null(path) || !dir.exists(path)) {
    stop("Invalid `path`. Please enter a valid project directory.")
  }
  
  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)
  
  # Handle dated_progress_notes.md creation/overwrite
  progress_notes_content <- paste0(
    "# Add project updates here\n",
    format(Sys.Date(), "%b %d, %Y"),
    ": project started"
  )
  
  # Now check if the progress notes exists & ask to overwrite that too
  if (file.exists(file.path(path, 'dated_progress_notes.md'))) {
    stop('A dated_progress_notes.md has been found in the specified directory!')
  }
  
  writeLines( 
    progress_notes_content,
    con = file.path(path, "dated_progress_notes.md")
  )
  ui_done("Created dated_progress_notes.md")

  return(invisible(file.path(path, "dated_progress_notes.md")))
}