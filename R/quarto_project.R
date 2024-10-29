#' Create a custom Quarto project
#' 
#' This function is a wrapper for \code{quarto::quarto_create_project()} and adds some
#' other \code{froggeR} goodies. First, new Quarto project is created in the provided
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
#' \code{custom.scss} & \code{.Rproj} files.
#' 
#' @export
#' @examples
#' \dontrun{
#' # Create a new Quarto project that uses a custom formatted YAML header and
#' # all other listed files:
#' quarto_project('new_project', base_dir = getwd(), default = TRUE)
#' 
#' # Create a new Quarto project with generic YAML and all other listed files:
#' quarto_project('new_project_2', base_dir = getwd(), default = FALSE)
#' }

quarto_project <- function(name, base_dir = getwd(), default = TRUE) {

  # Normalize the base directory path
  base_dir <- normalizePath(base_dir, mustWork = TRUE)
  
  # Create the full project path
  project_dir <- file.path(base_dir, name)
  
  # Create the Quarto project
  quarto::quarto_create_project(name, quiet = TRUE)

  # Construct the path to the default .qmd file
  default_qmd <- file.path(project_dir, paste0(name, '.qmd'))

  # Remove the default .qmd file from quarto::create_quarto_project()
  if (!file.remove(default_qmd)) {
    ui_oops('Could not remove default Quarto document!')
    return(invisible(FALSE))
  }

  message('\n')
  ui_done(paste(name, 'Quarto project directory has been created.'))

  # Initialize project with default files:
  # Create Quarto doc
  froggeR::write_quarto(
    filename = name,
    path = project_dir,
    default = default,
    proj = TRUE
  )
  # Create .gitignore
  froggeR::write_ignore(
    path = project_dir
  )
  # Create README
  froggeR::write_readme(
    path = project_dir
  )
  # Create .scss file
  froggeR::write_scss(
    path = project_dir,
    name = 'custom'
  )
  # Create .Rproj file
  froggeR::write_rproj(
    path = project_dir,
    name = name
  )

  # Return the project directory path invisibly
  invisible(project_dir)
}
NULL
