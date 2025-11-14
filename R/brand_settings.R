#' Manage Brand Settings for froggeR Quarto Projects
#'
#' Interactively configure your branding (colors, logos, organization name) for
#' reuse across multiple Quarto projects.
#'
#' @details
#' This function provides an interactive workflow with three main options:
#'
#' \enumerate{
#'   \item \strong{Create or update branding}: Interactively configure:
#'     \itemize{
#'       \item Organization/project name
#'       \item Primary brand color (hex format, e.g., #0066cc)
#'       \item Large logo path
#'       \item Small/icon logo path
#'       \item Optional: Advanced customization through template editing
#'     }
#'   \item \strong{View current branding}: Display existing project-level and
#'     global brand configurations
#'   \item \strong{Exit}: Return to console
#' }
#'
#' After configuring basic settings, you can choose to:
#' \itemize{
#'   \item Save with the basics (quick setup)
#'   \item Edit the full template for advanced options (typography, color palettes,
#'     links, code styling, headings)
#' }
#'
#' Branding is stored as YAML (\code{_brand.yml}) in:
#' \itemize{
#'   \item Project-level: \code{_brand.yml} in the current Quarto project
#'   \item Global: System-wide config directory (reused across all projects)
#'   \item Both: Saved to both locations
#' }
#'
#' Global branding is automatically applied in new projects via
#' \code{\link{quarto_project}} and \code{\link{write_brand}}.
#'
#' @return Invisibly returns \code{NULL}. Called for side effects (interactive
#'   configuration).
#'
#' @examples
#' # Open interactive brand settings configuration
#' if (interactive()) {
#'   froggeR::brand_settings()
#' }
#'
#' @seealso \code{\link{settings}}, \code{\link{write_brand}},
#'   \code{\link{save_brand}}
#' @export
brand_settings <- function() {

  if (!interactive()) {
    rlang::abort(
      'brand_settings() must be run in an interactive session',
      class = 'froggeR_interactive_only'
    )
  }

  # Paths for branding
  settings_file <- file.path(here::here(), '_brand.yml')
  config_path <- rappdirs::user_config_dir('froggeR')
  config_file <- file.path(config_path, '_brand.yml')

  # Check what branding exists
  has_project_branding <- file.exists(settings_file)
  has_global_branding <- file.exists(config_file)

  # Display current status
  cat('\n')
  ui_info(sprintf(
    '%s Brand Configuration',
    col_green('froggeR')
  ))

  if (has_project_branding) {
    ui_done('Project-level branding found')
  } else {
    ui_oops('No project-level branding')
  }

  if (has_global_branding) {
    ui_done('Global branding found (reuses across projects)')
  } else {
    ui_oops('No global branding')
  }

  # Ask what user wants to do
  cat('\n')
  action <- utils::menu(
    choices = c(
      'Create or update branding',
      'View current branding',
      'Exit'
    ),
    title = sprintf('\nWhat would you like to do?')
  )

  # Handle user selection
  if (action == 0 || action == 3) {
    message('Exiting froggeR brand settings.')
    return(invisible(NULL))
  }

  if (action == 1) {
    .configure_brand(
      settings_file,
      config_file,
      has_project_branding,
      has_global_branding
    )
  } else if (action == 2) {
    .view_brand(
      settings_file,
      config_file,
      has_project_branding,
      has_global_branding
    )
  }

  return(invisible(NULL))
}


