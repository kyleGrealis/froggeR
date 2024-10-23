#' Create a project README file
#' 
#' This function is designed to first check for the existence of a README file. If none
#' is detected or the user chooses to overwrite the current README, a README template
#' is downloaded from \url{https://gist.github.com/kyleGrealis} and written at the 
#' project level.
#' 
#' @param path The path to the main project level. Defaults to returned value
#' from \code{here::here()}.
#' @return A README.md template. Contains sections for project description (study
#' name, principle investigator, & author), project setup steps for ease of portability,
#' project file descriptions, project directory descriptions, and miscellaneous. 
#' 
#' NOTE: Some documentation remains to provide the user with example descriptions for 
#' files & directories. It is highly recommended to keep these sections. This is a 
#' modifiable template and should be tailor-fit for your exact purpose. 
#' 
#' @export
#' @examples
#' \dontrun{
#' write_readme(path = '../path_to_project')
#' }

write_readme <- function(path = here::here()) {

  abort <- FALSE

  # path to README.md
  gist_path_readme <- paste0(
    'https://gist.github.com/kyleGrealis/963177f903a434c9b4931d1c4c56f1cc/',
    # this changes as the README gist is updated
    'raw/acb1cec3ac110fe8ae83bd978e381a24296ec122/README.md'
  )

  # Warn user if README is found in project
  if (file.exists('README.md')) {
    ui_info('**CAUTION!!**')
    abort <- ui_nope('README.md found in project level directory! Overwrite?')
  }

  if (!abort) {
    download.file(gist_path_readme, paste0(path, '/README.md'), quiet = TRUE)
    ui_done('README.md has been updated.\n\n')
  } else {
    ui_oops('\nREADME.md was not changed.\n\n')
  }
}
NULL