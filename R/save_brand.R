#' Save brand YAML for 'Quarto' Projects
#'
#' This function saves the current `_brand.yml` file from an existing froggeR
#' Quarto project. This provides a safety catch to prevent unintended overwrite if the
#' system-level configuration file exists.
#'
#' @return Invisibly returns `NULL` after creating system-level configuration file.
#' @details
#' The function will attempt to create a system-level configuration file from the current
#' froggeR Quarto project. If the system-level configuration file already exists, the
#' user will be prompted prior to overwrite.
#'
#' @examples
#'
#' # Write the _brand.yml file
#' if (interactive()) save_brand()
#'
#' @export
save_brand <- function() {
  # Normalize the path for consistency
  path <- normalizePath(here::here(), mustWork = TRUE)

  # Set up full origin file path
  the_brand_file <- file.path(path, '_brand.yml')

  # Check for project-level _brand.yml
  if (!file.exists(the_brand_file)) {
    ui_oops(
      sprintf(
        'No current _brand.yml file exists in this project. Run %s to create it.',
        col_green('froggeR::write_brand()')
      )
    )
    return(invisible(NULL))
  }

  # Global froggeR settings
  config_path <- rappdirs::user_config_dir("froggeR")
  brand_file <- file.path(config_path, "_brand.yml")
  # Does it exist?
  system_settings <- file.exists(brand_file)
  # Overwrite_prompt
  overwrite_prompt <- sprintf(
    "A system-level %s configuration was found. Overwrite??",
    col_green("froggeR")
  )

  # Save the config file or prompt the user to overwrite
  if (system_settings) {
    if (ui_yeah(overwrite_prompt)) {
      file.copy(from = the_brand_file, to = brand_file, overwrite = TRUE)
    } else {
      ui_oops('No changes were made.')
    }
  } else {
    file.copy(from = the_brand_file, to = brand_file, overwrite = FALSE)
  }

  ui_info(sprintf('Copying project %s settings...', col_green('froggeR')))
  ui_done(sprintf(
    "Saved _brand.yml to system configuration: \n%s",
    brand_file
  ))

  return(invisible(NULL))
}
