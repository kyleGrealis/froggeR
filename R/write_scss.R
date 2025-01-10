#' Create a 'Quarto' SCSS file
#'
#' This function creates the \code{.scss} file so that any 'Quarto' project can be easily
#' customized with SCSS styling variables, mixins, and rules.
#'
#' @inheritParams write_ignore
#' 
#' @return A SCSS file to customize 'Quarto' styling.
#' @details
#' The function includes a robust YAML handling mechanism that safely adds new SCSS file.
#'
#' See \code{vignette("customizing-quarto", package = "froggeR")} vignette for more help.
#'
#' @examples
#' # Create a temporary directory for testing
#' tmp_dir <- tempdir()
#' 
#' # Write the SCSS file
#' write_scss(path = tmp_dir)
#' 
#' # Confirm the file was created (optional, for user confirmation)
#' file.exists(file.path(tmp_dir, "custom.scss"))
#' 
#' # Clean up: Remove the created file
#' unlink(file.path(tmp_dir, "custom.scss"))
#' 
#' @export
write_scss <- function(path = here::here(), .initialize_proj = FALSE) {

  # Validate path
  if (is.null(path) || is.na(path) || !dir.exists(path)) {
    stop("Invalid `path`. Please enter a valid project directory.")
  }
  
  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)

  # Set up full destination file path
  the_scss_file <- file.path(path, "custom.scss")

  # Handle custom.scss creation
  if (file.exists(the_scss_file)) {
    stop('A SCSS file already exists in the specified path.')
  }
  
  # Get scss template path
  template_path <- system.file("gists/custom.scss", package = "froggeR")
  if (template_path == "") {
    stop("Could not find SCSS template in package installation")
  }

  file.copy(from = template_path, to = the_scss_file, overwrite = FALSE)
  ui_done("Created custom.scss")

  if (!.initialize_proj) usethis::edit_file(the_scss_file)
  
  return(invisible(the_scss_file))

}
