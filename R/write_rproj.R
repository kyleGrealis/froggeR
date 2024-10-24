#' Create a .Rproj file
#' 
#' This function creates the \code{.Rproj} file so that any directory can be easily 
#' converted to a RStudio project.
#' 
#' @param path The path to the main project level. Defaults to returned value
#' from \code{here::here()}.
#' @param name The name of the project directory.
#' @return A \code{.Rproj} file to initialize a RStudio project environment.
#' 
#' @export
#' @examples
#' \dontrun{
#' write_rproj(path = here::here(), name = "my_quarto_project")
#' }

write_rproj <- function(path = here::here(), name) {

  the_rproj_file <- paste0(path, '/', name, '.Rproj')
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

  # Warn user if any .Rproj is found in project
  if (length(list.files(pattern = '\\.Rproj$')) > 0) {
    ui_info('**CAUTION!!**')
    abort <- ui_nope('A .Rproj file found in project level directory! Overwrite?')
  }

  if (!abort) {
    write(content, file = the_rproj_file)
    ui_done(paste0('\n', name, '.Rproj has been created.\n\n'))
  } else {
    ui_oops('\n.Rproj was not changed.\n\n')
  }
}
NULL