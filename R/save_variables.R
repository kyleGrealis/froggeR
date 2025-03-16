#' Save variables YAML for 'Quarto' Projects
#'
#' This function saves the current `_variables.yml` file from an existing froggeR
#' Quarto project. This provides a safety catch to prevent unintended overwrite if the 
#' system-level configuration file exists.
#'
#' @return Invisibly returns `NULL` after creating system-level configuration file.
#' @details
#' The function will attempt to create a system-level configuration file from the current
#' froggeR Quarto project. If the system-level configuration file already exists, the
#' user will be prompted prior to overwrite.
#'
#' @examples
#' 
#' # Write the _variables.yml file
#' if (interactive()) save_variables()
#' 
#' @export
save_variables <- function() {
  
  # Normalize the path for consistency
  path <- normalizePath(here::here(), mustWork = TRUE)
  
  # Set up full origin file path
  the_variables_file <- file.path(path, '_variables.yml')

  # Check for project-level _variables.yml
  if (!file.exists(the_variables_file)) {
    ui_oops(
      sprintf(
        'No current _variables.yml file exists in this project. Run %s to create it.',
        col_green('froggeR::write_variables()')
      )
    )
    return(invisible(NULL))
  }

  # Global froggeR settings
  config_path <- rappdirs::user_config_dir("froggeR")
  config_file <- file.path(config_path, "config.yml")
  # Does it exist?
  system_settings <- file.exists(config_file)
  # Overwrite_prompt
  overwrite_prompt <- sprintf(
    "A system-level %s configuration was found. Overwrite??", 
    col_green("froggeR")
  )


  ### TODO: fix this so it is logically sound! it doesn't make sense and work yet
  # Save the config file or prompt the user to overwrite
  if (system_settings) {
    ### TODO message & request overwrite
    if (ui_yeah(overwrite_prompt)) {
      file.copy(from = the_variables_file, to = config_file, overwrite = TRUE)
    } else {
      ui_oops('No changes were made.')
    }
  } else {
    file.copy(from = the_variables_file, to = config_file, overwrite = FALSE)
  }
  
  ui_info(sprintf('Copying project %s settings...', col_green('froggeR')))
  ui_done(sprintf("Saved _variables.yml to system configuration: \n%s", config_file))

  return(invisible(NULL))
}

