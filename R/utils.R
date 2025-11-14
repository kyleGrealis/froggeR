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
      'Invalid path. Please enter a valid project directory.',
      class = 'froggeR_invalid_path'
    )
  }

  normalizePath(path, mustWork = TRUE)
}

#' Ensure Auxiliary Files Exist
#'
#' Internal helper that creates \code{_quarto.yml} and \code{custom.scss} if missing.
#' Used when creating example Quarto documents.
#'
#' @param path Character. Path to project directory.
#'
#' @return Invisibly returns \code{NULL}. Called for side effects.
#' @noRd
.ensure_auxiliary_files <- function(path) {
  # Validate the path
  if (!dir.exists(path)) {
    rlang::abort('Invalid path. The specified directory does not exist.', class = 'froggeR_invalid_path')
  }

  # Define paths for auxiliary files
  quarto_yml_path <- file.path(path, '_quarto.yml')
  scss_path <- file.path(path, 'custom.scss')

  # Handle _quarto.yml
  if (!file.exists(quarto_yml_path)) {
    writeLines('project:\n  title: "Quarto Project"', quarto_yml_path)
    ui_done('Created _quarto.yml')
  }

  # Handle custom.scss
  if (!file.exists(scss_path)) {
    create_scss(path = path)
  }
}

#' Handle Migration of Global Config File Name
#'
#' Checks for the old \code{config.yml} and renames it to \code{_variables.yml}
#' to align with new package convention. This is a one-time operation.
#'
#' @param config_path Character. Path to the froggeR config directory.
#'
#' @return Character. Path to the correct global variables file.
#'
#' @details
#' This function handles backward compatibility for users who have the old
#' \code{config.yml} naming convention. It attempts to rename the file once
#' and warns if unable to do so.
#'
#' @noRd
.handle_global_variables_migration <- function(config_path) {
  old_config_file <- file.path(config_path, 'config.yml')
  new_config_file <- file.path(config_path, '_variables.yml')

  if (!file.exists(new_config_file) && file.exists(old_config_file)) {
    tryCatch(
      {
        file.rename(from = old_config_file, to = new_config_file)
        ui_info(
          c(
            "Global config file has been renamed from 'config.yml' to '_variables.yml' for consistency.",
            'i' = 'This is a one-time migration.'
          )
        )
      },
      error = function(e) {
        # In case of permission errors, etc., warn the user but don't fail.
        # The package will proceed as if no config exists, which is safe.
        ui_warn(
          c(
            "Could not automatically rename global 'config.yml' to '_variables.yml'.",
            'x' = 'Please rename it manually in: {config_path}'
          )
        )
        # Return the old file path so the app can proceed for this session
        return(old_config_file)
      }
    )
  }

  return(new_config_file)
}
