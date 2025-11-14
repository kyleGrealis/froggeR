#' Manage froggeR Metadata Settings
#'
#' Interactively create or update your froggeR metadata for reuse across Quarto projects.
#'
#' @details
#' This function provides an interactive workflow to:
#' \itemize{
#'   \item Create new metadata (name, email, ORCID, affiliations, etc.)
#'   \item Update existing metadata from project or global configurations
#'   \item View current metadata
#'   \item Save to project-level, global (system-wide), or both locations
#' }
#'
#' Metadata is stored as YAML and automatically used by \code{\link{write_variables}}
#' in future Quarto projects.
#'
#' @return Invisibly returns \code{NULL}. Called for side effects.
#'
#' @examples
#' # Only run in an interactive environment
#' if (interactive()) froggeR::settings()
#'
#' @seealso \code{\link{brand_settings}}, \code{\link{write_variables}},
#'   \code{\link{save_variables}}
#' @export
settings <- function() {

  if (!interactive()) {
    rlang::abort(
      "settings() must be run in an interactive session",
      class = "froggeR_interactive_only"
    )
  }

  # Paths for metadata
  settings_file <- file.path(here::here(), '_variables.yml')
  config_path <- rappdirs::user_config_dir("froggeR")
  config_file <- .handle_global_variables_migration(config_path)

  # Check what metadata exists
  has_project_settings <- file.exists(settings_file)
  has_global_settings <- file.exists(config_file)

  # Display current status
  cat("\n")
  ui_info(sprintf(
    "%s Metadata Status",
    col_green("froggeR")
  ))

  if (has_project_settings) {
    ui_done("Project-level metadata found")
  } else {
    ui_oops("No project-level metadata")
  }

  if (has_global_settings) {
    ui_done("Global metadata found (reuses across projects)")
  } else {
    ui_oops("No global metadata")
  }

  # Ask what user wants to do
  cat("\n")
  action <- utils::menu(
    choices = c(
      "Create or update metadata",
      "View current metadata",
      "Exit"
    ),
    title = sprintf("\nWhat would you like to do?")
  )

  # Handle user selection
  if (action == 0 || action == 3) {
    message("Exiting froggeR settings.")
    return(invisible(NULL))
  }

  if (action == 1) {
    .configure_metadata(settings_file, config_file, has_project_settings, has_global_settings)
  } else if (action == 2) {
    .view_metadata(settings_file, config_file, has_project_settings, has_global_settings)
  }

  return(invisible(NULL))
}


