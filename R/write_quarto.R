#' Start a Quarto file with a formatted template header
#' 
#' This function creates a new Quarto document with a pre-formatted YAML header. The 
#' default template requires a _variables.yml file. If none exists in the project, 
#' a prompt is provided to create the file. The _variables.yml allows for a reusable
#' custom header that will be applied to all \code{froggeR} default-style Quarto 
#' documents. 
#' 
#' When \code{default = TRUE}, the project \code{path} is checked for a SCSS sheet.
#' If none is found, a prompt offers to create one.
#' 
#' NOTE: Please visit \url{https://quarto.org/docs/output-formats/html-themes.html} to 
#' explore more Quarto theming options.
#' 
#' @param filename The name of the file. Do not include '.qmd'
#' @param path The path to the main project level. Defaults to the 
#' current working directory.
#' @param default The default is set to TRUE and will create a Quarto template file
#' that pulls infomation from the folder/_variables.yml file.
#' @param proj Set to \code{TRUE} for Quarto projects (for internal use).
#' @return A Quarto document with formatted YAML and two blank starter sections.
#' 
#' @export
#' @examples
#' \dontrun{
#' # To create new_doc.qmd:
#' write_quarto(filename = "new_doc", path = "path/to/project")
#' }

write_quarto <- function(
  filename = 'new', path = getwd(), default = TRUE, proj = FALSE
) {

  # Check if directory exists
  if (!dir.exists(path)) {
    # Exit if directory does not exist
    stop("Directory does not exist") 
    return(NULL)
  } 

  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)
  
  # Use file.path instead of paste0 for better path handling
  the_quarto_file <- file.path(path, paste0(filename, '.qmd'))
  abort <- FALSE

  # path to default Quarto header template using _variables.yml
  gist_path_default <- paste0(
    'https://gist.githubusercontent.com/kyleGrealis/60487135cff714dcb8312b8312df9fc7/',
    # this changes as the default Quarto is updated
    'raw/4a2769e45452001434367141c134e99f7f40a2b7/frogger_quarto.qmd'
  )

  # path to Quarto header template the user must complete
  gist_path_other <- paste0(
    'https://gist.githubusercontent.com/kyleGrealis/693e5d0df41576247900c3bef788d475/',
    # this changes as the personalized Quarto is updated
    'raw/bea0cc31e505181e8c337264540f3f8a0eb038dd/quarto_header.qmd'
  )

  # Warn user if Quarto document already found in the project
  if (file.exists(the_quarto_file)) {
    ui_info('**CAUTION!!**')
    abort <- ui_nope('{the_quarto_file} found in provided path! Overwrite?')
  }

  if (!abort) {
    if (default) {
      
      # check if _variables.yml exists and prompt user to create if FALSE
      if (!file.exists(file.path(path, '_variables.yml'))) {
        message('\nLet\'s create a custom _variables.yml file...')
        message('\n')
        # use the same path as where the Quarto doc will be created
        froggeR::write_variables(path)
      }
      
    } else {
      # override gist path for template that doesn't use custom yml file
      gist_path_default <- gist_path_other 
    }


    download.file(gist_path_default, the_quarto_file, quiet = TRUE)
    ui_done('\nA new Quarto file has been created.\n\n')

    # Check if a .scss file is found in project
    listed_files <- list.files(
      path = path, 
      pattern = '\\.scss$', 
      full.names = TRUE, 
      recursive = FALSE
    )
    # If not a Quarto project and no SCSS found:
    if (!proj & length(listed_files) == 0) {
      ui_info('OOPS... I cannot find a styles sheet (SCSS)!')
      if (ui_yeah('Would you like to create one now?')) {
        froggeR::write_scss(path = path, name = 'custom')
      } else {
        ui_todo('You will either need to create one later with `froggeR::write_scss()` or be sure comment out the appropriate "theme" line in the Quarto YAML!')
      }
    }

  } else {
    ui_oops('\nQuarto file NOT created.\n\n')
  }

}
NULL
