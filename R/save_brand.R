#' Save Brand Configuration to Global froggeR Settings
#'
#' This function saves the current \code{_brand.yml} file from an existing froggeR
#' Quarto project to your global (system-wide) froggeR configuration. This allows
#' you to reuse brand settings across multiple projects.
#'
#' @param save_logos Logical. Should logo files from the \code{logos} directory also
#'   be saved to global configuration? Default is \code{TRUE}.
#'
#' @return Invisibly returns \code{NULL} after saving configuration file.
#'
#' @details
#' This function:
#' \itemize{
#'   \item Reads the project-level \code{_brand.yml} file
#'   \item Saves it to your system-wide froggeR config directory
#'   \item Optionally copies the \code{logos} directory for reuse in future projects
#'   \item Prompts for confirmation if a global configuration already exists
#' }
#'
#' The saved configuration is stored in \code{rappdirs::user_config_dir('froggeR')}
#' and will automatically be used in new froggeR projects created with
#' \code{\link{init}} or \code{\link{write_brand}}.
#'
#' @examples
#' # Save brand settings from current project to global config
#' if (interactive()) save_brand()
#'
#' # Save brand settings but skip logos
#' if (interactive()) save_brand(save_logos = FALSE)
#'
#' @seealso \code{\link{write_brand}}, \code{\link{save_variables}}
#' @export
save_brand <- function(save_logos = TRUE) {
  # Normalize the path for consistency
  path <- normalizePath(here::here(), mustWork = TRUE)

  # Set up full origin file path
  the_brand_file <- file.path(path, "_brand.yml")

  # Check for project-level _brand.yml
  if (!file.exists(the_brand_file)) {
    ui_oops(
      sprintf(
        "No current _brand.yml file exists in this project. Run %s to create it.",
        col_green("froggeR::write_brand()")
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
    "A system-level %s configuration was found. Overwrite?",
    col_green("froggeR")
  )

  # Ensure config directory exists
  fs::dir_create(config_path)

  # Save the config file or prompt the user to overwrite
  if (system_settings) {
    if (ui_yeah(overwrite_prompt)) {
      file.copy(from = the_brand_file, to = brand_file, overwrite = TRUE)
      ui_info(sprintf("Copying project %s settings...", col_green("froggeR")))
      ui_done(sprintf("Saved _brand.yml to system configuration: \n%s", brand_file))
    } else {
      ui_oops("No changes were made.")
    }
  } else {
    file.copy(from = the_brand_file, to = brand_file, overwrite = FALSE)
    ui_info(sprintf("Copying project %s settings...", col_green("froggeR")))
    ui_done(sprintf("Saved _brand.yml to system configuration: \n%s", brand_file))
  }

  # Quarto brand logos directory
  local_logos <- file.path(path, "logos")
  # Does local directory exist?
  logos_dir <- dir.exists(local_logos)
  # No logos directory prompt
  no_local_logos <- "No project-level 'logos' directory was found. Skipping."
  # Does the froggeR logos directory exist?
  frogger_logos <- dir.exists(file.path(config_path, "logos"))
  # Overwrite config logos prompt
  config_logos_overwrite <- sprintf(
    "A system-level %s configuration was found. Overwrite?",
    col_green("froggeR logos")
  )

  # Save the local logos directory to froggeR configs
  if (save_logos) {
    # No logos directory
    if (!logos_dir) {
      ui_oops(no_local_logos)
    } else if (frogger_logos) {
      # Local & config exists -- ask to overwrite
      if (ui_yeah(config_logos_overwrite)) {
        fs::dir_copy(local_logos, file.path(config_path, "logos"), overwrite = TRUE)
        ui_done("Saved logos directory to system configuration")
      } else {
        ui_oops("Logos directory not copied.")
      }
    } else {
      fs::dir_copy(local_logos, file.path(config_path, "logos"), overwrite = TRUE)
      ui_done("Saved logos directory to system configuration")
    }
  }

  return(invisible(NULL))
}
