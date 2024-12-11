#' Manage froggeR settings
#'
#' This function allows you to check, display, or initialize froggeR settings for 
#' Quarto documents. Settings are stored in \code{~/.config/froggeR/config.yml} 
#' for persistence across froggeR projects.
#'
#' @param update Logical. If TRUE (default), prompts to update existing settings
#'   or create new ones if none exist.
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
#' \dontrun{
#'   # Update settings (interactive)
#'   froggeR_settings(update = TRUE)
#'
#'   # Load current settings without updating
#'   settings <- froggeR_settings(update = FALSE)
#'   print(settings)
#' }
froggeR_settings <- function(update = TRUE) {
  settings <- .load_settings()

  if (is.null(settings) || update) {
    results <- .update_settings(settings)
    settings <- results$settings

    if (results$changed) {
      ui_done(sprintf('%s settings updated', col_green('froggeR')))
    }
    if (update) {
      answer <- tolower(readline('Update or create _variables.yml? [y/n] '))
      if (answer == 'y') .update_variables_yml(settings = settings)
    }
  } else {
    cat("Current froggeR settings:\n")
    display_names <- c(
      'Name', 'e-mail', 'ORCID', 'URL', 'Affiliation', 'Table of Contents'
    )
    max_name_length <- max(nchar(display_names))
    
    for (i in seq_along(settings)) {
      name <- display_names[i]
      value <- settings[[i]]
      padding <- paste(rep(" ", max_name_length - nchar(name)), collapse = "")
      cat(sprintf("%s:%s %s\n", name, padding, value))
    }
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
      return(settings)
    }, error = function(e) {
      warning('Error loading settings file. Using default settings.')
      return(NULL)
    })
  } else {
    return(NULL)
  }
}

.update_settings <- function(settings = NULL) {
  if (is.null(settings)) {
    settings <- list(
      name = '', email = '', orcid = '', url = '', affiliations = '',
      # Set as default
      toc = 'Table of Contents'
    )
  }
  original_settings <- settings

  # Clean names for display
  setting_names <- list('Name', 'e-mail', 'ORCID', 'URL', 'Affiliation')

  message('Leave blank if you do not wish to change that entry.')
  for (i in seq_along(setting_names)) {
    if (settings[[i]] == ''){
      prompt <- sprintf('Enter value for %s: ', setting_names[[i]])
    } else {
      prompt <- sprintf(
        'Enter new value for %s [%s]: ', setting_names[[i]], settings[[i]]
      )
    }
    
    new_value <- readline(prompt)
    if (new_value != '') settings[[i]] <- new_value
  }

  # Handle when toc is left blank
  if (settings$toc == '') settings$toc <- 'Table of Contents'

  settings_were_changed <- !identical(original_settings, settings)
  .save_settings(settings)

  list(settings = settings, changed = settings_were_changed)
}

.save_settings <- function(settings) {
  config_path <- rappdirs::user_config_dir('froggeR')
  config_file <- file.path(config_path, 'config.yml')

  dir.create(config_path, showWarnings = FALSE, recursive = TRUE)
  yaml::write_yaml(settings, config_file)
  invisible(settings)
}

.update_variables_yml <- function(path = getwd(), settings) {
  variables_file <- file.path(path, '_variables.yml')
  
  file_existed <- file.exists(variables_file)
  yaml::write_yaml(settings, variables_file)

  if (file_existed) {
    ui_done('Updated _variables.yml')
  } else {
    ui_done('Created _variables.yml')
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