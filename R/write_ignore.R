#' Create a .gitignore File
#'
#' Creates or opens a \code{.gitignore} file in a Quarto project. If the file
#' already exists, it is opened directly. Otherwise, the opinionated template is
#' downloaded from the
#' \href{https://github.com/kyleGrealis/frogger-templates}{frogger-templates}
#' repository.
#'
#' @param path Character. Path to the project directory. Default is current project
#'   root via \code{\link[here]{here}}.
#'
#' @return Invisibly returns the path to the file.
#'
#' @examples
#' \dontrun{
#' write_ignore()
#' }
#'
#' @seealso \code{\link{init}}, \code{\link{write_quarto}}
#' @export
write_ignore <- function(path = here::here()) {

  path <- .validate_and_normalize_path(path)

  complete_filename <- ".gitignore"

  dest <- .open_or_create(
    dest_file = file.path(path, complete_filename),
    template_repo_path = complete_filename,
    label = complete_filename
  )

  dest <- normalizePath(dest, mustWork = TRUE)

  if (interactive()) usethis::edit_file(dest)

  invisible(dest)
}
