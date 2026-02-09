#' Write Brand YAML for Quarto Projects
#'
#' Creates or opens a \code{_brand.yml} file in a Quarto project for editing.
#' If the file already exists, it is opened directly. If global froggeR brand
#' settings exist, those are used as the starting point. Otherwise, the template
#' is downloaded from the
#' \href{https://github.com/kyleGrealis/frogger-templates}{frogger-templates}
#' repository.
#'
#' @param path Character. Path to the project directory. Default is current project
#'   root via \code{\link[here]{here}}.
#' @param restore_logos Logical. Restore logo content from system configuration.
#'   Default is \code{TRUE}.
#'
#' @return Invisibly returns the path to the file.
#'
#' @details
#' The \code{_brand.yml} file defines your visual identity for Quarto documents:
#' colors, logos, typography, and more. See the
#' \href{https://posit-dev.github.io/brand-yml/}{brand.yml specification} for
#' the full list of available options.
#'
#' Use \code{\link{save_brand}} to persist your project-level brand configuration
#' to the global config directory for reuse across projects.
#'
#' @examples
#' \dontrun{
#' write_brand()
#' }
#'
#' @seealso \code{\link{save_brand}}, \code{\link{write_variables}},
#'   \code{\link{init}}
#' @export
write_brand <- function(path = here::here(), restore_logos = TRUE) {

  path <- .validate_and_normalize_path(path)
  config_path <- rappdirs::user_config_dir("froggeR")

  complete_filename <- "_brand.yml"
  already_existed <- file.exists(file.path(path, complete_filename))

  dest <- .open_or_create(
    dest_file = file.path(path, complete_filename),
    template_repo_path = complete_filename,
    label = complete_filename,
    global_config_file = file.path(config_path, complete_filename)
  )

  # Logos restoration only on fresh creation
  if (restore_logos && !already_existed) {
    frogger_logos <- file.path(config_path, "logos")
    logos_dest <- file.path(path, "logos")
    if (dir.exists(logos_dest)) {
      ui_oops("Logos directory already exists in this project. Skipping.")
    } else if (!dir.exists(frogger_logos)) {
      ui_info("No config level 'logos' directory was found. Skipping.")
    } else {
      fs::dir_copy(frogger_logos, logos_dest)
      ui_done(sprintf("Copying existing %s logos.", col_green("froggeR")))
    }
  }
  
  dest <- normalizePath(dest, mustWork = TRUE)
  
  if (interactive()) usethis::edit_file(dest)
  
  ui_info(paste(
    "Brand reference:",
    "https://posit-dev.github.io/brand-yml/"
  ))

  invisible(dest)
}