#' Configure Metadata Interactively
#'
#' Internal helper that guides user through metadata configuration workflow.
#'
#' @param settings_file Character. Path to project-level metadata file.
#' @param config_file Character. Path to global metadata file.
#' @param has_project_settings Logical. Whether project-level metadata exists.
#' @param has_global_settings Logical. Whether global metadata exists.
#'
#' @return Invisibly returns \code{NULL}. Called for side effects.
#' @noRd
.configure_metadata <- function(settings_file, config_file, has_project_settings, has_global_settings) {

  # Load existing metadata if available
  metadata <- list(
    name = "",
    email = "",
    orcid = "",
    url = "",
    github = "",
    affiliations = ""
  )

  source <- "new"

  # If metadata exists, ask if user wants to update it or start fresh
  if (has_project_settings || has_global_settings) {
    cat("\n")
    update_choice <- utils::menu(
      choices = c(
        "Update existing metadata",
        "Start fresh"
      ),
      title = sprintf(
        "Metadata already exists. What would you like to do?"
      )
    )

    if (update_choice == 0) {
      message("Cancelled. No changes made.")
      return(invisible(NULL))
    }

    if (update_choice == 1) {
      # Load existing metadata (prefer project-level, fall back to global)
      source_file <- if (has_project_settings) settings_file else config_file
      tryCatch(
        {
          metadata <- yaml::read_yaml(source_file)
          source <- "update"
          ui_done(sprintf("Loaded from: %s", source_file))
        },
        error = function(e) {
          ui_oops("Could not load existing metadata. Starting fresh.")
          source <<- "new"
        }
      )
    }
  }

  # Ensure all required fields exist
  for (field in c("name", "email", "orcid", "url", "github", "affiliations")) {
    if (is.null(metadata[[field]])) {
      metadata[[field]] <- ""
    }
  }

  # Walk through fields interactively
  cat("\n")
  ui_info("Enter your metadata. Press Enter to accept the current value or leave blank.\n")

  # Name (required)
  current_name <- metadata$name %||% ""
  metadata$name <- .prompt_field(
    label = "Full name",
    description = "Your full name as it appears in publications",
    current = current_name,
    required = TRUE,
    validator = .validate_name
  )

  # Email (required)
  current_email <- metadata$email %||% ""
  metadata$email <- .prompt_field(
    label = "Email address",
    description = "Contact email",
    current = current_email,
    required = TRUE,
    validator = .validate_email
  )

  # ORCID (optional)
  current_orcid <- metadata$orcid %||% ""
  metadata$orcid <- .prompt_field(
    label = "ORCID",
    description = "Optional (e.g., 0000-0001-2345-6789)",
    current = current_orcid,
    required = FALSE,
    validator = .validate_orcid
  )

  # URL (optional)
  current_url <- metadata$url %||% ""
  metadata$url <- .prompt_field(
    label = "Website or profile URL",
    description = "Optional (e.g., https://yoursite.com)",
    current = current_url,
    required = FALSE,
    validator = .validate_url
  )

  # GitHub username (optional)
  current_github <- metadata$github %||% ""
  metadata$github <- .prompt_field(
    label = "GitHub username",
    description = "Optional (e.g., octocat)",
    current = current_github,
    required = FALSE,
    validator = .validate_github
  )

  # Affiliations (optional)
  current_affiliations <- metadata$affiliations %||% ""
  metadata$affiliations <- .prompt_field(
    label = "Affiliations",
    description = "Optional (e.g., Institution, Department)",
    current = current_affiliations,
    required = FALSE
  )

  # Clean up empty values: ensure NULL/NA are converted to "" for YAML consistency
  metadata <- lapply(metadata, function(x) if (is.null(x) || is.na(x)) "" else x)

  # Show preview
  cat("\n")
  ui_info("Your metadata preview:\n")
  cat(.format_metadata_preview(metadata))

  # Ask where to save
  cat("\n")
  save_choice <- utils::menu(
    choices = c(
      "Save to this project only",
      "Save globally (reuse in all future projects)",
      "Save to both locations",
      "Cancel (discard changes)"
    ),
    title = "Where would you like to save this metadata?"
  )

  if (save_choice == 0 || save_choice == 4) {
    message("Cancelled. No changes made.")
    return(invisible(NULL))
  }

  # Save to selected location(s)
  if (save_choice %in% c(1, 3)) {
    .save_metadata_to_yaml(metadata, settings_file, "project-level")
  }

  if (save_choice %in% c(2, 3)) {
    config_dir <- dirname(config_file)
    if (!dir.exists(config_dir)) {
      dir.create(config_dir, recursive = TRUE, showWarnings = FALSE)
    }
    .save_metadata_to_yaml(metadata, config_file, "global")
  }

  ui_done(sprintf(
    "\n%s metadata configured successfully!",
    col_green("froggeR")
  ))

  if (save_choice %in% c(2, 3)) {
    ui_info(
      sprintf(
        "Your metadata will automatically be used in future %s projects.",
        col_green("froggeR")
      )
    )
  }

  return(invisible(NULL))
}


