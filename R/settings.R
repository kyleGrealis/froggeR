#' Manage froggeR settings
#'
#' This function allows you to check, display, or initialize froggeR settings for 
#' Quarto documents. Settings are stored in \code{~/.config/froggeR/config.yml} 
#' for persistence across froggeR projects.
#'
#' @param update Logical. If TRUE (default), prompts to update existing settings
#'   or create new ones if none exist.
#' @param verbose Logical. If TRUE (default), settings output is printed to the console.
#'
#' @return Invisibly returns the current settings list.
#'
#' @details
#' The function manages the following settings:
#' \itemize{
#'   \item name: Your Name (required)
#'   \item email: your.email@example.com (required)
#'   \item orcid: 0000-0000-0000-0000 (optional)
#'   \item url: https://github.com/yourUsername (optional)
#'   \item affiliations: Your Institution (optional)
#'   \item toc: Table of Contents (defaults to this if left empty)
#' }
#' When run interactively with \code{update = TRUE}, it provides a menu-driven 
#'   interface for updating these settings. If settings don't exist, it will 
#'   prompt to create them regardless of the \code{update} parameter.
#'
#' @export
#' @examples
#' # Update settings interactively with console feedback
#' froggeR_settings(update = TRUE, verbose = TRUE)
#' 
#' # Save settings without updating and print console output
#' settings <- froggeR_settings(update = FALSE, verbose = TRUE)
#' 
#' # Save settings without updating and suppress console output
#' settings <- froggeR_settings(update = FALSE, verbose = FALSE)

froggeR_settings <- function(update = TRUE, verbose = TRUE) {

  # Argument validation
  if (!is.logical(update) || length(update) != 1) {
    stop('"update" must be a single logical value')
  }
  if (!is.logical(verbose) || length(verbose) != 1) {
    stop('"verbose" must be a single logical value')
  }

  settings <- .load_settings()

  if (is.null(settings) || update) {
    results <- .update_settings(settings)
    settings <- results$settings

    if (results$changed && verbose) {
      ui_done(sprintf('%s settings updated', col_green('froggeR')))
    }
    if (update && verbose) {
      answer <- tolower(readline('Update or create _variables.yml? [y/n] '))
      if (answer == 'y') .update_variables_yml(settings = settings, verbose = verbose)
    }
  } else if (verbose) {
    message(sprintf("\nCurrent %s settings:\n", col_green('froggeR')))
    display_names <- c(
      'Name', 'e-mail', 'ORCID', 'URL', 'Affiliation', 'Table of Contents'
    )
    max_name_length <- max(nchar(display_names))
    
    for (i in seq_along(settings)) {
      name <- display_names[i]
      value <- settings[[i]]
      padding <- paste(rep(" ", max_name_length - nchar(name)), collapse = "")
      message(sprintf("%s:%s %s", name, padding, value))
    }
    message('\n')
  }
  invisible(settings)
}


# Helper functions:-------------------

.load_settings <- function() {
  config_path <- rappdirs::user_config_dir('froggeR')
  config_file <- file.path(config_path, 'config.yml')

  if (file.exists(config_file)) {
    tryCatch({
      settings <- yaml::read_yaml(config_file)
      # The settings$toc may be loaded with an empty string. The default is to fill
      #   the settings$toc with "Table of Contents":
      if (!is.null(settings) && is.null(settings$toc) || settings$toc == "") {
        settings$toc <- 'Table of Contents'
      }
      return(settings)
    }, error = function(e) {
      warning('Error loading settings file. Using default settings.')
      return(NULL)
    })
  } else {
    return(NULL)
  }
}

# Update the settings, if interactive
.update_settings <- function(settings = NULL) {
  if (is.null(settings)) {
    settings <- list(
      name = '', email = '', orcid = '', url = '', affiliations = '',
      # Set as default
      toc = 'Table of Contents'
    )
  }
  original_settings <- settings

  message(sprintf("\nUpdating %s settings!", col_green('froggeR')))
  ui_info('Leave blank if you do not wish to change that entry.')

  # Clean names for display
  setting_names <- list('Name', 'e-mail', 'ORCID', 'URL', 'Affiliation')
  for (i in seq_along(setting_names)) {
    prompt <- if (settings[[i]] == ''){
      sprintf('Enter value for %s: ', setting_names[[i]])
    } else {
      sprintf('Enter new value for %s [%s]: ', setting_names[[i]], settings[[i]])
    }
    
    new_value <- if(interactive()) readline(prompt) else ''
    if (new_value != '') settings[[i]] <- new_value
  }

  # Handle when toc is left blank
  if (settings$toc == '') settings$toc <- 'Table of Contents'

  settings_were_changed <- !identical(original_settings, settings)
  .save_settings(settings)

  list(settings = settings, changed = settings_were_changed)
}


# Save the settings in a YAML format in the user's config path
.save_settings <- function(settings) {
  config_path <- rappdirs::user_config_dir('froggeR')
  config_file <- file.path(config_path, 'config.yml')

  dir.create(config_path, showWarnings = FALSE, recursive = TRUE)
  yaml::write_yaml(settings, config_file)
  invisible(settings)
}

.update_variables_yml <- function(settings, verbose = TRUE) {

  # Ensure here::here() resolves to a valid directory
  variables_file <- tryCatch({
    file.path(here::here(), '_variables.yml')
  }, error = function(e) {
    stop("Could not resolve project root with here::here(). Ensure you are in a valid project structure.")
  })
  
  file_existed <- file.exists(variables_file)
  yaml::write_yaml(settings, variables_file)

  if (verbose) {
    if (file_existed) {
      ui_done('Updated _variables.yml')
    } else {
      ui_done('Created _variables.yml')
    }
  }
}

.check_settings <- function(settings) {
  if (settings$name == '') {
    ui_info(sprintf(
      'The "name" field in your froggeR settings is empty. It\'s recommended to set this by running %s.', col_green('froggeR_settings()')
    ))
  } else if (any(sapply(
    settings[c('email', 'orcid', 'url', 'affiliations')], function(x) x == ''
  ))) {
    ui_info(sprintf(
      "Some optional froggeR settings fields are empty. You can run %s to update if desired.", col_green('froggeR_settings()')
    ))
  }
}
