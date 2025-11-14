#' Write Brand YAML for Quarto Projects
#'
#' This function creates a \code{_brand.yml} file in a Quarto project and opens it
#' for editing.
#'
#' @param path Character. Path to the project directory. Default is current project
#'   root via \code{\link[here]{here}}.
#' @param restore_logos Logical. Restore logo content from system configuration.
#'   Default is \code{TRUE}.
#'
#' @return Invisibly returns the path to the created file.
#'
#' @details
#' The function will attempt to use the current froggeR settings from the global
#' config path. If no global configurations exist, a template \code{_brand.yml}
#' will be created.
#'
#' In interactive sessions, the file is opened in the default editor for immediate
#' customization.
#'
#' @examples
#' # Write the _brand.yml file
#' if (interactive()) {
#'   temp_dir <- tempdir()
#'   # In an interactive session, this would also open the file for editing.
#'   write_brand(temp_dir)
#'   # Verify the file was created
#'   file.exists(file.path(temp_dir, "_brand.yml"))
#' }
#'
#' @seealso \code{\link{brand_settings}}, \code{\link{save_brand}},
#'   \code{\link{settings}}
#' @export
write_brand <- function(path = here::here(), restore_logos = TRUE) {
  the_branding_file <- create_brand(path, restore_logos)
  if (interactive()) {
    usethis::edit_file(the_branding_file)
  }
  invisible(the_branding_file)
}

#' Create Brand YAML for Quarto Projects (internal worker)
#'
#' Internal helper that creates \code{_brand.yml} and optionally restores logos.
#'
#' @param path Character. Path to the project directory.
#' @param restore_logos Logical. Whether to copy logos from global config.
#'
#' @return Path to the created file.
#' @noRd
create_brand <- function(path, restore_logos = TRUE) {
  # Validate and normalize path
  path <- .validate_and_normalize_path(path)

  # Set up full destination file path
  the_branding_file <- file.path(path, '_brand.yml')

  # Handle _brand.yml creation
  if (file.exists(the_branding_file)) {
    rlang::abort(
      '_brand.yml already exists in this project.',
      class = 'froggeR_file_exists'
    )
  }

  # Global froggeR settings
  config_path <- rappdirs::user_config_dir("froggeR")
  brand_file <- file.path(config_path, "_brand.yml")
  # Does it exist?
  froggeR_brand <- file.exists(brand_file)

  # Write the config file based on template
  template_path <- if (froggeR_brand) {
    ui_info(sprintf('Copying existing %s brand settings...', col_green('froggeR')))
    brand_file
  } else {
    system.file('gists/brand.yml', package = 'froggeR')
  }

  if (template_path == '') {
    rlang::abort(
      'Could not find brand template in package installation.',
      class = 'froggeR_template_not_found'
    )
  }

  file.copy(from = template_path, to = the_branding_file, overwrite = FALSE)
  ui_done('Created _brand.yml')

  # Restore from logos directory or create it
  # Global froggeR logos
  frogger_logos <- file.path(config_path, 'logos')
  # Does it exist?
  logos_dir <- dir.exists(frogger_logos)

  # Handle logos creation
  if (restore_logos) {
    # Logos desination path
    logos_dest <- file.path(path, 'logos')

    if (dir.exists(logos_dest)) {
      ui_oops('Logos directory already exists in this project. Skipping...')
    } else if(!logos_dir) {
      ui_info("No config level 'logos' directory was found. Skipping...")
    } else {
      fs::dir_copy(frogger_logos, logos_dest)
      ui_done(sprintf('Copying existing %s logos.', col_green('froggeR')))
    }
  }

  return(the_branding_file)
}