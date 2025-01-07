#' Create a New Quarto Document
#'
#' This function creates a new Quarto document (.qmd file) with either a custom
#' or standard YAML header. When using a custom header, it integrates with 
#' `froggeR_settings` for reusable metadata across documents.
#'
#' @param filename Character string. The name of the file without the '.qmd' extension.
#'   Only letters, numbers, hyphens, and underscores are allowed.
#' @param path Character string. Directory where the file will be created. Defaults to
#'   the current project's base directory.
#' @param custom_yaml Logical. If TRUE (default), creates a Quarto document with a
#'   custom YAML header using values from `_variables.yml`. If FALSE, creates a
#'   standard Quarto document.
#' @param initialize_proj Logical. TRUE only if starting a 
#'  \code{froggeR::quarto_project()}.
#'
#' @return Invisibly returns NULL after creating the Quarto document.
#'
#' @details
#' When `custom_yaml = TRUE`, the function will:
#' - Check for `froggeR_settings`.
#' - Create or update `_variables.yml` for document metadata.
#' - Create auxiliary files (`custom.scss`, `_quarto.yml`) if they don't already exist.
#'
#' If `froggeR_settings` are missing, the function warns the user and provides 
#' guidance to set them up for reusable metadata. A standard YAML document will still 
#' be created.
#'
#' @examples
#' \donttest{
#' # Create a new Quarto document with custom YAML
#' write_quarto(filename = "frog_analysis", path = tempdir())
#'
#' # Create a basic Quarto document with standard YAML
#' write_quarto(filename = "frog_analysis_basic", path = tempdir(), custom_yaml = FALSE)
#' }
#' @export
write_quarto <- function(
  filename = 'frogs', 
  path = here::here(), 
  custom_yaml = TRUE,
  initialize_proj = FALSE
) {
  # Validate path
  if (is.null(path) || !dir.exists(path)) {
    stop("Invalid `path`. Please enter a valid project directory.")
  }

  # Validate filename
  if (!is.character(filename)) stop('Invalid filename: must be character.')
  if (!grepl('^[a-zA-Z0-9_-]+$', filename)) {
    stop('Invalid filename. Use only letters, numbers, hyphens, and underscores.')
  }

  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)

  # Set up full file path
  the_quarto_file <- file.path(path, paste0(filename, '.qmd'))

  # Check for existing Quarto doc
  if (file.exists(the_quarto_file)) {
    stop(sprintf("%s.qmd already exists in the specified path.", filename))
  }

  # Handle custom YAML
  if (custom_yaml) {
    settings <- froggeR_settings(update = FALSE, verbose = FALSE)

    if (is.null(settings)) {
      warning(
        sprintf(
          "No %s settings detected. Your Quarto document won't knit properly. Run %s to set up reusable metadata.",
          col_green("froggeR"),
          col_green("froggeR_settings()")
        )
      )
    } else if (!file.exists(file.path(path, '_variables.yml'))) {
      # Create or update _variables.yml
      write_variables(path, settings)
    }

    # Ensure auxiliary files exist
    if (!initialize_proj) ensure_auxiliary_files(path)
  }

  # Write the Quarto file based on template
  template_path <- if (custom_yaml) {
    system.file('gists/custom_quarto.qmd', package = 'froggeR')
  } else {
    system.file('gists/basic_quarto.qmd', package = 'froggeR')
  }

  if (template_path == "") {
    stop("Could not find Quarto template in package installation")
  }

  file.copy(from = template_path, to = the_quarto_file, overwrite = FALSE)
  ui_done(sprintf(
    "Created %s.qmd %s", filename, ifelse(custom_yaml, col_green("with custom YAML"), "")
  ))

  invisible(NULL)
}
