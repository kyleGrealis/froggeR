#' Create an aggressive project .gitignore file
#' 
#' This function is designed to first check for the existence of a .gitignore file. If none
#' is detected or the user chooses to overwrite the current .gitignore, a .gitignore
#' is downloaded from \url{https://gist.githubusercontent.com/RaymondBalise} and written 
#' at the project level.
#' 
#' @param path The path to the main project level. Defaults to returned value
#' from \code{here::here()}.
#' @return A .gitignore file. This has substanital upgrades from the basic .gitignore in
#' that it enhances data security. Some upgrades include ignoring R's data files (i.e.-- 
#' .RData, .rda, & .rds) as well as CSV, Excel, and text files. 
#' 
#' NOTE: Please review the contents and add other pertinent file types as appropriate.
#' 
#' WARNING: Check with your organization's data security team before using git with 
#' any sensitive and protected health information. The author assumes no liability.
#' 
#' @export
#' @examples
#' \dontrun{
#' write_ignore(path = '../path_to_project')
#' }

write_ignore <- function(path = here::here()) {

  # Check if directory exists
  if (!dir.exists(path)) {
    # Exit if directory does not exist
    stop("Directory does not exist") 
    return(NULL)
  } 

  the_ignore_file <- paste0(path, '/.gitignore')
  abort <- FALSE

  # path to .gitignore
  gist_path_ignore <- paste0(
    'https://gist.githubusercontent.com/RaymondBalise/1978fb42fc520ca57f670908e111585e/',
    # this changes as the .gitignore gist is updated
    'raw/e0b0ac8c7726f488fcc52b3b8269e449cbf33c15/.gitignore'
  )

  # Warn user if .gitignore is found in project
  if (file.exists(the_ignore_file)) {
    ui_info('**CAUTION!!**')
    abort <- ui_nope('A .gitignore has been found in project level directory! Overwrite?')
  }

  if (!abort) {
    download.file(gist_path_ignore, the_ignore_file, quiet = TRUE)
    ui_done('\n.gitignore has been created.\n\n')
  } else {
    ui_oops('\n.gitignore was not changed.\n\n')
  }

}
NULL