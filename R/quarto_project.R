#' Create a custom Quarto project
#' 
#' This function is a wrapper for \code{quarto::quarto_create_project()} and adds some
#' other \code{froggeR} goodies. First, new Quarto project is created in the provided
#' \code{name} directory. Then, the original \code{.qmd} file created from the 
#' \code{quarto::quarto_create_project()} is replaced with \code{froggeR::write_quarto()}.
#' 
#' Since this will most likely be a new project directory, \code{froggeR} searches for 
#' the existence of three other files:
#' 
#'    - \code{_variables.yml}
#' 
#'    - \code{.gitignore}
#' 
#'    - \code{README.md}
#' 
#' If these files do not exist, \code{froggeR} will write them to the new project 
#' directory.
#' 
#' @param name The name of the Quarto project directory and initial \code{.qmd} file.
#' @param default Set to TRUE. This will use the custom YAML within the initial 
#' \code{.qmd} file. See \code{?froggeR::write_quarto()} for more details on
#' the default setting.
#' @return A Quarto project with \code{.qmd}, \code{.gitignore}, & \code{README.md} files.
#' 
#' @export
#' @examples
#' \dontrun{
#' # Create a new Quarto project that uses a custom formatted YAML header and
#' # all other listed files:
#' quarto_project('new_project', default = TRUE)
#' 
#' # Create a new Quarto project with generic YAML and all other listed files:
#' quarto_project('new_project_2', default = FALSE)
#' }

quarto_project <- function(name, default = TRUE) {
  quarto::quarto_create_project(name, quiet = TRUE)

  # remove default .qmd file created from Quarto project
  if (!file.remove(paste0(name, '/', name, '.qmd'))) {
    ui_oops('Unexpected $h!t happens!')
  }

  message('\n')
  ui_done(paste(name, 'Quarto project directory has been created.'))

  # Initialize project with default files:
  # Create Quarto doc
  froggeR::write_quarto(
    filename = name,
    path = glue::glue('{here::here()}/{name}'),
    default = default
  )
  # Create .gitignore
  froggeR::write_ignore(
    path = glue::glue('{here::here()}/{name}')
  )
  # Create README
  froggeR::write_readme(
    path = glue::glue('{here::here()}/{name}')
  )
  # Create .Rproj file
  froggeR::write_rproj(
    path = glue::glue('{here::here()}/{name}'),
    name = name
  )
}
NULL
