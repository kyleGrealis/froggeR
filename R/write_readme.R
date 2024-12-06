#' Create a project README file
#'
#' This function is designed to first check for the existence of a README file. If none
#' is detected or the user chooses to overwrite the current README, a README template
#' is loaded from \url{https://gist.github.com/kyleGrealis} and written to the project
#' level.
#'
#' @param path The path to the main project level. Defaults to the current
#' working directory.
#' @return A README.md template. Contains sections for:\cr
#' * Project description (study name, principal investigator, & author)\cr
#' * Project setup steps for ease of portability\cr
#' * Project file descriptions\cr
#' * Project directory descriptions\cr
#' * Miscellaneous
#'
#' @details This function handles the creation and/or overwriting of both \code{README.md}
#' and \code{dated_progress_notes.md} files. For each file, if it already exists, 
#' the user will be prompted whether to overwrite it. The \code{dated_progress_notes.md}
#' file will be initialized with the current date and a "project started" message.
#'
#' NOTE: Some documentation remains to provide the user with example descriptions for
#' files & directories. It is highly recommended to keep these sections. However, 
#' this is a modifiable template and should be tailor-fit for your exact purpose.
#'
#' @export
#' @examples
#' \dontrun{
#' write_readme(path = "path/to/project")
#' }
write_readme <- function(path = getwd()) {
  # Check if directory exists
  if (!dir.exists(path)) {
    stop("Directory does not exist")
  }
  
  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)
  
  # Get README template path first (fail fast)
  readme_path <- system.file("gists/README.md", package = "froggeR")
  if (readme_path == "") {
    stop("Could not find README.md template in package installation")
  }
  
  # Handle README creation/overwrite
  if (file.exists(file.path(path, 'README.md'))) {
    ui_info('**CAUTION!!**')
    if (ui_yeah('README.md found in project level directory! Would you like to overwrite it?')) {
      invisible(file.copy(
        from = readme_path,
        to = file.path(path, "README.md"),
        overwrite = TRUE
      ))
      ui_done("README.md has been overwritten with the template.")
    } else {
      ui_info("Keeping existing README.md")
    }
  } else {
    invisible(file.copy(
      from = readme_path,
      to = file.path(path, "README.md")
    ))
    ui_done("A README.md template has been created.")
  }
  
  # Handle dated_progress_notes.md creation/overwrite
  progress_notes_content <- paste0(
    "# Add project updates here\n",
    format(Sys.Date(), "%b %d, %Y"),
    ": project started"
  )
  
  if (file.exists(file.path(path, 'dated_progress_notes.md'))) {
    ui_info('**CAUTION!!**')
    if (ui_yeah('dated_progress_notes.md found in project level directory! Would you like to overwrite it?')) {
      writeLines(
        progress_notes_content,
        con = file.path(path, "dated_progress_notes.md")
      )
      ui_done("dated_progress_notes.md has been overwritten with the template.")
    } else {
      ui_info("Keeping existing dated_progress_notes.md")
    }
  } else {
    writeLines(
      progress_notes_content,
      con = file.path(path, "dated_progress_notes.md")
    )
    ui_done("A dated_progress_notes.md template has been created.")
  }
  
  return(invisible(NULL))
}