#' Create a New Quarto Document
#'
#' Downloads the Quarto template from the
#' \href{https://github.com/kyleGrealis/frogger-templates}{frogger-templates}
#' repository and writes it to the \code{pages/} directory. Errors if a file
#' with the same name already exists.
#'
#' @param filename Character. The name of the file without the \code{.qmd}
#'   extension. Only letters, numbers, hyphens, and underscores are allowed.
#'   Default is \code{"Untitled-1"}.
#' @param path Character. Path to the project directory. Default is current project
#'   root via \code{\link[here]{here}}.
#'
#' @return Invisibly returns the path to the created Quarto document.
#'
#' @details
#' The file is written to \code{pages/<filename>.qmd}. The \code{pages/}
#' directory is created automatically if it does not exist.
#'
#' @examples
#' \dontrun{
#' # Create a Quarto document with the default name
#' write_quarto()
#'
#' # Create a Quarto document with a custom name
#' write_quarto(filename = "analysis")
#' }
#'
#' @seealso \code{\link{init}}, \code{\link{write_variables}},
#'   \code{\link{write_brand}}
#' @export
write_quarto <- function(filename = "Untitled-1", path = here::here()) {

  path <- .validate_and_normalize_path(path)

  # Validate filename
  if (!is.character(filename)) {
    rlang::abort("Invalid filename: must be a character string.")
  }
  if (!grepl("^[a-zA-Z0-9_-]+$", filename)) {
    rlang::abort("Invalid filename. Use only letters, numbers, hyphens, and underscores.")
  }

  # Ensure pages/ directory exists
  pages_dir <- file.path(path, "pages")
  fs::dir_create(pages_dir)

  complete_filename <- paste0("pages/", filename, ".qmd")
  dest <- file.path(path, complete_filename)

  # Multi-file writer: error on duplicate
  if (file.exists(dest)) {
    rlang::abort(
      sprintf("%s.qmd already exists in pages/.", filename),
      class = "froggeR_file_exists"
    )
  }

  # Fetch template from GitHub
  template <- .fetch_template("pages/index.qmd")
  file.copy(from = template, to = dest, overwrite = FALSE)
  ui_done(sprintf("%s.qmd written to pages/", filename))

  dest <- normalizePath(dest, mustWork = TRUE)

  if (interactive()) usethis::edit_file(dest)
  invisible(dest)
}