#' Prompt User for Field Value
#'
#' Interactive prompt for single metadata field with optional validation.
#'
#' @param label Character. Field label (e.g., "Full name").
#' @param description Character. Helpful description for the field. Default is empty string.
#' @param current Character. Current value when updating. Default is empty string.
#' @param required Logical. Whether field is required. Default is \code{FALSE}.
#' @param validator Optional validation function. Should accept a character value
#'   and return a list with \code{$valid} (logical) and \code{$message}
#'   (character).
#'
#' @return Character. User-provided value or current value if input is empty.
#' @noRd
.prompt_field <- function(label, description = "", current = "", required = FALSE, validator = NULL) {

  # Show description if provided
  if (description != "") {
    cat(sprintf("%s\n  %s\n", col_green(label), description))
  }

  prompt_text <- if (current != "" && !is.na(current)) {
    sprintf("  [%s]: ", current)
  } else {
    "  : "
  }

  repeat {
    input <- readline(prompt_text)

    # Use current value if input is empty and updating
    if (input == "" && current != "" && !is.na(current)) {
      return(current)
    }

    # Validate required field
    if (required && input == "") {
      cat(sprintf("  %s is required.\n", label))
      next
    }

    # Accept empty value if not required and no validator issues
    if (input == "") {
      return(NA_character_)
    }

    # Validate input if validator provided
    if (!is.null(validator)) {
      validation_result <- validator(input)
      if (!validation_result$valid) {
        cat(sprintf("  %s\n", validation_result$message))
        next
      }
    }

    return(input)
  }
}


#' Format Metadata for Preview Display
#'
#' Formats metadata list as YAML-style text for user display.
#'
#' @param metadata List. Metadata structure.
#'
#' @return Character. Formatted YAML preview string.
#' @noRd
.format_metadata_preview <- function(metadata) {
  lines <- c(
    '---',
    sprintf('name: %s', .format_yaml_value(metadata$name)),
    sprintf('email: %s', .format_yaml_value(metadata$email)),
    sprintf('orcid: %s', .format_yaml_value(metadata$orcid)),
    sprintf('url: %s', .format_yaml_value(metadata$url)),
    sprintf('github: %s', .format_yaml_value(metadata$github)),
    sprintf('affiliations: %s', .format_yaml_value(metadata$affiliations)),
    '---'
  )
  paste(lines, collapse = '\n')
}


#' Format Value for YAML Display
#'
#' Converts metadata value to display format, showing placeholder for empty values.
#'
#' @param value Value to format.
#'
#' @return Character. Formatted display string.
#' @noRd
.format_yaml_value <- function(value) {
  if (is.na(value) || value == '') {
    return('(not set)')
  }
  value
}


#' Save Metadata to YAML File
#'
#' Writes metadata to YAML file with directory creation if needed.
#'
#' @param metadata List. Metadata to save.
#' @param file_path Character. Path where file should be saved.
#' @param location_label Character. Label for user messaging (e.g., "project-level").
#'
#' @return Invisibly returns \code{NULL}. Called for side effects.
#' @noRd
.save_metadata_to_yaml <- function(metadata, file_path, location_label) {

  tryCatch(
    {
      # Ensure directory exists
      dir_path <- dirname(file_path)
      if (!dir.exists(dir_path)) {
        dir.create(dir_path, recursive = TRUE, showWarnings = FALSE)
      }

      # Write YAML
      yaml::write_yaml(metadata, file_path)

      ui_done(sprintf(
        'Saved to %s: %s',
        location_label,
        file_path
      ))
    },
    error = function(e) {
      rlang::abort(
        sprintf('Failed to save metadata: %s', e$message),
        class = 'froggeR_save_error'
      )
    }
  )
}


#' Validate Name Input
#'
#' Validates that name input is not empty and meets minimum length.
#'
#' @param value Character. Name value to validate.
#'
#' @return List with elements:
#'   \itemize{
#'     \item \code{$valid}: Logical indicating validation success
#'     \item \code{$message}: Character validation error message
#'   }
#' @noRd
.validate_name <- function(value) {
  if (nchar(trimws(value)) < 2) {
    return(list(valid = FALSE, message = 'Name must be at least 2 characters.'))
  }
  list(valid = TRUE, message = '')
}


