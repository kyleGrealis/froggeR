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

  ############################################################################
  # Check if directory exists and create if necessary
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
  }
  ############################################################################

  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)
  
  # Use file.path instead of paste0 for better path handling
  the_quarto_file <- file.path(path, paste0(filename, '.qmd'))
  abort <- FALSE

  # Warn user if a Quarto document with the same name already found in the project
  if (file.exists(the_quarto_file)) {
    ui_info('**CAUTION!!**')
    abort <- ui_nope('{the_quarto_file} found in provided path! Overwrite?')
  }

  if (!abort) {
    if (!default) { # not started with custom Quarto YAML header:
      
      # Get the correct path to template in installed package
      template_path <- system.file('gists/basic_quarto.qmd', package = 'froggeR')
      
      if (template_path == '') {
        stop('Could not find basic_quarto.qmd template in package installation')
      }
      
      # Copy the template
      invisible(file.copy(
        from = template_path,
        to = file.path(path, paste0(filename, '.qmd'))
      ))

    } else { # started with custom Quarto YAML header:
      
      # check if _variables.yml exists and prompt user to create if FALSE
      if (!file.exists(file.path(path, '_variables.yml'))) {
        message('\nLet\'s create a custom _variables.yml file...')
        message('\n')
        # use the same path as where the Quarto doc will be created
        froggeR::write_variables(path)
      }
      
      # Get the correct path to template in installed package
      template_path <- system.file('gists/custom_quarto.qmd', package = 'froggeR')
      
      if (template_path == '') {
        stop('Could not find custom_quarto.qmd template in package installation')
      }
      
      # Copy the template
      invisible(file.copy(
        from = template_path,
        to = file.path(path, paste0(filename, '.qmd'))
      ))

      ui_done('\nA new Quarto file has been created.\n\n')

      # Check if a .scss file is found in project
      scss_files_found_in_proj <- list.files(
        path = path, 
        pattern = '\\.scss$', 
        full.names = TRUE, 
        recursive = FALSE
      )

      # If not a Quarto project and no SCSS found:
      if (!proj & length(scss_files_found_in_proj) == 0) {
        ui_info('OOPS... I cannot find a styles sheet (SCSS)!')
        if (ui_yeah('Would you like to create one now?')) {
          froggeR::write_scss(path = path, name = 'custom')
        } else {
          ui_todo('You will either need to create one later with `froggeR::write_scss()` or be sure comment out the appropriate 'theme' line in the Quarto YAML!')
        }
      }
      
    }

  } else {
    # Errors occured or user chose not to continue:
    ui_oops('\nQuarto file NOT created.\n\n')
  }

}
NULL
