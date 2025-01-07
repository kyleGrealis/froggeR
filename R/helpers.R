# Helpers for froggeR

#' Write .Rproj File
#'
#' Helper function to create or overwrite an RStudio project file (.Rproj).
#' Ensures consistent settings across froggeR projects.
#'
#' @param name Character string. Name of the .Rproj file.
#' @param path Character string. Path to the project directory.
#' @return Invisibly returns NULL after creating the .Rproj file.
#' @noRd
.write_rproj <- function(name, path = here::here()) {
  # Check if directory exists
  if (!dir.exists(path)) {
    stop("Directory does not exist")
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

#' Check FroggeR Settings
#'
#' Validates and displays potential issues with froggeR settings.
#' @param settings A list of current settings.
#' @return NULL. Prints messages if issues are detected.
#' @noRd
.check_settings <- function(settings) {
  if (settings$name == "") {
    ui_info(sprintf(
      "The 'name' field in your %s settings is empty. Run %s to set this.",
      col_green('froggeR'), col_green('froggeR_settings()')
    ))
  }

  missing_optional <- sapply(settings[c("email", "orcid", "url", "affiliations")], function(x) x == "")
  if (any(missing_optional)) {
    ui_info(sprintf(
      "Some optional fields are empty. Consider running %s to update.",
      col_green('froggeR_settings()')
    ))
  }
}

# Helper for Auxiliary Files
ensure_auxiliary_files <- function(path) {
  # Validate the path
  if (!dir.exists(path)) {
    stop("Invalid path. The specified directory does not exist.")
  }

  # Define paths for auxiliary files
  scss_path <- file.path(path, 'custom.scss')
  quarto_yml_path <- file.path(path, '_quarto.yml')

  # Handle custom.scss
  if (!file.exists(scss_path)) {
    write_scss(path = path, name = 'custom')
  }

  # Handle _quarto.yml
  if (!file.exists(quarto_yml_path)) {
    writeLines("project:\n  title: \"Quarto Project\"", quarto_yml_path)
    ui_done("Created '_quarto.yml'")
  }
}
