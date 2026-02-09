#' Create a Custom Quarto Project
#'
#' @description
#' \strong{Deprecated.} Use \code{\link{init}()} instead.
#'
#' @param name Character. Ignored.
#' @param path Character. Ignored.
#' @param example Logical. Ignored.
#'
#' @return Does not return. Always errors with a deprecation message.
#'
#' @seealso \code{\link{init}}
#'
#' @examples
#' \dontrun{
#' # Use init() instead
#' init(path = "my-project")
#' }
#'
#' @export
quarto_project <- function(name, path = here::here(), example = TRUE) {
  rlang::abort(
    c(
      "quarto_project() has been removed.",
      "i" = "Use init() instead. It creates the project directory for you.",
      "i" = 'Example: init(path = "my-project")'
    ),
    class = "froggeR_deprecated"
  )
}
