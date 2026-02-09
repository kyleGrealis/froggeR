#' Initialize a froggeR Project from the Template
#'
#' Downloads the latest project scaffold from the
#' \href{https://github.com/kyleGrealis/frogger-templates}{frogger-templates}
#' repository and restores any saved user configuration. This is the
#' recommended way to start a new froggeR project.
#'
#' @param path Character. Directory where the project will be created. If the
#'   directory does not exist, it will be created. Default is current project
#'   root via \code{\link[here]{here}}.
#'
#' @return Invisibly returns the normalized \code{path}.
#'
#' @details
#' The function performs these steps:
#' \enumerate{
#'   \item Creates the target directory if it does not exist
#'   \item Downloads the latest template zip from GitHub
#'   \item Copies only files that do not already exist (never overwrites)
#'   \item Restores saved user config (\code{_variables.yml}, \code{_brand.yml},
#'     \code{logos/}) from \code{~/.config/froggeR/} if present
#'   \item Creates a \code{data/} directory (gitignored by default)
#' }
#'
#' Existing files are never overwritten. Each created and skipped file is
#' reported individually so you can see exactly what changed.
#'
#' Global configuration is saved via \code{\link{save_variables}} and
#' \code{\link{save_brand}}. If no saved config exists, the template defaults
#' are used as-is.
#'
#' @examples
#' \dontrun{
#' # Create a new project (directory is created automatically)
#' init(path = file.path(tempdir(), "my-project"))
#' }
#'
#' @seealso \code{\link{write_variables}}, \code{\link{write_brand}},
#'   \code{\link{save_variables}}, \code{\link{save_brand}}
#' @export
init <- function(path = here::here()) {
  # Create the target directory if it doesn't exist
  if (!is.null(path) && !is.na(path) && !dir.exists(path)) {
    tryCatch(
      fs::dir_create(path),
      error = function(e) NULL
    )
  }

  # Validate and normalize
  path <- .validate_and_normalize_path(path)

  # Snapshot pre-existing files (these will never be overwritten)
  pre_existing <- list.files(
    path, all.files = TRUE, recursive = TRUE, no.. = TRUE
  )

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
  extracted_dirs <- list.dirs(
    extract_dir, full.names = TRUE, recursive = FALSE
  )
  if (length(extracted_dirs) == 0L) {
    rlang::abort(
      "Template archive was empty or could not be extracted.",
      class = "froggeR_download_error"
    )
  }
  template_root <- extracted_dirs[[1L]]

  # Copy template contents into target path (additive only, never overwrite)

  # Create template directories first (may be empty in template)
  template_dirs <- list.dirs(
    template_root, full.names = FALSE, recursive = TRUE
  )
  template_dirs <- template_dirs[template_dirs != ""]
  for (rel_dir in template_dirs) {
    dst_dir <- file.path(path, rel_dir)
    if (!dir.exists(dst_dir)) fs::dir_create(dst_dir)
  }

  # Copy individual files
  template_files <- list.files(
    template_root, all.files = TRUE, recursive = TRUE, no.. = TRUE
  )

  created <- character(0)
  skipped <- character(0)

  for (rel_path in template_files) {
    src <- file.path(template_root, rel_path)
    dst <- file.path(path, rel_path)

    if (file.exists(dst)) {
      skipped <- c(skipped, rel_path)
      next
    }

    # Ensure parent directory exists
    dst_dir <- dirname(dst)
    if (!dir.exists(dst_dir)) fs::dir_create(dst_dir)

    file.copy(src, dst)
    created <- c(created, rel_path)
  }

  # Report created files
  for (f in sort(created)) {
    ui_done(sprintf("Created %s", f))
  }

  # Report skipped files
  for (f in sort(skipped)) {
    ui_info(sprintf("Skipped %s (already exists)", f))
  }

  # Restore saved user config (respects pre-existing files)
  config_path <- rappdirs::user_config_dir("froggeR")
  .restore_saved_config(path, config_path, protected = pre_existing)

  # Create data/ directory (gitignored, not in template)
  if (!dir.exists(file.path(path, "data"))) {
    fs::dir_create(file.path(path, "data"))
    ui_done("Created data/")
  }

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
#' from the froggeR config directory into the project if they exist. Files that
#' existed before \code{init()} was called are never overwritten.
#'
#' @param path Character. Target project directory.
#' @param config_path Character. Path to the froggeR global config directory.
#' @param protected Character vector. Relative file paths that existed before
#'   \code{init()} and should not be overwritten. Default is empty.
#'
#' @return Invisibly returns \code{NULL}. Called for side effects.
#' @noRd
.restore_saved_config <- function(path, config_path, protected = character(0)) {
  if (!dir.exists(config_path)) {
    return(invisible(NULL))
  }

  # _variables.yml (global config overwrites template version, not pre-existing)
  global_vars <- file.path(config_path, "_variables.yml")
  if (file.exists(global_vars) && !("_variables.yml" %in% protected)) {
    file.copy(global_vars, file.path(path, "_variables.yml"), overwrite = TRUE)
    ui_info("Restored _variables.yml from saved config.")
  }

  # _brand.yml (overwrite template version, not pre-existing)
  global_brand <- file.path(config_path, "_brand.yml")
  if (file.exists(global_brand) && !("_brand.yml" %in% protected)) {
    file.copy(global_brand, file.path(path, "_brand.yml"), overwrite = TRUE)
    ui_info("Restored _brand.yml from saved config.")
  }

  # logos/ (supplement, skip pre-existing logos)
  global_logos <- file.path(config_path, "logos")
  if (dir.exists(global_logos)) {
    dest_logos <- file.path(path, "logos")
    if (!dir.exists(dest_logos)) {
      fs::dir_copy(global_logos, dest_logos)
      logo_files <- list.files(global_logos)
      for (logo in logo_files) {
        ui_info(sprintf("Restored %s from saved config.", file.path("logos", logo)))
      }
    } else {
      logo_files <- list.files(global_logos, full.names = TRUE)
      for (logo in logo_files) {
        logo_name <- basename(logo)
        rel_path <- file.path("logos", logo_name)
        if (!(rel_path %in% protected)) {
          file.copy(logo, file.path(dest_logos, logo_name), overwrite = FALSE)
          ui_info(sprintf("Restored %s from saved config.", rel_path))
        }
      }
    }
  }

  invisible(NULL)
}
