#' Start a Quarto file with a formatted template header
#'
#' This function creates a new Quarto document with a pre-formatted YAML header. The
#' default template requires a _variables.yml file. If none exists in the project,
#' it will be created. The _variables.yml allows for a reusable custom header that
#' will be applied to all \code{froggeR} default-style Quarto documents.
#'
#' @param filename The name of the file without the '.qmd' extension. Only letters,
#' numbers, hyphens, and underscores are allowed.
#' @param path The path to the main project level. Defaults to the
#' current working directory.
#' @param default The default is set to TRUE and will create a Quarto template file
#' that pulls information from the folder/_variables.yml file.
#' @param is_project Set to \code{TRUE} when used within a Quarto project (internal use).
#'
#' @details
#' When \code{default = TRUE}, the function will create or verify the existence of:
#' \itemize{
#'   \item _variables.yml - For document metadata
#'   \item custom.scss - For document styling
#'   \item _quarto.yml - For project configuration
#' }
#'
#' If any of these files already exist, they will not be modified. For styling options,
#' visit \url{https://quarto.org/docs/output-formats/html-themes.html}.
#'
#' @return Creates a new Quarto document with formatted YAML and two blank starter
#' sections. Returns \code{invisible(NULL)}.
#'
#' @export
#' @examples
#' \dontrun{
#' # Create a new Quarto document with default settings
#' write_quarto(filename = "frogs", path = "path/to/project")
#'
#' # Create a basic Quarto document without custom formatting
#' write_quarto(filename = "simple_doc", default = FALSE)
#' }
write_quarto <- function(
    filename = 'frogs', path = getwd(), default = TRUE, is_project = FALSE
) {
  # Validate inputs
  if (!grepl('^[a-zA-Z0-9_-]+$', filename)) {
    stop(
      'Invalid filename. Use only letters, numbers, hyphens, and underscores.',
      '\nExample: "my-analysis" or "frog_report"'
    )
  }
  
  if (!is.logical(default) || !is.logical(is_project)) {
    stop('Parameters "default" and "is_project" must be TRUE or FALSE')
  }
  
  # Create directory if it doesn't exist
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
    ui_done('Created directory: {path}')
  }
  
  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)
  
  # Set up full file path
  the_quarto_file <- file.path(path, paste0(filename, '.qmd'))
  
  # Check for existing Quarto doc
  if (file.exists(the_quarto_file)) {
    ui_info('**CAUTION!!**')
    if (!ui_yeah(glue::glue('{filename}.qmd found in provided path! Would you like to overwrite it?'))) {
      ui_info("Keeping existing Quarto file")
      return(invisible(NULL))
    }
  }
  
  # If using the custom (default) template, ensure all requirements exist
  if (default && !is_project) {
    # Get or create settings
    settings <- froggeR_settings(interactive = FALSE)
    
    # Only create _variables.yml if it doesn't exist
    if (!file.exists(file.path(path, '_variables.yml'))) {
      .write_variables(path, settings)
      ui_done('Created _variables.yml')
    }
    
    # Check/create custom.scss
    if (!file.exists(file.path(path, 'custom.scss'))) {
      froggeR::write_scss(path = path, name = 'custom')
      ui_done('Created custom.scss')
    }
    
    # Create _quarto.yml if not in a project and needed
    # NOTE: without this, the Quarto doc will knit with ?var:<field> instead
    #   of actually displaying populated values.
    if (!file.exists(file.path(path, '_quarto.yml'))) {
      writeLines(
        sprintf('project:\n  title: "%s"', basename(path)),
        file.path(path, '_quarto.yml')
      )
      ui_done('Created _quarto.yml')
    }
  }
  
  # Select template based on default setting
  if (default) {
    template_path <- system.file('gists/custom_quarto.qmd', package = 'froggeR')
  } else {
    template_path <- system.file('gists/basic_quarto.qmd', package = 'froggeR')
  }
  
  if (template_path == "") {
    stop("Could not find Quarto template in package installation")
  }
  
  # Copy Quarto template to destination with error handling
  if (!file.copy(from = template_path, to = the_quarto_file, overwrite = TRUE)) {
    stop("Failed to create Quarto file")
  }
  ui_done(glue::glue('Created {filename}.qmd'))
  
  return(invisible(NULL))
}