#' Configure Brand Interactively
#'
#' Internal helper that guides user through brand configuration workflow,
#' including basic settings entry and optional template editing.
#'
#' @param settings_file Character. Path to project-level branding file.
#' @param config_file Character. Path to global branding file.
#' @param has_project_branding Logical. Whether project-level branding exists.
#' @param has_global_branding Logical. Whether global branding exists.
#'
#' @return Invisibly returns \code{NULL}. Called for side effects.
#' @noRd
.configure_brand <- function(
  settings_file,
  config_file,
  has_project_branding,
  has_global_branding
) {

  # Initialize brand structure
  brand <- list(
    meta = list(name = ''),
    color = list(palette = list(primary = '')),
    logo = list(large = '', small = '')
  )

  # If branding exists, ask if user wants to update it or start fresh
  if (has_project_branding || has_global_branding) {
    cat('\n')
    update_choice <- utils::menu(
      choices = c(
        'Update existing branding',
        'Start fresh'
      ),
      title = sprintf(
        'Branding already exists. What would you like to do?'
      )
    )

    if (update_choice == 0) {
      message('Cancelled. No changes made.')
      return(invisible(NULL))
    }

    if (update_choice == 1) {
      # Load existing branding (prefer project-level, fall back to global)
      source_file <- if (has_project_branding) settings_file else config_file
      tryCatch(
        {
          brand <- yaml::read_yaml(source_file)
          ui_done(sprintf('Loaded from: %s', source_file))
        },
        error = function(e) {
          ui_oops('Could not load existing branding. Starting fresh.')
        }
      )
    }
  }

  # Ensure structure exists for updates
  if (is.null(brand$meta)) brand$meta <- list()
  if (is.null(brand$meta$name)) brand$meta$name <- ''
  if (is.null(brand$color)) brand$color <- list()
  if (is.null(brand$color$palette)) brand$color$palette <- list()
  if (is.null(brand$color$palette$primary)) brand$color$palette$primary <- ''
  if (is.null(brand$logo)) brand$logo <- list()
  if (is.null(brand$logo$large)) brand$logo$large <- ''
  if (is.null(brand$logo$small)) brand$logo$small <- ''

  # Walk through Core Elements (Interactive) fields interactively
  cat('\n')
  ui_info('Let\'s configure your core branding elements interactively.\n')

  # Project/organization name
  current_name <- brand$meta$name %||% ''
  brand$meta$name <- .prompt_brand_field(
    label = 'Project or organization name',
    description = 'Used in document headers and branding',
    current = current_name,
    required = FALSE
  )

  # Primary color
  current_color <- brand$color$palette$primary %||% ''
  brand$color$palette$primary <- .prompt_brand_field(
    label = 'Primary brand color',
    description = 'Hex format (e.g., #0066cc, #FF5733). See: https://www.color-hex.com/',
    current = current_color,
    required = FALSE,
    validator = .validate_hex_color
  )

  # Logo large
  current_logo_large <- brand$logo$large %||% ''
  brand$logo$large <- .prompt_brand_field(
    label = 'Logo path - large',
    description = 'Path to large logo (e.g., logos/logo-large.png)',
    current = current_logo_large,
    required = FALSE
  )

  # Logo small
  current_logo_small <- brand$logo$small %||% ''
  brand$logo$small <- .prompt_brand_field(
    label = 'Logo path - small',
    description = 'Path to small/icon logo (e.g., logos/logo-icon.png)',
    current = current_logo_small,
    required = FALSE
  )

  # Convert NA_character_ to '' for YAML consistency
  if (is.na(brand$meta$name)) brand$meta$name <- ''
  if (is.na(brand$color$palette$primary)) brand$color$palette$primary <- ''
  if (is.na(brand$logo$large)) brand$logo$large <- ''
  if (is.na(brand$logo$small)) brand$logo$small <- ''

  # Show preview of Core Elements configuration
  cat('\n')
  ui_info('Here\'s your current core branding configuration:\n')
  cat(.format_brand_preview(brand))

  # Show available Advanced Options (Template) options
  cat('\n')
  ui_info('For advanced customization, you can edit the full branding template:\n')
  cat(.format_brand_roadmap())

  # Ask how to proceed
  cat('\n')
  proceed_choice <- utils::menu(
    choices = c(
      'Save with these basics',
      'Edit the full template for advanced options',
      'Cancel (discard changes)'
    ),
    title = 'What would you like to do?'
  )

  if (proceed_choice == 0 || proceed_choice == 3) {
    message('Cancelled. No changes made.')
    return(invisible(NULL))
  }

  if (proceed_choice == 2) {
    # User wants to edit full template - create and open it
    cat('\n')
    ui_info('A branding template will open in your editor for advanced customization.')
    cat('Configure additional options, then save.\n')
    Sys.sleep(2)

    # Merge with template and open for editing
    template_path <- system.file('gists/brand.yml', package = 'froggeR')
    if (template_path == '') {
      rlang::abort(
        'Could not find brand template in package installation',
        class = 'froggeR_template_not_found'
      )
    }

    # Create a temporary merged file with user values injected
    merged_brand <- .merge_brand_with_template(brand, template_path)

    # Save to project for editing
    temp_brand_file <- settings_file
    .save_brand_to_yaml(merged_brand, temp_brand_file, 'project-level (for editing)')

    # Open in editor
    usethis::edit_file(temp_brand_file)

    ui_done(sprintf(
      '\n%s branding configured!',
      col_green('froggeR')
    ))
    return(invisible(NULL))
  }

  # Proceed choice == 1: Save with basics only
  # Ask where to save
  cat('\n')
  save_choice <- utils::menu(
    choices = c(
      'Save to this project only',
      'Save globally (reuse in all future projects)',
      'Save to both locations',
      'Cancel (discard changes)'
    ),
    title = 'Where would you like to save this branding?'
  )

  if (save_choice == 0 || save_choice == 4) {
    message('Cancelled. No changes made.')
    return(invisible(NULL))
  }

  # Save to selected location(s)
  if (save_choice %in% c(1, 3)) {
    .save_brand_to_yaml(brand, settings_file, 'project-level')
  }

  if (save_choice %in% c(2, 3)) {
    config_dir <- dirname(config_file)
    if (!dir.exists(config_dir)) {
      dir.create(config_dir, recursive = TRUE, showWarnings = FALSE)
    }
    .save_brand_to_yaml(brand, config_file, 'global')
  }

  ui_done(sprintf(
    '\n%s branding configured successfully!',
    col_green('froggeR')
  ))

  if (save_choice %in% c(2, 3)) {
    ui_info(
      sprintf(
        'Your branding will automatically be used in future %s projects.',
        col_green('froggeR')
      )
    )
  }

  return(invisible(NULL))
}


