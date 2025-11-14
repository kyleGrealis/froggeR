#' Create a Custom Quarto Project
#'
#' This function creates a new Quarto project directory with additional froggeR
#' features. It first calls \code{quarto::quarto_create_project()} to set up the
#' basic structure, then enhances it with froggeR-specific files and settings.
#'
#' @param name Character. The name of the Quarto project directory and
#'   initial \code{.qmd} file. Must contain only letters, numbers, hyphens, and
#'   underscores.
#' @param path Character. Path to the parent directory where project will be created.
#'   Default is current project root via \code{\link[here]{here}}.
#' @param example Logical. If \code{TRUE} (default), creates a Quarto document with
#'   brand logo positioning and examples of within-document cross-referencing, links,
#'   and references.
#'
#' @return Invisibly returns the path to the created project directory.
#'
#' @details
#' This function creates a Quarto project with the following enhancements:
#' \itemize{
#'   \item \code{_brand.yml}: Stores Quarto project branding
#'   \item \code{logos}: Quarto project branding logos directory
#'   \item \code{_variables.yml}: Stores reusable YAML variables
#'   \item \code{.gitignore}: Enhanced settings for R projects
#'   \item \code{README.md}: Template README file
#'   \item \code{dated_progress_notes.md}: For project progress tracking
#'   \item \code{custom.scss}: Custom Quarto styling
#'   \item \code{references.bib}: Bibliography template
#' }
#'
#' The function requires Quarto version 1.6 or greater. Global froggeR settings
#' are automatically applied if available.
#'
#' @seealso \code{\link{write_quarto}}, \code{\link{settings}},
#'   \code{\link{brand_settings}}, \code{\link{write_brand}}, \code{\link{write_variables}},
#'   \code{\link{save_brand}}, \code{\link{save_variables}}
#'
#' @examples
#' if (interactive() && quarto::quarto_version() >= "1.6") {
#'
#'   # Create the Quarto project with custom YAML & associated files
#'   quarto_project("frogs", path = tempdir(), example = TRUE)
#'
#'   # Confirm files were created
#'   file.exists(file.path(tempdir(), "frogs", "frogs.qmd"))
#'   file.exists(file.path(tempdir(), "frogs", "_quarto.yml"))
#'
#' }
#'
#' @export
quarto_project <- function(name, path = here::here(), example = TRUE) {

  quarto_version <- quarto::quarto_version()
  if (quarto_version < '1.6') {
    rlang::abort(
      'You need Quarto version 1.6 or greater to use froggeR Quarto projects. See http://quarto.org/docs/download to upgrade.',
      class = 'froggeR_quarto_version_error'
    )
  }
  
  # Validate path
  if (is.null(path) || is.na(path) || !dir.exists(path)) {
    rlang::abort(
      'Invalid `path`. Please enter a valid project directory.',
      class = 'froggeR_invalid_path'
    )
  }

  # Validate name
  if (!grepl('^[a-zA-Z0-9_-]+$', name)) {
    rlang::abort(
      c(
        'Invalid project name. Use only letters, numbers, hyphens, and underscores.',
        'i' = 'Example: "my-project" or "frog_analysis"'
      ),
      class = 'froggeR_invalid_project_name'
    )
  }
  
  if (!is.logical(example)) {
    rlang::abort(
      'Parameter `example` must be TRUE or FALSE.',
      class = 'froggeR_invalid_argument'
    )
  }
  
  # Normalize the base directory path
  path <- normalizePath(path, mustWork = TRUE)
  
  # Create the full project path
  project_dir <- file.path(path, name)

  # Check if directory exists
    if (dir.exists(project_dir)) {
      rlang::abort(
        sprintf('Directory named "%s" exists in %s.', name, path),
        class = 'froggeR_directory_exists'
      )
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
    '  title: ""',
    sprintf('  title: "%s"', name)
  )
  readr::write_file(updated_content, the_quarto_file)
  ui_done('Created _quarto.yml')
  
  # Create project files
  create_variables(path = project_dir)
  create_brand(path = project_dir)
  create_scss(path = project_dir)
  create_ignore(path = project_dir)
  create_readme(path = project_dir)
  create_notes(path = project_dir)

  # Create Quarto document
  create_quarto(
    filename = name,
    path = project_dir,
    example = example
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

  # Return the project directory path invisibly (normalized)
  invisible(normalizePath(project_dir, mustWork = TRUE))
}
