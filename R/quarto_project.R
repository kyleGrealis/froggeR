#' Create a Custom 'Quarto' Project
#'
#' This function creates a new 'Quarto' project directory with additional froggeR 
#' features. It first calls \code{quarto::quarto_create_project()} to set up the 
#' basic structure, then enhances it with froggeR-specific files and settings.
#'
#' @param name Character string. The name of the 'Quarto' project directory and 
#'   initial \code{.qmd} file.
#' @param path Character string. Path to the project directory.
#' @param custom_yaml Logical. If TRUE (default), uses a custom YAML header in the initial
#'   \code{.qmd} file, populated with values from '_variables.yml'. If FALSE, uses a
#'   standard YAML header.
#'
#' @return Invisibly returns the path to the created project directory.
#'
#' @details
#' This function creates a 'Quarto' project with the following enhancements:
#' \itemize{
#'   \item \code{_variables.yml}: Stores reusable YAML variables (if \code{custom_yaml =
#'  TRUE})
#'   \item \code{.gitignore}: Enhanced settings for R projects
#'   \item \code{README.md}: Template README file
#'   \item \code{dated_progress_notes.md}: For project progress tracking
#'   \item \code{custom.scss}: Custom 'Quarto' styling (if \code{custom_yaml = TRUE})
#'   \item \code{.Rproj}: RStudio project file
#' }
#' If froggeR settings don't exist, it will prompt to create them.
#'
#' @seealso \code{\link{write_quarto}}, \code{\link{settings}}
#'
#' @examples
#' if (quarto::quarto_version() >= "1.4") {
#'   # Create a temporary directory for testing
#'   tmp_dir <- tempdir()
#' 
#'   # Create the Quarto project with custom YAML & associated files
#'   quarto_project("frogs", path = tempdir(), custom_yaml = TRUE)
#' 
#'   # Confirms files were created (optional, for user confirmation)
#'   file.exists(file.path(tmp_dir, "frogs.rproj"))  # Rproj file
#'   file.exists(file.path(tmp_dir, "frog.qmd"))     # Quarto doc
#'   file.exists(file.path(tmp_dir, "_quarto.yml"))  # project YAML file
#' 
#'   # Create a new Quarto project with standard Quarto YAML
#'   # quarto_project('frogs_standard', path = tempdir(), custom_yaml = FALSE)
#' 
#'   # Clean up: Remove the created temp directory and all files
#'   unlink(list.files(tempdir(), full.names = TRUE), recursive = TRUE)
#' }
#'
#' @export
quarto_project <- function(name, path = here::here(), custom_yaml = TRUE) {

  quarto_version <- quarto::quarto_version()
  if (quarto_version < "1.4") stop("You need a more updated version of Quarto to make projects. See http://quarto.org/docs/download to upgrade.")
  
  # Validate path
  if (is.null(path) || is.na(path) || !dir.exists(path)) {
    stop("Invalid `path`. Please enter a valid project directory.")
  }

  # Validate name
  if (!grepl('^[a-zA-Z0-9_-]+$', name)) {
    stop(
      'Invalid project name. Use only letters, numbers, hyphens, and underscores.',
      '\nExample: "my-project" or "frog_analysis"'
    )
  }
  
  if (!is.logical(custom_yaml)) {
    stop('Parameter `custom_yaml` must be TRUE or FALSE')
  }
  
  # Normalize the base directory path
  path <- normalizePath(path, mustWork = TRUE)
  
  # Create the full project path
  project_dir <- file.path(path, name)

  # Check if directory exists
  if (dir.exists(project_dir)) {
    stop(sprintf('Directory named "%s" exists in %s.', name, path))
  }
  
  # Create the Quarto project
  frog_prompt <- if (interactive()) FALSE else TRUE
  quarto::quarto_create_project(name, dir = path, quiet = TRUE, no_prompt = frog_prompt)
  ui_done(sprintf('Created Quarto project directory: %s', name))
  
  # Remove default files created by Quarto only if they exist
  default_qmd <- file.path(project_dir, paste0(name, '.qmd'))
  default_ignore <- file.path(project_dir, '.gitignore')
  if (file.exists(default_qmd)) file.remove(default_qmd)
  if (file.exists(default_ignore)) file.remove(default_ignore)
  
  ########################################################################
  ## .initialize_proj = TRUE stops the file from opening upon craetion  ##
  ## since all of the new files are written to a new project location.  ##
  ## If they were to be opened immediately, they would NOT open in the  ##
  ## chosen project directory                                           ##
  ########################################################################
  # If using custom_yaml template, create _variables.yml & custom.scss
  if (custom_yaml) {
    froggeR::write_variables(path = project_dir, .initialize_proj = TRUE)
    froggeR::write_scss(path = project_dir, .initialize_proj = TRUE)
  }
  
  # Create project files
  froggeR::write_ignore(path = project_dir, .initialize_proj = TRUE)
  froggeR::write_readme(path = project_dir, .initialize_proj = TRUE)
  froggeR::write_notes(path = project_dir, .initialize_proj = TRUE)

  # Create Quarto document
  froggeR::write_quarto(
    filename = name,
    path = project_dir,
    custom_yaml = custom_yaml,
    .initialize_proj = TRUE
  )

  # Start & open the project
  .write_rproj(name = name, path = project_dir)
  
  ui_done(
    sprintf(
      '%s project setup complete. Opening in new session...', col_green('froggeR')
    )
  )
  
  # Open project in new window & session:
  if (interactive()) rstudioapi::openProject(path = project_dir, newSession = TRUE)
  
  # Return the project directory path invisibly
  invisible(project_dir)
}
