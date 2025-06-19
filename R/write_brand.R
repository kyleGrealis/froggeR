#' Write Brand YAML for 'Quarto' Projects
#'
#' This function creates or updates the `_brand.yml` file in a Quarto project
#' directory if they exist in the config path.
#'
#' @inheritParams write_ignore
#'
#' @return Invisibly returns `NULL` after creating or updating the `_brand.yml` file.
#' @details
#' The function will attempt to use the current froggeR settings from the config path. If
#' no global configurations exist, a template `_brand.yml` will be created.
#'
#' @examples
#'
#' # Write the _brand.yml file
#' if (interactive()) {
#'   temp_dir <- tempdir()
#'   write_brand(temp_dir)
#' }
#'
#' @export
write_brand <- function(path = here::here(), .initialize_proj = FALSE) {
  # Validate path
  if (is.null(path) || is.na(path) || !dir.exists(path)) {
    stop("Invalid `path`. Please enter a valid project directory.")
  }

  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)

  # Set up full destination file path
  the_branding_file <- file.path(path, '_brand.yml')

  # Handle _brand.yml creation
  if (file.exists(the_branding_file)) {
    stop('_brand.yml already exists in the specified path.')
  }

  # Global froggeR settings
  config_path <- rappdirs::user_config_dir("froggeR")
  brand_file <- file.path(config_path, "_brand.yml")
  # Does it exist?
  froggeR_brand <- file.exists(brand_file)

  # Write the config file based on template: if there's a .config/froggeR file,
  # use that or else use the template found here in the package
  template_path <- if (froggeR_brand) {
    # Display message if using the .config/froggeR/_brand.yml file
    ui_info(sprintf('Copying existing %s settings...', col_green('froggeR')))
    brand_file
  } else {
    system.file('gists/brand.yml', package = 'froggeR')
  }

  if (template_path == "") {
    stop("Could not find config template in package installation")
  }

  file.copy(from = template_path, to = the_branding_file, overwrite = FALSE)
  ui_done("Created _brand.yml")

  if (!.initialize_proj) usethis::edit_file(the_branding_file)

  return(invisible(NULL))
}
