#' Create a custom Quarto project
#' 
#' This function is a wrapper for \code{quarto::quarto_create_project()} and adds some
#' other \code{froggeR} goodies. First, a new Quarto project is created in the provided
#' \code{name} directory. Then, the original \code{.qmd} file created from the 
#' \code{quarto::quarto_create_project()} is replaced with \code{froggeR::write_quarto()}.
#' 
#' Since this will most likely be a new project directory, \code{froggeR} searches for 
#' the existence of these other files and creates them by default:
#' 
#'    - \code{_variables.yml}
#' 
#'    - \code{.gitignore}
#' 
#'    - \code{README.md}
#' 
#'    - \code{DATED_PROGRESS_NOTES.md}
#' 
#'    - \code{custom.scss}
#' 
#'    - \code{.Rproj}
#' 
#' If these files do not exist, \code{froggeR} will write them to the new project 
#' directory.
#' 
#' @param name The name of the Quarto project directory and initial \code{.qmd} file.
#' @param base_dir Base directory where the project should be created. Defaults to 
#' current working directory.
#' @param default Set to TRUE. This will use the custom YAML within the initial. Change 
#' to \code{FALSE} if you would like the initial Quarto document to have a standard 
#' YAML header.
#' \code{.qmd} file. See \code{?froggeR::write_quarto()} for more details on
#' the default setting.
#' @return A Quarto project with \code{.qmd}, \code{.gitignore}, \code{README.md}, 
#' \code{DATED_PROGRESS_NOTES.md}, \code{custom.scss} & \code{.Rproj} files.
#' 
#' @export
#' @examples
#' \dontrun{
#' # Create a new Quarto project that uses a custom formatted YAML header and
#' # all other listed files:
#' quarto_project('frog_project', base_dir = getwd(), default = TRUE)
#' 
#' # Create a new Quarto project with generic YAML and all other listed files:
#' quarto_project('frog_project_2', base_dir = getwd(), default = FALSE)
#' }

quarto_project <- function(name, base_dir = getwd(), default = TRUE) {

  # Validate inputs
  if (!grepl('^[a-zA-Z0-9_-]+$', name)) {
    stop(
      'Invalid project name. Use only letters, numbers, hyphens, and underscores.',
      '\nExample: "my-project" or "frog_analysis"'
    )
  }

  if (!is.logical(default)) {
    stop('Parameter "default" must be TRUE or FALSE')
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
    stop(glue::glue('Directory named "{name}" exists in {base_dir}.')) 
  }
  
  # Create the Quarto project
  quarto::quarto_create_project(name, quiet = TRUE)
  ui_done(paste(name, 'Created a Quarto project directory'))

  # Remove default files created by Quarto only if they exist
  default_qmd <- file.path(project_dir, paste0(name, '.qmd'))
  default_ignore <- file.path(project_dir, '.gitignore')
  
  if (file.exists(default_qmd)) file.remove(default_qmd)
  if (file.exists(default_ignore)) file.remove(default_ignore)

  # Set-up core requirements
  if (is.null(getOption('froggeR.options'))) {
    froggeR::write_options()
  }
  froggeR::write_variables(project_dir)

  # Create project files
  froggeR::write_ignore(path = project_dir)
  froggeR::write_readme(path = project_dir)
  froggeR::write_rproj(path = project_dir, name = name)

  # Create Quarto document
  froggeR::write_quarto(
    filename = name,
    path = project_dir,
    default = default,
    is_project = TRUE
  )

  ui_done('froggeR project setup complete. Opening in new session...')

  # Open project in new window & session:
  rstudioapi::openProject(path = project_dir, newSession = TRUE)

  # Return the project directory path invisibly
  invisible(project_dir)

}
