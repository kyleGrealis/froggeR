#' Start a Quarto file with a formatted template header
#' 
#' This function creates a new Quarto document with a pre-formatted YAML header. The 
#' default template requires a _variables.yml file. If none exists in the project, 
#' it will be created. The _variables.yml allows for a reusable custom header that 
#' will be applied to all \code{froggeR} default-style Quarto documents. 
#' 
#' When \code{default = TRUE}, all necessary supporting files (SCSS, _variables.yml,
#' and _quarto.yml) will be created if they don't exist.
#' 
#' NOTE: Please visit \url{https://quarto.org/docs/output-formats/html-themes.html} to 
#' explore more Quarto theming options.
#' 
#' @param filename The name of the file. Do not include '.qmd'
#' @param path The path to the main project level. Defaults to the 
#' current working directory.
#' @param default The default is set to TRUE and will create a Quarto template file
#' that pulls information from the folder/_variables.yml file.
#' @param is_project Set to \code{TRUE} when used within a Quarto project (internal use).
#' @return A Quarto document with formatted YAML and two blank starter sections.
#' 
#' @export
#' @examples
#' \dontrun{
#' # To create frogs.qmd:
#' write_quarto(filename = "frogs", path = "path/to/project")
#' }

write_quarto <- function(
  filename = 'frogs', path = getwd(), default = TRUE, is_project = FALSE
) {

  # Create directory if it doesn't exist
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
    ui_done('Created directory: {path}')
  }

  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)
  
  # Set up full file path
  the_quarto_file <- file.path(path, paste0(filename, '.qmd'))

  # Warn user if a Quarto document with the same name already found in the project
  if (file.exists(the_quarto_file)) {
    ui_info('**CAUTION!!**')
    if (ui_nope('{the_quarto_file} found in provided path! Overwrite?')) {
      ui_oops('\nQuarto file NOT created.\n\n')
      return(invisible(NULL))
    }
  }

  # If the users wants to use the custom YAML template check/create requirements
  if (default) {
    # Check/create froggeR.options in .Rprofile
    if (is.null(getOption('froggeR.options'))) {
      froggeR::write_options()
    }

    # Check/create _variables.yml to populate knitted Quarto doc
    if (!file.exists(file.path(path, '_variables.yml'))) {
      froggeR::write_variables(path)
      ui_done('Created _variables.yml')
    }

    # Check/create custom.scss
    if (!file.exists(file.path(path, 'custom.scss'))) {
      froggeR::write_scss(path, name = 'custom')
      ui_done('Created custom.scss')
    }

    # Check/create _quarto.yml if not in a project
    # NOTE: without this, the Quarto doc will knit with ?var:<field> instead
    #   of actually displaying populated values.
    if (!is_project && !file.exists(file.path(path, '_quarto.yml'))) {
      writeLines(
        sprintf('project:\n  title: "%s"', basename(path)),
        file.path(path, '_quarto.yml')
      )
      ui_done('Created _quarto.yml')
    }

    # Get custom-styled Quarto template
    template_path <- system.file('gists/custom_quarto.qmd', package = 'froggeR')
  } else {
    # Get basic Quarto template
    template_path <- system.file('gists/basic_quarto.qmd', package = 'froggeR')
  }

  # Copy Quarto template to destination
  # NOTE: overwrite=TRUE required to override the default .qmd that
  #   is created when using quarto::quarto_create_project().
  file.copy(from = template_path, to = the_quarto_file, overwrite = TRUE)
  ui_done('Created a new Quarto file')

  return(invisible(NULL))

}

