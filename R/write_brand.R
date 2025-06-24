#' Write Brand YAML for 'Quarto' Projects
#'
#' This function creates or updates the `_brand.yml` file in a Quarto project
#' directory if they exist in the config path.
#'
#' @inheritParams write_ignore
#' @param restore_logos Logical. Restore logo content from system configuration.
#' Default is `TRUE`.
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
write_brand <- function(
  path = here::here(), restore_logos = TRUE, .initialize_proj = FALSE
) {
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
    stop('_brand.yml already exists in this project.')
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
    ui_info(sprintf('Copying existing %s brand settings...', col_green('froggeR')))
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
  
  # Restore from logos directory or create it
  # Global froggeR logos
  frogger_logos <- file.path(config_path, "logos")
  # Does it exist?
  logos_dir <- dir.exists(frogger_logos)

  # Handle logos creation
  if (restore_logos) {
    # Logos desination path
    logos_dest <- file.path(path, "logos")

    if (dir.exists("logos")) {
      ui_oops("Logos directory already exists in this project. Skipping...")
    } else if(!logos_dir) {
      ui_info("No config level 'logos' directory was found. Skipping...")
    } else {
      fs::dir_copy(frogger_logos, logos_dest)
      ui_done(sprintf('Copying existing %s logos.', col_green('froggeR')))
    }
  }

  return(invisible(NULL))
}
