#' Create a .Rproj file
#' 
#' This function creates the \code{.Rproj} file so that any directory can be easily 
#' converted to a RStudio project.
#' 
#' @param name The name of the project directory.
#' @param path The path to the main project level. Defaults to the current
#' working directory.
#' @return A \code{.Rproj} file to initialize a RStudio project environment.
#' 
#' @export
#' @examples
#' \dontrun{
#' write_rproj(name = "my_quarto_project", path = "path/to/project")
#' }

write_rproj <- function(name, path = getwd()) {

  # Check if directory exists
  if (!dir.exists(path)) {
    # Exit if directory does not exist
    stop("Directory does not exist") 
    return(NULL)
  } 

  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)

  the_rproj_file <- file.path(path, paste0(name, '.Rproj'))
  abort <- FALSE

  content <- glue::glue(
    'Version: 1.0

    RestoreWorkspace: Default
    SaveWorkspace: Default
    AlwaysSaveHistory: Default

    EnableCodeIndexing: Yes
    UseSpacesForTab: Yes
    NumSpacesForTab: 2
    Encoding: UTF-8

    RnwWeave: Sweave
    LaTeX: pdfLaTeX

    AutoAppendNewline: Yes
    StripTrailingWhitespace: Yes
    '
  )

  # Warn user if a .Rproj file is found in project
  listed_files <- list.files(
    path = path, 
    pattern = '\\.Rproj$', 
    full.names = TRUE, 
    recursive = FALSE
  )
  
  if (length(listed_files) > 0) {
    ui_info('**CAUTION!!**')
    abort <- ui_nope('A .Rproj file found in project level directory! Are you sure?')
  }

  if (!abort) {
    write(content, file = the_rproj_file)
    ui_done(paste0('\n', name, '.Rproj has been created.\n\n'))
  } else {
    ui_oops('\n.Rproj was not changed.\n\n')
  }
}
NULL