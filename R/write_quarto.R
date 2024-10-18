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
#' @param user You are the default user. You don't need to change this. 😉
#' @return A Quarto document with formatted YAML and two blank starter sections.
#' 
#' @export
#' @examples
#' \dontrun{
#' # To create new_doc.qmd:
#' write_quarto(filename = 'new_doc', path = '../path_to_location')
#' }

write_quarto <- function(filename = 'new', path = here::here(), user = 'default') {

  write_name <- filename
  write_path <- path
  confirm <- 'yes'

  # path to default Quarto header template
  gist_path_default <- paste0(
    'https://gist.githubusercontent.com/kyleGrealis/693e5d0df41576247900c3bef788d475/',
    # this changes as the default Quarto is updated
    'raw/aa57c43fae22fb101944b79347ac9cd673216e30/quarto_header.qmd'
  )

  # path to personalized Quarto header template
  gist_path_kyle <- paste0(
    'https://gist.githubusercontent.com/kyleGrealis/d8e61fc834f92868823e71ff26bda745/',
    # this changes as the personalized Quarto is updated
    'raw/fccb94634e37d8771971be68f6b881fca63152bb/kyle_quarto_header.qmd'
  )

  # Warn user if Quarto document already found in the project
  if (file.exists(paste0(write_path, '/', write_name, '.qmd'))) {
    message('**CAUTION!!**')
    answer <- readline(
      paste0(
        write_path, write_name, '.qmd found in provided path! Overwrite? [y/n] '
      )
    )
    # Confirm overwrite:
    if (str_to_lower(answer) %in% c('y', 'yes')) {
      confirm <- readline('Are you sure? [y/n] ')
    } else {
      confirm <- 'no'
    }
  }

  if (str_to_lower(confirm) %in% c('y', 'yes')) {
    # override gist path for Kyle
    if (user == 'kyle') { gist_path_default <- gist_path_kyle }

    download.file(gist_path_default, paste0(write_path, '/', write_name, '.qmd'))
    message('A new Quarto file has been written.')
  } else {
    message('\nQuarto file NOT added.')
  }

}
