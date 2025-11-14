#' Save Metadata Configuration to Global froggeR Settings
#'
#' This function saves the current \code{_variables.yml} file from an existing froggeR
#' Quarto project to your global (system-wide) froggeR configuration. This allows
#' you to reuse metadata across multiple projects.
#'
#' @return Invisibly returns \code{NULL} after saving configuration file.
#'
#' @details
#' This function:
#' \itemize{
#'   \item Reads the project-level \code{_variables.yml} file
#'   \item Saves it to your system-wide froggeR config directory
#'   \item Prompts for confirmation if a global configuration already exists
#' }
#'
#' The saved configuration is stored in \code{rappdirs::user_config_dir('froggeR')}
#' and will automatically be used in new froggeR projects created with
#' \code{\link{quarto_project}} or \code{\link{write_variables}}.
#'
#' This is useful for maintaining consistent author metadata (name, email, affiliations, etc.)
#' across all your projects without having to re-enter it each time.
#'
#' @examples
#' # Save metadata from current project to global config
#' if (interactive()) save_variables()
#'
#' @seealso \code{\link{settings}}, \code{\link{write_variables}},
#'   \code{\link{save_brand}}
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
  config_path <- rappdirs::user_config_dir('froggeR')
  config_file <- .handle_global_variables_migration(config_path)
  # Does it exist?
  system_settings <- file.exists(config_file)
  # Overwrite_prompt
  overwrite_prompt <- sprintf(
    'A system-level %s configuration was found. Overwrite??',
    col_green('froggeR')
  )

  # Save the config file or prompt the user to overwrite
  if (system_settings) {
    if (ui_yeah(overwrite_prompt)) {
      file.copy(from = the_variables_file, to = config_file, overwrite = TRUE)
    } else {
      ui_oops('No changes were made.')
    }
  } else {
    file.copy(from = the_variables_file, to = config_file, overwrite = FALSE)
  }

  ui_info(sprintf('Copying project %s settings...', col_green('froggeR')))
  ui_done(sprintf(
    'Saved _variables.yml to system configuration: \n%s',
    config_file
  ))

  return(invisible(NULL))
}
