#' Initialize a froggeR Project from the Template
#'
#' Downloads the latest project scaffold from the
#' \href{https://github.com/kyleGrealis/frogger-templates}{frogger-templates}
#' repository and restores any saved user configuration. This is the
#' recommended way to start a new froggeR project.
#'
#' @param path Character. Directory where the project will be created. Must
#'   already exist. Default is current project root via \code{\link[here]{here}}.
#'
#' @return Invisibly returns the normalized \code{path}.
#'
#' @details
#' The function performs these steps:
#' \enumerate{
#'   \item Downloads the latest template zip from GitHub
#'   \item Unpacks the scaffold into \code{path}
#'   \item Restores saved user config (\code{_variables.yml}, \code{_brand.yml},
#'     \code{logos/}) from \code{~/.config/froggeR/} if present
#'   \item Creates a \code{data/} directory (gitignored by default)
#' }
#'
#' Global configuration is saved via \code{\link{save_variables}} and
#' \code{\link{save_brand}}. If no saved config exists, the template defaults
#' are used as-is.
#'
#' @examples
#' \dontrun{
#' # Initialize in an existing empty directory
#' dir.create(file.path(tempdir(), "my-project"))
#' init(path = file.path(tempdir(), "my-project"))
#' }
#'
#' @seealso \code{\link{write_variables}}, \code{\link{write_brand}},
#'   \code{\link{save_variables}}, \code{\link{save_brand}}
#' @export
init <- function(path = here::here()) {
  # Validate and normalize
  path <- .validate_and_normalize_path(path)

  # Download template
  template_url <- "https://github.com/kyleGrealis/frogger-templates/archive/refs/heads/main.zip"
  zip_file <- tempfile(fileext = ".zip")
  on.exit(unlink(zip_file, force = TRUE), add = TRUE)

  ui_info("Downloading template...")

  dl_result <- tryCatch(
    utils::download.file(template_url, zip_file, mode = "wb", quiet = TRUE),
    error = function(e) e
  )

  if (inherits(dl_result, "error") ||
      !file.exists(zip_file) ||
      file.size(zip_file) == 0L) {
    msg <- "Failed to download the froggeR template from GitHub."
    hint <- "Check your internet connection or try again later."
    if (inherits(dl_result, "error")) {
      rlang::abort(
        c(msg, "i" = hint, "x" = conditionMessage(dl_result)),
        class = "froggeR_download_error"
      )
    }
    rlang::abort(
      c(msg, "i" = hint),
      class = "froggeR_download_error"
    )
  }

  # Unzip to temp directory
  extract_dir <- tempfile("froggeR_template_")
  on.exit(unlink(extract_dir, recursive = TRUE, force = TRUE), add = TRUE)

  utils::unzip(zip_file, exdir = extract_dir)

  # GitHub archives unzip into a top-level folder named {repo}-{branch}
  extracted_dirs <- list.dirs(extract_dir, full.names = TRUE, recursive = FALSE)
  if (length(extracted_dirs) == 0L) {
    rlang::abort(
      "Template archive was empty or could not be extracted.",
      class = "froggeR_download_error"
    )
  }
  template_root <- extracted_dirs[[1L]]

  # Copy template contents into target path
  template_files <- list.files(template_root, all.files = TRUE, no.. = TRUE)
  for (file in template_files) {
    src <- file.path(template_root, file)
    dst <- file.path(path, file)
    if (file.info(src)$isdir) {
      fs::dir_copy(src, dst, overwrite = TRUE)
    } else {
      file.copy(src, dst, overwrite = TRUE)
    }
  }

  # Restore saved user config
  config_path <- rappdirs::user_config_dir("froggeR")
  .restore_saved_config(path, config_path)

  # Create data/ directory (gitignored, not in template)
  fs::dir_create(file.path(path, "data"))

  ui_done(sprintf("%s project ready.", col_green("froggeR")))

  # Open project in IDE if available
  if (interactive() && rstudioapi::isAvailable()) {
    rstudioapi::openProject(path = path, newSession = TRUE)
  }

  invisible(path)
}


#' Restore Saved User Configuration into Project
#'
#' Copies global \code{_variables.yml}, \code{_brand.yml}, and \code{logos/}
#' from the froggeR config directory into the project if they exist.
#'
#' @param path Character. Target project directory.
#' @param config_path Character. Path to the froggeR global config directory.
#'
#' @return Invisibly returns \code{NULL}. Called for side effects.
#' @noRd
.restore_saved_config <- function(path, config_path) {
  if (!dir.exists(config_path)) {
    return(invisible(NULL))
  }

  # _variables.yml (global config overwrites template version)
  global_vars <- file.path(config_path, "_variables.yml")
  if (file.exists(global_vars)) {
    file.copy(global_vars, file.path(path, "_variables.yml"), overwrite = TRUE)
  }

  # _brand.yml (overwrite template version if user has a saved one)
  global_brand <- file.path(config_path, "_brand.yml")
  if (file.exists(global_brand)) {
    file.copy(global_brand, file.path(path, "_brand.yml"), overwrite = TRUE)
  }

  # logos/ (supplement template logos)
  global_logos <- file.path(config_path, "logos")
  if (dir.exists(global_logos)) {
    dest_logos <- file.path(path, "logos")
    if (!dir.exists(dest_logos)) {
      fs::dir_copy(global_logos, dest_logos)
    } else {
      # Copy individual files into existing logos dir
      logo_files <- list.files(global_logos, full.names = TRUE)
      file.copy(logo_files, dest_logos, overwrite = FALSE)
    }
  }

  invisible(NULL)
}
