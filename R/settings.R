#' Manage froggeR settings
#'
#' Check, display, or initialize froggeR settings for Quarto documents. Settings are
#' stored in \code{~/.config/froggeR/config.yml} for persistence throughout 
#' \code{froggeR} projects.
#'
#' When run interactively, provides a menu to:\cr
#' * Check current settings\cr
#' * Initialize settings (first-time setup)\cr
#' * Modify existing settings\cr
#' * Save and exit\cr
#' * Exit without saving
#'
#' When settings are created, they are:\cr
#' * Stored in \code{~/.config/froggeR/config.yml} for persistence across sessions\cr
#' * Used to populate Quarto document variables
#'
#' The following is added to your \code{config.yml} when settings are saved:
#'
#' \preformatted{
#'   name: Your Name
#'   email: your.email@example.com
#'   orcid: 0000-0000-0000-0000
#'   url: https://github.com/yourUsername
#'   affiliations: Your Institution
#'   toc: Table of Contents
#' }
#'
#' @param interactive If TRUE (default), provides menu-driven interface.
#' @param verbose If TRUE (default), display messages. Applies to both interactive and
#'  non-interactive modes.
#' @param update_project If TRUE, updates the _variables.yml file in the current project
#'  directory (if it exists).
#' @return Invisibly returns the current settings list
#'
#' @export
#' @examples
#' \dontrun{
#'   # Interactive mode (default)
#'   froggeR_settings()
#' }
#' 
#' \donttest{
#'   # Non-interactive mode, display current settings
#'   settings <- froggeR_settings(interactive = FALSE, verbose = TRUE)
#'   print(settings)
#' }
#' 
#' \dontrun{
#'   # Update project's _variables.yml file
#'   froggeR_settings(update_project = TRUE)
#' }
froggeR_settings <- function(interactive = TRUE, verbose = TRUE, update_project = FALSE) {

  # Set configuration path and filename
  config_path <- rappdirs::user_config_dir('froggeR')
  config_file <- file.path(config_path, 'config.yml')

  # Read existing settings or create default
  if (file.exists(config_file)) {
    settings <- yaml::read_yaml(config_file)
  } else {
    settings <- list(
      name = '',
      email = '',
      orcid = '',
      url = '',
      affiliations = '',
      toc = ''
    )
  }

  setting_names <- list(
    'Name', 'e-mail', 'ORCID', 'URL', 'Affiliation', 'Table of Contents'
  )
  
  if (interactive && interactive()) {
    repeat {
      if (all(sapply(settings, function(x) x == ''))) {
        message(sprintf(
          '\nNo %s settings found. Would you like to configure them now?', 
          cli::col_green('froggeR')
        ))
        if (tolower(readline('Enter "y" for "yes": ')) == 'y') {
          message('Leave blank for default.')
          for (i in seq_along(settings)) {
            settings[[i]] <- readline(sprintf('Enter value for %s: ', setting_names[[i]]))
          }
        }
      } else {
        message(sprintf('\nCurrent %s settings:', cli::col_green('froggeR')))
        for (i in seq_along(settings)) {
          displayed_value <- if(names(settings)[i] == 'toc' && settings[[i]] == '') {
            'Table of Contents'
          } else {
            settings[[i]]
          }
          # Display output with padding for longest entry name
          message(sprintf(
            '%d. %-*s %s', i, 19, paste0(setting_names[i], ':'), displayed_value
          ))
        }
      }
  
      message(sprintf('\n%s settings menu:', cli::col_green('froggeR')))
      message('Select an item [1-6] to modify:')
      message('7. Modify all settings')
      message('8. Save and exit')
      message('9. Exit without saving')
  
      choice <- as.integer(readline('Enter your selection: '))
  
      if (choice >= 1 && choice <= 6) {
        message('Leave blank for default.')
        new_value <- 
          readline(sprintf('Enter new value for %s: ', names(settings)[choice]))
        if (new_value != '') settings[[choice]] <- new_value

      } else if (choice == 7) {
        message('Leave blank for default.')
        for (i in seq_along(settings)) {
          new_value <- readline(sprintf('Enter new value for %s: ', setting_names[i]))
          if (new_value != '') settings[[i]] <- new_value
        }

      } else if (choice == 8) {
        # Handle when 'toc' is left blank
        if (settings$toc == '') settings$toc <- 'Table of Contents'
  
        dir.create(config_path, showWarnings = FALSE, recursive = TRUE)
        yaml::write_yaml(settings, config_file)
        ui_done(sprintf('Settings saved to %s', config_file))

        if (update_project | ui_yeah('Update _variables.yml in current project?')) {
          variables_file <- file.path(getwd(), '_variables.yml')
          if (file.exists(variables_file)) {
            file.copy(from = config_file, to = variables_file, overwrite = TRUE)
            ui_done('Updated _variables.yml in the current project')
          } else {
            ui_oops('No _variables.yml found in the current project')
          }
        }
        break

      } else if (choice == 9) {
        ui_oops('Exiting without saving.')
        break

      # Exceptions  
      } else if (is.na(choice)) {
        return(NULL)
      } else {
        ui_oops('Invalid choice. Please try again.')
      }
    }

  } else if (verbose) {
    # End interactive mode
    if (all(sapply(settings, function(x) x == ''))) {
      message(sprintf('No %s settings found.', cli::col_green('froggeR')))
    } else {
      message(sprintf('Current %s settings:', cli::col_green('froggeR')))
      for (i in seq_along(settings)) {
        displayed_value <- if (names(settings)[i] == 'toc' && settings[[i]] == '') {
          'Table of Contents'
        } else {
          settings[[i]]
        }
        message(sprintf(
          '%d. %-*s %s', i, 19, paste0(setting_names[i], ':'), displayed_value
        ))
      }
    }
  }

  # Handle default 'toc' value before returning
  if (settings$toc == '') settings$toc <- 'Table of Contents'

  invisible(settings)

}


# Internal function to write variables.yml
.write_variables <- function(path, settings) {

  config_path <- rappdirs::user_config_dir('froggeR')
  config_file <- file.path(config_path, 'config.yml')
  variables_file <- file.path(path, '_variables.yml')

  if (!file.exists(config_file)) {
    ui_oops(sprintf(
      'Config file not found. Run %s first.', cli::col_green('froggeR_settings()')
    ))
  }

  if (file.copy(from = config_file, to = variables_file, overwrite = TRUE)) {
    ui_done('Created _variables.yml')
  } else {
    ui_oops('Failed to create _variables.yml')
  }

}
