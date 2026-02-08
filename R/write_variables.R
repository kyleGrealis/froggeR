#' Write Variables YAML for Quarto Projects
#'
#' Creates or opens a \code{_variables.yml} file in a Quarto project for editing.
#' If the file already exists, it is opened directly. If global froggeR settings
#' exist, those are used as the starting point. Otherwise, the template is
#' downloaded from the
#' \href{https://github.com/kyleGrealis/frogger-templates}{frogger-templates}
#' repository.
#'
#' @param path Character. Path to the project directory. Default is current project
#'   root via \code{\link[here]{here}}.
#'
#' @return Invisibly returns the path to the file.
#'
#' @details
#' The \code{_variables.yml} file stores reusable author metadata that Quarto
#' documents can reference. Available fields:
#'
#' \itemize{
#'   \item \code{name}: Your full name as it appears in publications
#'   \item \code{email}: Contact email address
#'   \item \code{orcid}: ORCID identifier (e.g., 0000-0001-2345-6789)
#'   \item \code{url}: Personal website or profile URL
#'   \item \code{github}: GitHub username
#'   \item \code{affiliations}: Institution, department, etc.
#' }
#'
#' Use \code{\link{save_variables}} to persist your project-level metadata to
#' the global config directory for reuse across projects.
#'
#' @examples
#' \dontrun{
#' write_variables()
#' }
#'
#' @seealso \code{\link{save_variables}}, \code{\link{write_brand}},
#'   \code{\link{init}}
#' @export
write_variables <- function(path = here::here()) {

  path <- .validate_and_normalize_path(path)
  config_path <- rappdirs::user_config_dir("froggeR")
  config_file <- file.path(config_path, "_variables.yml")

  complete_filename <- "_variables.yml"

  dest <- .open_or_create(
    dest_file = file.path(path, complete_filename),
    template_repo_path = complete_filename,
    label = complete_filename,
    global_config_file = config_file
  )

  dest <- normalizePath(dest, mustWork = TRUE)

  if (interactive()) usethis::edit_file(dest)
  
  ui_info(paste(
    "Field reference:", 
    "https://www.kyleGrealis.com/froggeR/reference/write_variables.html"
  ))

  invisible(dest)
}
