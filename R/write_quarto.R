#' Start a Quarto file with a formatted template header
#' 
#' This function creates a new Quarto document with a pre-formatted YAML header. The 
#' default template requires a _variables.yml file. If none exists in the project, 
#' a prompt is provided to create the file. The _variables.yml allows for a reusable
#' custom header that will be applied to all \code{froggeR} default-style Quarto 
#' documents. 
#' 
#' NOTE: Please visit \url{https://quarto.org/docs/output-formats/html-themes.html} to 
#' explore more Quarto theming options.
#' 
#' @param filename The name of the file. Do not include '.qmd'
#' @param path The path to the main project level. Defaults to returned value
#' from \code{here::here()}.
#' @param default The default is set to TRUE and will create a Quarto template file
#' that pulls infomation from the folder/_variables.yml file.
#' @return A Quarto document with formatted YAML and two blank starter sections.
#' 
#' @export
#' @examples
#' \dontrun{
#' # To create new_doc.qmd:
#' write_quarto(filename = 'new_doc', path = '../path_to_location')
#' }

write_quarto <- function(filename = 'new', path = here::here(), default = TRUE) {

  the_quarto_file <- paste0(path, '/', filename, '.qmd')
  abort <- FALSE

  # path to default Quarto header template using _variables.yml
  gist_path_default <- paste0(
    'https://gist.githubusercontent.com/kyleGrealis/60487135cff714dcb8312b8312df9fc7/',
    # this changes as the default Quarto is updated
    'raw/fac38bc0c3c63a65f8e252aa562db0177115259e/frogger_quarto.qmd'
  )

  # path to Quarto header template the user must complete
  gist_path_other <- paste0(
    'https://gist.githubusercontent.com/kyleGrealis/693e5d0df41576247900c3bef788d475/',
    # this changes as the personalized Quarto is updated
    'raw/63b42f341882f24f2c319c1feb74a66f99a30438/quarto_header.qmd'
  )

  # Warn user if Quarto document already found in the project
  if (file.exists(the_quarto_file)) {
    ui_info('**CAUTION!!**')
    abort <- ui_nope('{the_quarto_file} found in provided path! Overwrite?')
  }

  if (!abort) {
    if (default) {
      
      # check if _variables.yml exists and prompt user to create if FALSE
      if (!file.exists(paste0(path, '/_variables.qmd'))) {
        message('You need to create a custom _variables.yml file. Here we go!')
        # use the same path as where the Quarto doc will be created
        froggeR::write_variables(path)
      }
      
    } else {
      # override gist path for template that doesn't use custom yml file
      gist_path_default <- gist_path_other 
    }


    download.file(gist_path_default, the_quarto_file, quiet = TRUE)
    ui_done('\nA new Quarto file has been created.\n\n')
  } else {
    ui_oops('\nQuarto file NOT created.\n\n')
  }

}
