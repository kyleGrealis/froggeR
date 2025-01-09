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
    .check(config_file, project_settings, froggeR_settings),
    .display(project_settings),
    .update(settings_file),
    .reuse(config_file, project_settings, froggeR_settings),
    .more_info()
  )

  return(invisible(NULL))
}

# Helpers: ---------------------------------------------------

#' Console output function
#' 
#' Internal helper to provide info about project-level settings
#' @noRd
.yes_settings <- function() {
  ui_done('Project-level settings file (`_variables.yml`) found in current directory.')
}

#' Console output function
#' 
#' Internal helper to provide info about project-level settings
#' @noRd
.no_settings <- function() {
  ui_oops('No project-level settings file (`_variables.yml`) found.')
}

#' Console output function
#' 
#' Internal helper to provide info about creating project-level settings
#' @noRd
.how_to <- function() {
  ui_info('Run `froggeR::write_variables()` to create project-level settings.')
}


#' Check for existence of configuration files
#' 
#' Internal helper to verify presence of project and global settings files.
#' @param config_file Path to global config file
#' @param project_settings Logical indicating if project settings exist
#' @param froggeR_settings Logical indicating if global settings exist
#' @noRd
.check <- function(config_file, project_settings, froggeR_settings) {

  if (project_settings && froggeR_settings) {
    # Has both project and froggeR settings
    .yes_settings()
    ui_done(sprintf('Global %s settings found at: %s', col_green('froggeR'), config_file))
    ui_info('You are currently using project- and global-level settings.')

  } else if (project_settings && !froggeR_settings) {
    # Has only project settings
    .yes_settings()
    ui_oops(sprintf('No global %s config file found', col_green('froggeR')))

  } else if (froggeR_settings && !project_settings) {
    # Has only froggeR settings
    .no_settings()
    ui_info(sprintf(
      'However, a %s config file was found at: %s', col_green('froggeR'), config_file
    ))

  } else {
    ui_oops('No project-level or global settings file found.')
    .how_to()
  }
}

#' Check for ability to display project-level configuration file
#' 
#' Internal helper to display contents of project settings file.
#' @param project_settings Logical indicating if project settings exist
#' @noRd
.display <- function(project_settings) {
  if (project_settings) {
    message('\nYour `_variables.yml` contents:\n')
    cat(readLines(here::here('_variables.yml')), sep = '\n')
  } else {
    .no_settings()
  }
}

#' Check for ability to update project-level configuration file
#' 
#' Internal helper to update project settings file.
#' @param settings_file Path of project settings file (`_variables.yml`)
#' @noRd
.update <- function(settings_file) {
  if (file.exists(settings_file)) {
    .yes_settings()
    ui_info('Open the `_variables.yml` file to update project-level settings.')
  } else {
    .no_settings()
    .how_to()
  }
}

#' Check for ability to reuse configuration files
#' 
#' Internal helper to verify reusability of project and global settings files.
#' @param config_file Path to global config file
#' @param project_settings Logical indicating if project settings exist
#' @param froggeR_settings Logical indicating if global settings exist
#' @noRd
.reuse <- function(config_file, project_settings, froggeR_settings) {

  if (project_settings && froggeR_settings) {
    # Has both project and froggeR settings
    .yes_settings()
    ui_done(sprintf('Global %s settings found at: %s', col_green('froggeR'), config_file))
    ui_info('You are currently using project- and global-level settings.')

  } else if (project_settings && !froggeR_settings) {
    # Has only project settings
    .yes_settings()
    ui_info(
      sprintf(
        'To reuse your current project-level settings (`_variables.yml`) for your next %s Quarto project, save the settings file to a special configurations folder. You can do that now by copying and pasting to the console:\n\nfile.copy(from = here::here("_variables.yml"), to = "%s")',
        col_green('froggeR'),
        config_file
      )
    )
    message(
      sprintf(      
        '\n\nYour personalized configurations will automatically be used during your next %s Quarto project.',
        col_green('froggeR')
      )
    )

  } else if (froggeR_settings && !project_settings) {
    # Has only froggeR settings
    ui_info(
      sprintf(
        'To reuse your global %s YAML settings (name, email, etc.) in your current project path (%s), copy and paste this into your console:\n\nfile.copy(from = "%s", to = here::here("_variables.yml"))',
        col_green('froggeR'), here::here(), config_file
      )
    )

  } else {
    # Neither settings found
    ui_info(
      sprintf(
        'First, run `froggeR::write_variables() to create project-level settings. Then, to reuse them in your next %s Quarto project, save the settings file to a special configurations folder. You can do that by copying and pasting to the console:\n\nfile.copy(from = here::here("_variables.yml")), to = "%s")',
        col_green('froggeR'),
        config_file
      )
    )
    message(
      sprintf(      
        '\nFinally, your personalized configurations will automatically be used during your next %s Quarto project.',
        col_green('froggeR')
      )
    )
  }
}

#' Console output function
#' 
#' Internal helper to provide info about using `froggeR` settings
#' @noRd
.more_info <- function() {
  ui_info('Run `vignette(package = "froggeR")` to find out how to effectively use settings across multiple projects.')
}
