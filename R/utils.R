# Helpers: ---------------------------------------------------

#' Validate and Normalize Project Path
#'
#' Internal helper to validate that a path exists and normalize it for consistency.
#' Used across all write_* and save_* functions.
#'
#' @param path Character. Path to validate. Must be an existing directory.
#'
#' @return Character. Normalized absolute path.
#'
#' @details
#' Raises an error if path is \code{NULL}, \code{NA}, or does not exist as a directory.
#'
#' @noRd
.validate_and_normalize_path <- function(path) {
  if (is.null(path) || is.na(path) || !dir.exists(path)) {
    rlang::abort(
      "Invalid path. Please enter a valid project directory.",
      class = "froggeR_invalid_path"
    )
  }

  normalizePath(path, mustWork = TRUE)
}


#' Fetch a Template File from the frogger-templates Repository
#'
#' Downloads a single file from the GitHub template repo.
#'
#' @param repo_path Character. Path within the template repo
#'   (e.g. \code{"www/custom.scss"}, \code{"_brand.yml"}).
#'
#' @return Character. Path to the downloaded template file (a tempfile).
#'
#' @noRd
.fetch_template <- function(repo_path) {
  url <- sprintf(
    "https://raw.githubusercontent.com/kyleGrealis/frogger-templates/main/%s",
    repo_path
  )

  tmp <- tempfile(fileext = paste0(".", tools::file_ext(repo_path)))

  dl_result <- tryCatch(
    utils::download.file(url, tmp, mode = "wb", quiet = TRUE),
    error = function(e) e
  )

  if (!inherits(dl_result, "error") && file.exists(tmp) && file.size(tmp) > 0L) {
    return(tmp)
  }

  rlang::abort(
    c(
      sprintf("Failed to fetch template: %s", repo_path),
      "i" = "Check your internet connection or try again later."
    ),
    class = "froggeR_download_error"
  )
}


#' Open an Existing File or Create from Template
#'
#' Shared helper for single-file \code{write_*} functions. If the destination
#' file exists, returns its path (caller opens it). Otherwise, creates the
#' parent directory if needed, copies from a global config file or fetches the
#' template from the remote repo, and returns the new file path.
#'
#' @param dest_file Character. Full path to the destination file.
#' @param template_repo_path Character. Path within the template repo
#'   (e.g. \code{"_brand.yml"}, \code{"www/custom.scss"}).
#' @param label Character. Display name for UI messages (e.g. \code{"_brand.yml"}).
#' @param global_config_file Character or \code{NULL}. Path to a global config
#'   file that takes precedence over the template. Default is \code{NULL}.
#'
#' @return Character. Path to the destination file.
#' @noRd
.open_or_create <- function(dest_file, template_repo_path, label,
                            global_config_file = NULL) {
  if (file.exists(dest_file)) {
    ui_info(sprintf("%s already exists. Opening for editing.", label))
  } else {
    # Ensure parent directory exists
    dest_dir <- dirname(dest_file)
    if (!dir.exists(dest_dir)) fs::dir_create(dest_dir)

    # Use global config if available, otherwise fetch from template repo
    if (!is.null(global_config_file) && file.exists(global_config_file)) {
      ui_info(sprintf("Copying existing %s settings...", col_green("froggeR")))
      file.copy(from = global_config_file, to = dest_file, overwrite = FALSE)
    } else {
      template <- .fetch_template(template_repo_path)
      file.copy(from = template, to = dest_file, overwrite = FALSE)
    }
    ui_done(sprintf("Created %s", label))
  }

  dest_file
}