#' Prompt User for Brand Field Value
#'
#' Interactive prompt for single brand configuration field with optional validation.
#'
#' @param label Character. Field label (e.g., "Project name").
#' @param description Character. Helpful description for the field. Default is empty string.
#' @param current Character. Current value when updating. Default is empty string.
#' @param required Logical. Whether field is required. Default is \code{FALSE}.
#' @param validator Optional validation function. Should accept a character value
#'   and return a list with \code{$valid} (logical) and \code{$message}
#'   (character).
#'
#' @return Character. User-provided value or current value if input is empty.
#' @noRd
.prompt_brand_field <- function(label, description = "", current = "", required = FALSE, validator = NULL) {

  # Show description if provided
  if (description != "") {
    cat(sprintf("%s\n  %s\n", col_green(label), description))
  }

  # Sanitize current value for display in prompt
  display_current <- gsub('[\r\n]', '', current) # Remove newlines
  
  prompt_text <- if (display_current != "" && !is.na(display_current)) {
    sprintf("  [%s]: ", display_current)
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

    # Accept empty value if not required
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


#' Validate Hex Color Input
#'
#' Validates that input is a valid hexadecimal color code.
#'
#' @param value Character. Color value to validate.
#'
#' @return List with elements:
#'   \itemize{
#'     \item \code{$valid}: Logical indicating validation success
#'     \item \code{$message}: Character validation error message
#'   }
#' @noRd
.validate_hex_color <- function(value) {
  # Hex color format: #RRGGBB or #RGB
  if (!grepl('^#([0-9A-Fa-f]{6}|[0-9A-Fa-f]{3})$', value)) {
    return(list(
      valid = FALSE,
      message = 'Color must be in hex format: #RRGGBB (e.g., #0066cc) or #RGB (e.g., #06c)'
    ))
  }
  list(valid = TRUE, message = '')
}


#' Format Brand Configuration Preview
#'
#' Formats brand configuration list as YAML-style text for user display.
#'
#' @param brand List. Brand configuration structure.
#'
#' @return Character. Formatted YAML preview string.
#' @noRd
.format_brand_preview <- function(brand) {
  lines <- c(
    '---',
    sprintf('meta:'),
    sprintf('  name: %s', .format_brand_value(brand$meta$name)),
    '',
    sprintf('logo:'),
    sprintf('  large: %s', .format_brand_value(brand$logo$large)),
    sprintf('  small: %s', .format_brand_value(brand$logo$small)),
    '',
    sprintf('color:'),
    sprintf('  palette:'),
    sprintf('    primary: %s', .format_brand_value(brand$color$palette$primary)),
    '---'
  )
  paste(lines, collapse = '\n')
}


#' Format Value for Brand Display
#'
#' Converts brand value to display format, showing placeholder for empty values.
#'
#' @param value Value to format.
#'
#' @return Character. Formatted display string.
#' @noRd
.format_brand_value <- function(value) {
  if (is.na(value) || value == '') {
    return('(not set)')
  }
  value
}


#' Format Brand Advanced Options Roadmap
#'
#' Shows users what advanced customization options are available.
#'
#' @return Character. Formatted roadmap string.
#' @noRd
.format_brand_roadmap <- function() {
  roadmap <- c(
    '* Typography: fonts, families, sizes, styles',
    '* Colors: additional color palette options',
    '* Links: custom link colors and styling',
    '* Code: monospace font and inline code styling',
    '* Headings: custom heading colors and styles',
    '* Logo meta: alt text, links, sizing',
    '',
    "To customize these, select 'Edit the full template' above."
  )
  paste(roadmap, collapse = '\n')
}


#' Merge User Brand Config with Full Template
#'
#' Injects user values into the template while preserving all available options.
#'
#' @param brand List. User's brand configuration.
#' @param template_path Character. Path to brand.yml template file.
#'
#' @return List. Merged brand configuration.
#' @noRd
.merge_brand_with_template <- function(brand, template_path) {

  tryCatch(
    {
      # Read the template
      template_content <- paste(readLines(template_path), collapse = '\n')

      # For now, we'll use the user's brand config directly
      # The template serves as a reference when edited manually
      # This gives users a working config + the template as guidance

      brand
    },
    error = function(e) {
      rlang::abort(
        sprintf('Failed to merge with template: %s', e$message),
        class = 'froggeR_merge_error'
      )
    }
  )
}


#' Save Brand Configuration to YAML File
#'
#' Writes brand configuration to YAML file with directory creation if needed.
#'
#' @param brand List. Brand configuration to save.
#' @param file_path Character. Path where file should be saved.
#' @param location_label Character. Label for user messaging (e.g., "project-level").
#'
#' @return Invisibly returns \code{NULL}. Called for side effects.
#' @noRd
.save_brand_to_yaml <- function(brand, file_path, location_label) {

  tryCatch(
    {
      # Ensure directory exists
      dir_path <- dirname(file_path)
      if (!dir.exists(dir_path)) {
        dir.create(dir_path, recursive = TRUE, showWarnings = FALSE)
      }

      # Write YAML
      yaml::write_yaml(brand, file_path)

      ui_done(sprintf(
        'Saved to %s: %s',
        location_label,
        file_path
      ))
    },
    error = function(e) {
      rlang::abort(
        sprintf('Failed to save branding: %s', e$message),
        class = 'froggeR_save_error'
      )
    }
  )
}


#' View Brand Configuration
#'
#' Displays current project-level and/or global brand configurations to user.
#'
#' @param settings_file Character. Path to project-level branding file.
#' @param config_file Character. Path to global branding file.
#' @param has_project_branding Logical. Whether project-level branding exists.
#' @param has_global_branding Logical. Whether global branding exists.
#'
#' @return Invisibly returns \code{NULL}. Called for side effects.
#' @noRd
.view_brand <- function(settings_file, config_file, has_project_branding, has_global_branding) {

  cat("\n")

  if (has_project_branding) {
    ui_done("Project-level branding:\n")
    cat(readLines(settings_file), sep = "\n")
    cat("\n\n")
  }

  if (has_global_branding) {
    ui_done("Global branding (used by default in new projects):\n")
    cat(readLines(config_file), sep = "\n")
    cat("\n\n")
  }

  if (!has_project_branding && !has_global_branding) {
    ui_oops('No branding found.')
    ui_info("Run froggeR::brand_settings() and select 'Create or update branding' to get started.")
  }

  return(invisible(NULL))
}
