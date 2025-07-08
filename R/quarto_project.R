#' Create a Custom 'Quarto' Project
#'
#' This function creates a new 'Quarto' project directory with additional froggeR 
#' features. It first calls \code{quarto::quarto_create_project()} to set up the 
#' basic structure, then enhances it with froggeR-specific files and settings.
#'
#' @param name Character string. The name of the 'Quarto' project directory and 
#'   initial \code{.qmd} file.
#' @param path Character string. Path to the project directory.
#' @param example Logical. If TRUE (default), creates a Quarto document with a default to 
#'   position the brand logo and examples of within-document cross-referencing, links,
#'   and references.
#'
#' @return Invisibly returns the path to the created project directory.
#'
#' @details
#' This function creates a 'Quarto' project with the following enhancements:
#' \itemize{
#'   \item \code{_brand.yml}: Stores Quarto project branding
#'   \item \code{logos}: Quarto project branding logos directory
#'   \item \code{_variables.yml}: Stores reusable YAML variables
#'   \item \code{.gitignore}: Enhanced settings for R projects
#'   \item \code{README.md}: Template README file
#'   \item \code{dated_progress_notes.md}: For project progress tracking
#'   \item \code{custom.scss}: Custom 'Quarto' styling
#' }
#' If froggeR settings don't exist, it will prompt to create them.
#'
#' @seealso \code{\link{write_quarto}}, \code{\link{settings}}
#'
#' @examples
#' if (interactive() && quarto::quarto_version() >= "1.6") {
#' 
#'   # Create the Quarto project with custom YAML & associated files
#'   quarto_project("frogs", path = tempdir(), example = TRUE)
#' 
#'   # Confirms files were created (optional, for user confirmation)
#'   file.exists(file.path(tempdir(), "frogs.qmd"))     # Quarto doc
#'   file.exists(file.path(tempdir(), "_quarto.yml"))  # project YAML file
#' 
#'   # Create a new Quarto project with standard Quarto (no examples)
#'   # quarto_project('frogs_standard', path = tempdir(), example = FALSE)
#' 
#' }
#'
#' @export
quarto_project <- function(name, path = here::here(), example = TRUE) {

  quarto_version <- quarto::quarto_version()
  if (quarto_version < "1.6") stop("You need Quarto version 1.6 or greater to use froggeR Quarto projects. See http://quarto.org/docs/download to upgrade.")
  
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
  
  if (!is.logical(example)) {
    stop('Parameter `example` must be TRUE or FALSE')
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
  default_quarto_yml <- file.path(project_dir, '_quarto.yml')
  default_qmd <- file.path(project_dir, paste0(name, '.qmd'))
  default_ignore <- file.path(project_dir, '.gitignore')
  if (file.exists(default_qmd)) file.remove(default_qmd)
  if (file.exists(default_quarto_yml)) file.remove(default_quarto_yml)
  if (file.exists(default_ignore)) file.remove(default_ignore)
  
  ########################################################################
  ## .initialize_proj = TRUE stops the file from opening upon creation  ##
  ## since all of the new files are written to a new project location.  ##
  ## If they were to be opened immediately, they would NOT open in the  ##
  ## chosen project directory                                           ##
  ########################################################################

  # Add _quarto.yml & modify
  template_path <- system.file('gists/quarto.yml', package = 'froggeR')
  the_quarto_file <- file.path(project_dir, "_quarto.yml")
  file.copy(from = template_path, to = the_quarto_file, overwrite = FALSE)
  # Update the title with the project name
  quarto_content <- readr::read_file(the_quarto_file)
  updated_content <- stringr::str_replace(
    quarto_content,
    "  title: \"\"",
    sprintf("  title: \"%s\"", name)
  )
  readr::write_file(updated_content, the_quarto_file)
  ui_done("Created _quarto.yml")
  
  # Create project files
  froggeR::write_variables(path = project_dir, .initialize_proj = TRUE)
  froggeR::write_brand(path = project_dir, .initialize_proj = TRUE)
  froggeR::write_scss(path = project_dir, .initialize_proj = TRUE)
  froggeR::write_ignore(path = project_dir, .initialize_proj = TRUE)
  froggeR::write_readme(path = project_dir, .initialize_proj = TRUE)
  froggeR::write_notes(path = project_dir, .initialize_proj = TRUE)

  # Create Quarto document
  froggeR::write_quarto(
    filename = name,
    path = project_dir,
    example = example,
    .initialize_proj = TRUE
  )

  # Add references.bib
  ref_template_path <- system.file('gists/references.bib', package = 'froggeR')
  the_ref_file <- file.path(project_dir, "references.bib")
  file.copy(from = ref_template_path, to = the_ref_file, overwrite = FALSE)
  ui_done("Created references.bib")

  # Start & open the project
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
