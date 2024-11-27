#' Create a project README file
#' 
#' This function is designed to first check for the existence of a README file. If none
#' is detected or the user chooses to overwrite the current README, a README template
#' is downloaded from \url{https://gist.github.com/kyleGrealis} and written at the 
#' project level.
#' 
#' @param path The path to the main project level. Defaults to the current
#' working directory.
#' @return A README.md template. Contains sections for project description (study
#' name, principle investigator, & author), project setup steps for ease of portability,
#' project file descriptions, project directory descriptions, and miscellaneous. 
#' 
#' A \code{DATED_PROGRESS_NOTES.md} is also created to better maintain project status
#' and updates.
#' 
#' NOTE: Some documentation remains to provide the user with example descriptions for 
#' files & directories. It is highly recommended to keep these sections. This is a 
#' modifiable template and should be tailor-fit for your exact purpose. 
#' 
#' @export
#' @examples
#' \dontrun{
#' write_readme(path = "path/to/project")
#' }

write_readme <- function(path = getwd()) {

  # Check if directory exists
  if (!dir.exists(path)) {
    # Exit if directory does not exist
    stop("Directory does not exist") 
  } 

  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)

  # Check for existing README
  if (file.exists(file.path(path, 'README.md'))) {
    ui_info('**CAUTION!!**')
    if (ui_nope('README.md found in project level directory! Overwrite?')) {
      ui_oops('README.md was not changed')
      return(invisible(NULL))
    }
  }

  # Get README template path
  template_path <- system.file("gists/README.md", package = "froggeR")
  if (template_path == "") {
    stop("Could not find README.md template in package installation")
  }

  # Write README.md file
  invisible(file.copy(
    from = template_path,
    to = file.path(path, "README.md")
  ))
  ui_done('Created README.md')

  # Add DATED_PROGRESS_NOTES.md template
  writeLines(
    paste0(
      "# Add project updates here\n", 
      format(Sys.Date(), "%b %d, %Y"),
      ": project started"
    ),
    con = file.path(path, "DATED_PROGRESS_NOTES.md")
  )
  ui_done('Created DATED_PROGRESS_NOTES.md')

  return(invisible(NULL))

}
