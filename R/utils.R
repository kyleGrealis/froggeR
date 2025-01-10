# Helpers: ---------------------------------------------------

#' Console output function
#' 
#' Internal helper to provide info about project-level settings
#' @noRd
.yes_settings <- function() {
  ui_done('Project-level settings file (`_variables.yml`) found.')
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
#' Internal helper to provide info about project-level settings
#' @noRd
.global_settings <- function(config_file) {
  ui_done(sprintf('Global %s settings found at: %s', col_green('froggeR'), config_file))
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
    .global_settings(config_file)
    ui_done('You are currently using project- and global-level settings.')

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
  }
}

#' Check for ability to display project-level configuration file
#' 
#' Internal helper to display contents of project settings file.
#' @param config_file Path to global config file
#' @param project_settings Logical indicating if project settings exist
#' @param froggeR_settings Logical indicating if global settings exist
#' @noRd
.display <- function(config_file, project_settings, froggeR_settings) {
  if (project_settings) {
    message('\nYour `_variables.yml` contents:\n')
    cat(readLines(here::here('_variables.yml')), sep = '\n')
  } else if (froggeR_settings) {
    .no_settings()
    ui_info(sprintf(
      'However, a %s config file was found at: %s', col_green('froggeR'), config_file
    ))
    cat(readLines(config_file), sep = '\n')
  } else {
    ui_oops('No project-level or global settings file found.')
    .how_to()
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
    .global_settings(config_file)
    ui_info('You are currently using project- and global-level settings.')
    ui_info('Run `froggeR::write_variables()` to reuse project-level settings.')

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

#' Write .Rproj File
#'
#' Helper function to create or overwrite an RStudio project file (.Rproj).
#' Ensures consistent settings across froggeR projects.
#'
#' @inheritParams write_ignore
#' @param name Character string. Name of the .Rproj file.
#' @return Invisibly returns NULL after creating the .Rproj file.
#' @noRd
.write_rproj <- function(name = here::here(), path) {
  # Validate path
  if (is.null(path) || is.na(path) || !dir.exists(path)) {
    stop("Invalid `path`. Please enter a valid project directory.")
  }

  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)

  # Define the target file path
  the_rproj_file <- file.path(path, paste0(name, ".Rproj"))

  # Check for existing .Rproj
  if (file.exists(the_rproj_file)) {
    stop('.Rproj found in project directory!')
  }

  # Define .Rproj content
  content <- "Version: 1.0\nRestoreWorkspace: Default\nSaveWorkspace: Default\nAlwaysSaveHistory: Default\nEnableCodeIndexing: Yes\nUseSpacesForTab: Yes\nNumSpacesForTab: 2\nEncoding: UTF-8\nRnwWeave: Sweave\nLaTeX: pdfLaTeX\nAutoAppendNewline: Yes\nStripTrailingWhitespace: Yes\n"

  # Write .Rproj file
  writeLines(content, the_rproj_file)
  ui_done(paste0("Created ", name, ".Rproj"))

  return(invisible(NULL))
}

#' Helper for creating custom.scss & _quarto.yml
#' 
#' @inheritParams write_ignore
#' @return SCSS file, Quarto project YAML file, or both
#' @noRd
.ensure_auxiliary_files <- function(path, .initialize_proj) {
  # Validate the path
  if (!dir.exists(path)) {
    stop("Invalid path. The specified directory does not exist.")
  }

  # Define paths for auxiliary files
  quarto_yml_path <- file.path(path, '_quarto.yml')
  scss_path <- file.path(path, 'custom.scss')

  # Handle _quarto.yml
  if (!file.exists(quarto_yml_path)) {
    writeLines("project:\n  title: \"Quarto Project\"", quarto_yml_path)
    ui_done("Created _quarto.yml")
  }

  # Handle custom.scss
  if (!file.exists(scss_path)) {
    write_scss(path = path, .initialize_proj = .initialize_proj)
  }
}
