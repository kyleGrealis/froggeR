#' Create a new Quarto document
#'
#' This function creates a new Quarto document (\code{.qmd} file) with either a custom
#' or standard YAML header. When using a custom header, it integrates with 
#' \code{_variables.yml} for reusable metadata across documents.
#'
#' @param filename Character string. The name of the file without the '.qmd' extension.
#'   Only letters, numbers, hyphens, and underscores are allowed.
#' @param path Character string. The directory where the file will be created. 
#'   Defaults to the current working directory.
#' @param custom_yaml Logical. If TRUE (default), creates a Quarto document with a
#'   custom YAML header using values from '_variables.yml'. If FALSE, creates a
#'   standard Quarto document with basic YAML headers.
#' @param initialize_project Logical. Set to TRUE when used within a Quarto project 
#'   (internal use).
#'
#' @return Invisibly returns NULL after creating the Quarto document.
#'
#' @details
#' When \code{custom_yaml = TRUE} and \code{initialize_project = FALSE}, 
#'  the function will:
#' \itemize{
#'   \item Create or update \code{_variables.yml} for document metadata
#'   \item Create \code{custom.scss} for document styling (if it doesn't exist)
#'   \item Create \code{_quarto.yml} for project configuration (if it doesn't exist)
#' }
#' Existing files will not be modified. For Quarto styling options, see
#' \url{https://quarto.org/docs/output-formats/html-themes.html}.
#'
#' If froggeR settings don't exist and \code{custom_yaml = TRUE}, the function will
#' prompt the user to create settings using \code{froggeR_settings()}.
#'
#' @seealso \code{\link{quarto_project}}, \code{\link{froggeR_settings}}
#'
#' @export
#' @examples
#' \dontrun{
#'   # Create a new Quarto document with custom YAML
#'   write_quarto(filename = "frog_analysis", path = tempdir())
#'
#'   # Create a basic Quarto document with standard YAML
#'   write_quarto(filename = "frog_analysis_basic", path = tempdir(), custom_yaml = FALSE)
#' }
write_quarto <- function(
  filename = 'frogs', path = getwd(), custom_yaml = TRUE, initialize_project = FALSE
) {
  # Validate inputs
  if (!grepl('^[a-zA-Z0-9_-]+$', filename)) {
    stop(
      'Invalid filename. Use only letters, numbers, hyphens, and underscores.',
      '\nExample: "my-analysis" or "frog_report"'
    )
  }
  
  if (!is.logical(custom_yaml) || !is.logical(initialize_project)) {
    stop('Parameters "custom_yaml" and "initialize_project" must be TRUE or FALSE')
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
    if (!ui_yeah(sprintf('%s.qmd found in provided path! Would you like to overwrite it?', filename))) {
      ui_info("Keeping existing Quarto file")
      return(invisible(NULL))
    }
  }
  
  # If using the custom (custom_yaml) template, ensure all requirements exist
  if (custom_yaml && !initialize_project) {
    # Setup core requirements
    settings <- froggeR_settings(update = FALSE)
    .update_variables_yml(path, settings)
    .check_settings(settings)
    
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
  
  # Select template based on custom_yaml setting
  if (custom_yaml) {
    template_path <- system.file('gists/custom_quarto.qmd', package = 'froggeR')
    description <- 'with custom YAML'
  } else {
    template_path <- system.file('gists/basic_quarto.qmd', package = 'froggeR')
    description <- ''
  }
  
  if (template_path == "") {
    stop("Could not find Quarto template in package installation")
  }
  
  # Copy Quarto template to destination with error handling
  if (!file.copy(from = template_path, to = the_quarto_file, overwrite = TRUE)) {
    stop("Failed to create Quarto file")
  }
  ui_done(sprintf('Created %s.qmd %s', filename, description))
  
  return(invisible(NULL))
}