#' Validate Email Input
#'
#' Validates that email input matches basic email format (user@domain.ext).
#'
#' @param value Character. Email value to validate.
#'
#' @return List with elements:
#'   \itemize{
#'     \item \code{$valid}: Logical indicating validation success
#'     \item \code{$message}: Character validation error message
#'   }
#' @noRd
.validate_email <- function(value) {
  # Basic email validation: must have @ and a domain
  if (!grepl('^[^@]+@[^@]+\\.[^@]+$', value)) {
    return(list(valid = FALSE, message = 'Email must be in format: user@example.com'))
  }
  list(valid = TRUE, message = '')
}


#' Validate ORCID Input
#'
#' Validates that ORCID input matches standard ORCID format (XXXX-XXXX-XXXX-XXXX).
#'
#' @param value Character. ORCID value to validate.
#'
#' @return List with elements:
#'   \itemize{
#'     \item \code{$valid}: Logical indicating validation success
#'     \item \code{$message}: Character validation error message
#'   }
#' @noRd
.validate_orcid <- function(value) {
  # ORCID format: 0000-0000-0000-0000
  if (!grepl('^\\d{4}-\\d{4}-\\d{4}-\\d{3}[0-9X]$', value)) {
    return(list(valid = FALSE, message = 'ORCID must be in format: 0000-0000-0000-0000'))
  }
  list(valid = TRUE, message = '')
}


#' Validate URL Input
#'
#' Validates that URL input starts with http:// or https://.
#'
#' @param value Character. URL value to validate.
#'
#' @return List with elements:
#'   \itemize{
#'     \item \code{$valid}: Logical indicating validation success
#'     \item \code{$message}: Character validation error message
#'   }
#' @noRd
.validate_url <- function(value) {
  if (!grepl('^https?://', value)) {
    return(list(valid = FALSE, message = 'URL must start with http:// or https://'))
  }
  list(valid = TRUE, message = '')
}


#' Validate GitHub Username Input
#'
#' Validates that GitHub username meets GitHub's naming requirements.
#'
#' @param value Character. GitHub username to validate.
#'
#' @return List with elements:
#'   \itemize{
#'     \item \code{$valid}: Logical indicating validation success
#'     \item \code{$message}: Character validation error message
#'   }
#' @noRd
.validate_github <- function(value) {
  # GitHub usernames: alphanumeric, hyphens, no leading/trailing hyphens, max 39 chars
  if (!grepl('^[a-zA-Z0-9]([a-zA-Z0-9-]{0,37}[a-zA-Z0-9])?$', value)) {
    return(list(valid = FALSE, message = 'GitHub username: alphanumeric and hyphens only (no leading/trailing hyphens, max 39 chars)'))
  }
  list(valid = TRUE, message = '')
}


#' View Metadata
#'
#' Displays current project-level and/or global metadata configurations to user.
#'
#' @param settings_file Character. Path to project-level metadata file.
#' @param config_file Character. Path to global metadata file.
#' @param has_project_settings Logical. Whether project-level metadata exists.
#' @param has_global_settings Logical. Whether global metadata exists.
#'
#' @return Invisibly returns \code{NULL}. Called for side effects.
#' @noRd
.view_metadata <- function(settings_file, config_file, has_project_settings, has_global_settings) {

  cat("\n")

  if (has_project_settings) {
    ui_done("Project-level metadata:\n")
    cat(readLines(settings_file), sep = "\n")
    cat("\n\n")
  }

  if (has_global_settings) {
    ui_done("Global metadata (used by default in new projects):\n")
    cat(readLines(config_file), sep = "\n")
    cat("\n\n")
  }

  if (!has_project_settings && !has_global_settings) {
    ui_oops('No metadata found.')
    ui_info("Run froggeR::settings() and select 'Create or update metadata' to get started.")
  }

  return(invisible(NULL))
}
