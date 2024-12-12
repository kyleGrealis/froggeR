#' Create a custom Quarto project
#'
#' This function creates a new Quarto project directory with additional froggeR 
#' features. It first calls \code{quarto::quarto_create_project()} to set up the 
#' basic structure, then enhances it with froggeR-specific files and settings.
#'
#' @param name Character string. The name of the Quarto project directory and 
#'   initial \code{.qmd} file.
#' @param base_dir Character string. Base directory where the project should be created.
#'   Defaults to the current working directory.
#' @param custom_yaml Logical. If TRUE (default), uses a custom YAML header in the initial
#'   \code{.qmd} file, populated with values from '_variables.yml'. If FALSE, uses
#'   Quarto's standard YAML header.
#'
#' @return Invisibly returns the path to the created project directory.
#'
#' @details
#' This function creates a Quarto project with the following enhancements:
#' \itemize{
#'   \item \code{_variables.yml}: Stores reusable YAML variables (if \code{custom_yaml = TRUE})
#'   \item \code{.gitignore}: Enhanced settings for R projects
#'   \item \code{README.md}: Template README file
#'   \item \code{dated_progress_notes.md}: For project progress tracking
#'   \item \code{custom.scss}: Custom Quarto styling (if \code{custom_yaml = TRUE})
#'   \item \code{.Rproj}: RStudio project file
#' }
#' If froggeR settings don't exist, it will prompt to create them.
#'
#' @seealso \code{\link{write_quarto}}, \code{\link{froggeR_settings}}
#'
#' @export
#' @examples
#' \donttest{
#'   # Create a new Quarto project with custom formatted YAML header
#'   quarto_project('frogs', base_dir = tempdir(), custom_yaml = TRUE)
#'
#'   # Create a new Quarto project with standard Quarto YAML
#'   quarto_project('frogs_standard', base_dir = tempdir(), custom_yaml = FALSE)
#' }
quarto_project <- function(name, base_dir = getwd(), custom_yaml = TRUE) {
  # Validate inputs
  if (!grepl('^[a-zA-Z0-9_-]+$', name)) {
    stop(
      'Invalid project name. Use only letters, numbers, hyphens, and underscores.',
      '\nExample: "my-project" or "frog_analysis"'
    )
  }
  
  if (!is.logical(custom_yaml)) {
    stop('Parameter "custom_yaml" must be TRUE or FALSE')
  }
  
  # Validate base_dir isn't a file path
  if (file.exists(base_dir) && !dir.exists(base_dir)) {
    stop('base_dir must be a directory, not a file')
  }
  
  # Normalize the base directory path
  base_dir <- normalizePath(base_dir, mustWork = TRUE)
  
  # Create the full project path
  project_dir <- file.path(base_dir, name)
  
  # Check if directory exists
  if (dir.exists(project_dir)) {
    stop(sprintf('Directory named "%s" exists in %s.', name, base_dir))
  }
  
  # Create the Quarto project
  quarto::quarto_create_project(name, quiet = TRUE)
  ui_done(paste(name, 'Created a Quarto project directory'))
  
  # Remove default files created by Quarto only if they exist
  default_qmd <- file.path(project_dir, paste0(name, '.qmd'))
  default_ignore <- file.path(project_dir, '.gitignore')
  if (file.exists(default_qmd)) file.remove(default_qmd)
  if (file.exists(default_ignore)) file.remove(default_ignore)
  
  # Setup core requirements
  settings <- froggeR_settings(update = FALSE)
  .update_variables_yml(project_dir, settings)
  .check_settings(settings)
  
  # Create project files
  froggeR::write_ignore(path = project_dir)
  froggeR::write_readme(path = project_dir)
  .write_rproj(name = name, path = project_dir)

  # If using custom_yaml template, create SCSS
  if (custom_yaml) {
    froggeR::write_scss(path = project_dir, name = 'custom')
  }
  
  # Create Quarto document
  froggeR::write_quarto(
    filename = name,
    path = project_dir,
    custom_yaml = custom_yaml,
    initialize_project = TRUE
  )
  
  ui_done(
    sprintf(
      '%s project setup complete. Opening in new session...', col_green('froggeR')
    )
  )
  
  # Open project in new window & session:
  rstudioapi::openProject(path = project_dir, newSession = TRUE)
  
  # Return the project directory path invisibly
  invisible(project_dir)
}

# Internal helper function for creating .Rproj files
.write_rproj <- function(name, path = getwd()) {
  # Check if directory exists
  if (!dir.exists(path)) {
    stop("Directory does not exist")
  }
  
  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)
  
  # Define the target file path
  the_rproj_file <- file.path(path, paste0(name, '.Rproj'))
  
  # Check for existing .Rproj
  if (file.exists(the_rproj_file)) {
    ui_info('**CAUTION!!**')
    if (!ui_yeah('.Rproj found in project level directory! Would you like to overwrite it?')) {
      ui_info("Keeping existing .Rproj")
      return(invisible(NULL))
    }
  }
  
  # Define .Rproj content
  content <- sprintf('
Version: 1.0
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
')
  
  # Write .Rproj file
  writeLines(content, the_rproj_file)
  ui_done(paste0('Created ', name, '.Rproj'))
  
  return(invisible(NULL))
}
