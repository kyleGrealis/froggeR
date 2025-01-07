#' Manage froggeR Settings
#'
#' This function allows you to check, display, or initialize froggeR settings for
#' Quarto documents. Settings are stored in `~/.config/froggeR/config.yml` for
#' persistence across froggeR projects.
#'
#' @param update Logical. If TRUE (default), prompts to update existing settings
#'   or create new ones if none exist.
#' @param verbose Logical. If TRUE (default), settings output is printed to the console.
#'
#' @return Invisibly returns the current settings list.
#'
#' @details
#' The function manages the following settings:
#' - `name`: Your Name (required)
#' - `email`: your.email@example.com (required)
#' - `orcid`: 0000-0000-0000-0000 (optional)
#' - `url`: https://github.com/yourUsername (optional)
#' - `affiliations`: Your Institution (optional)
#' - `toc`: Table of Contents (defaults to this if left empty)
#'
#' When run interactively with `update = TRUE`, it provides a menu-driven interface
#' for updating these settings. If settings don't exist, it will prompt to create them
#' regardless of the `update` parameter.
#'
#' @examples
#' \donttest{
#' # Update settings interactively with console feedback
#' froggeR_settings(update = TRUE, verbose = TRUE)
#'
#' # Save settings without updating and print console output
#' settings <- froggeR_settings(update = FALSE, verbose = TRUE)
#'
#' # Save settings without updating and suppress console output
#' settings <- froggeR_settings(update = FALSE, verbose = FALSE)
#' }
#'
#' @export
froggeR_settings <- function(update = TRUE, verbose = TRUE) {
  # Validate arguments
  if (!is.logical(update) || length(update) != 1) {
    stop("`update` must be a single logical value.")
  }
  if (!is.logical(verbose) || length(verbose) != 1) {
    stop("`verbose` must be a single logical value.")
  }

  # Load existing settings
  settings <- .load_settings()

  # Update settings if requested or if none exist
  if (is.null(settings) || update) {
    results <- .update_settings(settings)
    settings <- results$settings

    if (results$changed && verbose) {
      ui_done(sprintf("%s settings updated successfully.", col_green("froggeR")))
    }
  }

  # Display current settings if verbose
  if (verbose && !is.null(settings)) {
    .display_settings(settings)
  }

  invisible(settings)
}

# Helper: Load Settings ---------------------------------------------------
.load_settings <- function() {
  config_path <- rappdirs::user_config_dir("froggeR")
  config_file <- file.path(config_path, "config.yml")

  if (file.exists(config_file)) {
    tryCatch({
      settings <- yaml::read_yaml(config_file)
      settings$toc <- settings$toc %||% "Table of Contents"
      return(settings)
    }, error = function(e) {
      warning("Error loading settings. Returning NULL.")
      return(NULL)
    })
  } else {
    return(NULL)
  }
}

# Helper: Update Settings -------------------------------------------------
.update_settings <- function(settings = NULL) {
  # Initialize settings if none exist
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

  message(sprintf("Updating %s settings. Leave blank to keep current values.", col_green("froggeR")))

  # Prompt user to update each setting
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

  # Save settings if they were changed
  if (!identical(settings, original_settings)) {
    .save_settings(settings)
    return(list(settings = settings, changed = TRUE))
  }

  list(settings = settings, changed = FALSE)
}

# Helper: Save Settings ---------------------------------------------------
.save_settings <- function(settings) {
  config_path <- rappdirs::user_config_dir("froggeR")
  config_file <- file.path(config_path, "config.yml")

  dir.create(config_path, showWarnings = FALSE, recursive = TRUE)
  yaml::write_yaml(settings, config_file)
}

# Helper: Display Settings ------------------------------------------------
.display_settings <- function(settings) {
  display_names <- c("Name", "email", "ORCID", "URL", "Affiliations", "Table of Contents")
  max_name_length <- max(nchar(display_names))

  message(sprintf("\nCurrent %s settings:\n", col_green("froggeR")))
  for (i in seq_along(settings)) {
    name <- display_names[i]
    value <- settings[[i]]
    padding <- paste(rep(" ", max_name_length - nchar(name)), collapse = "")
    message(sprintf("%s:%s %s", name, padding, value))
  }
  message("\n")
}
