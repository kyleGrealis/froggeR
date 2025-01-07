#' Write Variables YAML for Quarto Projects
#'
#' This function creates or updates the `_variables.yml` file in a Quarto project
#' directory using froggeR settings.
#'
#' @param path Character string. Path to the Quarto project directory where the
#'   `_variables.yml` file should be created or updated. Defaults to `here::here()`.
#' @param settings A named list of settings to populate the `_variables.yml` file.
#'   Defaults to the current froggeR settings if not provided.
#'
#' @return Invisibly returns `NULL` after creating or updating the `_variables.yml` file.
#' @details
#' If no settings are provided, the function will attempt to use the current froggeR
#' settings. If settings are missing or incomplete, the resulting `_variables.yml`
#' may require manual updates before the Quarto project can knit properly.
#'
#' @examples
#' \donttest{
#' # Create or update _variables.yml using default froggeR settings
#' write_variables(path = tempdir())
#' }
#' @export
write_variables <- function(path = here::here(), settings = NULL) {
  # Validate path
  if (is.null(path) || !dir.exists(path)) {
    stop("Invalid `path`. Please provide a valid directory.")
  }

  # Load current settings if none are provided
  if (is.null(settings)) {
    settings <- froggeR_settings(update = FALSE, verbose = FALSE)
  }

  if (is.null(settings)) {
    stop("No settings available. Run `froggeR_settings()` to create them.")
  }

  # Write the YAML file
  variables_file <- file.path(path, "_variables.yml")
  yaml::write_yaml(settings, variables_file)
  ui_done(sprintf(
    "Created _variables.yml with current %s settings.", col_green('froggeR')
  ))

  invisible(NULL)
}
