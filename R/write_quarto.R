#' Start a Quarto file with a formatted template header
#' 
#' This function creates a new Quarto document with a pre-formatted YAML header. The user
#' needs to update the Title, author details (including optional URL link, email address,
#' and ORCID). An abstract is included along with keywords to 'tag' the document.
#' 
#' Default options have been set for the table of contents and code output. Either set
#' the options to 'false' (do not quote the options in the YAML) or comment out the 
#' selected line(s). The default editor is source and not visual.
#' 
#' NOTE: The default theme for this is sandstone. Please visit
#' \url{https://quarto.org/docs/output-formats/html-themes.html} to explore more
#' theming options.
#' 
#' @param filename The name of the file. Do not include '.qmd'
#' @param path The path to the main project level. Defaults to returned value
#' from \code{here::here()}.
#' @param default You are the default user. 😉 You NEED to change this, unless you
#' want a personalized Quarto document with the author's details. \code{*THIS WILL BE
#' FIXED in a future version!*}
#' @return A Quarto document with formatted YAML and two blank starter sections.
#' 
#' @export
#' @examples
#' \dontrun{
#' # To create new_doc.qmd:
#' write_quarto(filename = 'new_doc', path = '../path_to_location')
#' }

write_quarto <- function(filename = 'new', path = here::here(), default = FALSE) {

  the_quarto_file <- paste0(path, '/', filename, '.qmd')
  abort <- FALSE

  # path to default Quarto header template
  gist_path_default <- paste0(
    'https://gist.githubusercontent.com/kyleGrealis/693e5d0df41576247900c3bef788d475/',
    # this changes as the default Quarto is updated
    'raw/fe770eab51c8e600f9c353a53f9a078673343b2c/quarto_header.qmd'
  )

  # path to personalized Quarto header template
  gist_path_kyle <- paste0(
    'https://gist.githubusercontent.com/kyleGrealis/d8e61fc834f92868823e71ff26bda745/',
    # this changes as the personalized Quarto is updated
    'raw/9f2be2469dd2372617e7bf79166c3417591777df/kyle_quarto_header.qmd'
  )

  # Warn user if Quarto document already found in the project
  if (file.exists(the_quarto_file)) {
    ui_info('**CAUTION!!**')
    abort <- ui_nope('{the_quarto_file} found in provided path! Overwrite?')
  }

  if (!abort) {
    # override gist path for Kyle
    if (!default) { gist_path_default <- gist_path_kyle }

    download.file(gist_path_default, the_quarto_file, quiet = TRUE)
    ui_done('A new Quarto file has been written.\n\n')
  } else {
    ui_oops('\nQuarto file NOT added.\n\n')
  }

}
