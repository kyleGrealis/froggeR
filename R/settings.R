#' Manage 'froggeR' Settings
#'
#' This function provides useful instructions and information regarding `froggeR`
#'  settings. 
#' 
#' @details This function can only run in an interactive environment. Choose to:
#' - Check for the existence of project- and global-level configuration files 
#' - Display current project-level settings
#' - Feedback for updating settings
#' - Instructions how to reuse settings across multiple `froggeR` Quarto projects.
#'
#' @return No return value; called for side-effects.
#'
#' @examples
#' # Only run in an interactive environment
#' if (interactive()) froggeR::settings()
#' 
#' @export
settings <- function() {

  if (!interactive()) { stop('Must be run in interactive session. Exiting...')}

  frog <- utils::menu(
    choices = c(
      'Check for config files', 
      'Display current settings', 
      'Show how to update settings',
      'Show how to reuse settings across projects',
      'More information about settings'
    ),
    title = sprintf('\n%s settings options:', col_green('froggeR'))
  )

  # Project-level settings
  settings_file <- file.path(here::here(), '_variables.yml')
  # Global froggeR settings
  config_path <- rappdirs::user_config_dir("froggeR")
  config_file <- file.path(config_path, "config.yml")

  # Do they exist?
  project_settings <- file.exists(settings_file)
  froggeR_settings <- file.exists(config_file)

  switch(
    frog,
    c(.check(config_file, project_settings, froggeR_settings), .how_to()),
    .display(config_file, project_settings, froggeR_settings),
    .update(settings_file),
    .reuse(config_file, project_settings, froggeR_settings),
    .more_info()
  )

  return(invisible(NULL))
}
