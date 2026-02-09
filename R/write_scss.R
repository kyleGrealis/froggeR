#' Create a Quarto SCSS File
#'
#' Creates or opens an SCSS file in the \code{www/} directory. If the file
#' already exists, it is opened directly. Otherwise, the template is
#' downloaded from the
#' \href{https://github.com/kyleGrealis/frogger-templates}{frogger-templates}
#' repository.
#'
#' @param filename Character. The name of the file without the \code{.scss}
#'   extension. A \code{www/} prefix and \code{.scss} extension are stripped
#'   automatically if provided, so \code{"custom2"} and
#'   \code{"www/custom2.scss"} are equivalent. Only letters, numbers, hyphens,
#'   and underscores are allowed. Default is \code{"custom"}.
#' @param path Character. Path to the project directory. Default is current
#'   working directory via \code{\link[here]{here}}.
#'
#' @return Invisibly returns the path to the file.
#'
#' @details
#' The file is written to \code{www/<filename>.scss}. The \code{www/}
#' directory is created automatically if it does not exist.
#'
#' @examples
#' \dontrun{
#' # Create the default custom.scss
#' write_scss()
#'
#' # Create a second SCSS file
#' write_scss("custom2")
#' # These are equivalent
#' write_scss("www/custom2.scss")
#' }
#'
#' @seealso \code{\link{init}}, \code{\link{write_quarto}}
#' @export
write_scss <- function(filename = "custom", path = here::here()) {

  path <- .validate_and_normalize_path(path)

  # Normalize filename: strip www/ prefix and .scss extension if provided
  filename <- sub("^www/", "", filename)
  filename <- sub("\\.scss$", "", filename)

  if (!is.character(filename) || !grepl("^[a-zA-Z0-9_-]+$", filename)) {
    rlang::abort(
      "Invalid filename. Use only letters, numbers, hyphens, and underscores."
    )
  }

  complete_filename <- sprintf("www/%s.scss", filename)

  dest <- .open_or_create(
    dest_file = file.path(path, complete_filename),
    template_repo_path = "www/custom.scss",
    label = complete_filename
  )

  dest <- normalizePath(dest, mustWork = TRUE)

  if (interactive()) usethis::edit_file(dest)

  invisible(dest)
}
