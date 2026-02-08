#' Create a Custom Quarto Project
#'
#' @description
#' \strong{Deprecated.} \code{quarto_project()} has been replaced by \code{\link{init}()}, which
#' downloads the latest opinionated scaffold from GitHub. This function now
#' creates the project directory and delegates to \code{init()}.
#'
#' @param name Character. The name of the Quarto project directory.
#' @param path Character. Path to the parent directory where project will be created.
#'   Default is current project root via \code{\link[here]{here}}.
#' @param example Logical. Ignored. Kept for backward compatibility.
#'
#' @return Invisibly returns the path to the created project directory.
#'
#' @seealso \code{\link{init}}
#'
#' @examples
#' \dontrun{
#' quarto_project("frogs", path = tempdir())
#' }
#'
#' @export
quarto_project <- function(name, path = here::here(), example = TRUE) {
  ui_warn(
    c(
      sprintf("%s is deprecated. Use %s instead.", col_green("quarto_project()"), col_green("init()")),
      "i" = "See ?init for details."
    )
  )

  # Validate path
  if (is.null(path) || is.na(path) || !dir.exists(path)) {
    rlang::abort(
      "Invalid `path`. Please enter a valid project directory.",
      class = "froggeR_invalid_path"
    )
  }

  # Validate name
  if (!grepl("^[a-zA-Z0-9_-]+$", name)) {
    rlang::abort(
      c(
        "Invalid project name. Use only letters, numbers, hyphens, and underscores.",
        "i" = 'Example: "my-project" or "frog_analysis"'
      ),
      class = "froggeR_invalid_project_name"
    )
  }

  path <- normalizePath(path, mustWork = TRUE)
  project_dir <- file.path(path, name)

  if (dir.exists(project_dir)) {
    rlang::abort(
      sprintf('Directory named "%s" exists in %s.', name, path),
      class = "froggeR_directory_exists"
    )
  }

  dir.create(project_dir)
  invisible(init(path = project_dir))
}
