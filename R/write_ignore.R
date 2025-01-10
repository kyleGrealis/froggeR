#' Create an enhanced \code{.gitignore} file
#'
#' This function creates a \code{.gitignore} file with enhanced security 
#' measures designed to help prevent accidental data leaks. The template includes 
#' comprehensive rules for common data file types and sensitive information.
#'
#' @param path Character string. Path to the project directory.
#' @param .initialize_proj Logical. TRUE only if starting a 
#'  \code{froggeR::quarto_project()}.
#' 
#' @return A \code{.gitignore} file with enhanced security rules. The file includes:\cr
#' * R data files (.RData, .rda, .rds)\cr
#' * Common data formats (CSV, Excel, text)\cr
#' * System and temporary files\cr
#' * IDE-specific files
#'
#' @details
#' If a \code{.gitignore} file already exists, the user will be prompted before any
#' overwriting occurs. The template provides substantial security enhancements
#' over basic \code{.gitignore} files.
#'
#' WARNING: Always consult your organization's data security team before using git
#' with any sensitive or protected health information (PHI). This template helps
#' prevent accidental data exposure but should not be considered a complete
#' security solution.
#'
#' @examples
#' # Create a temporary directory for testing
#' tmp_dir <- tempdir()
#' 
#' # Write the .gitignore file
#' write_ignore(path = tmp_dir)
#' 
#' # Confirm the file was created (optional, for user confirmation)
#' file.exists(file.path(tmp_dir, ".gitignore"))
#' 
#' # Clean up: Remove the created file
#' unlink(file.path(tmp_dir, ".gitignore"))
#' 
#' @export
write_ignore <- function(path = here::here(), .initialize_proj = FALSE) {

  # Validate path
  if (is.null(path) || is.na(path) || !dir.exists(path)) {
    stop("Invalid `path`. Please enter a valid project directory.")
  }
  
  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)

  # Set up full destination file path
  the_ignore_file <- file.path(path, ".gitignore")

  # Handle ignore creation/overwrite
  if (file.exists(the_ignore_file)) {
    stop('A .gitignore file already exists in the specified path.' )
  }
  
  # Get .gitignore template path
  template_path <- system.file("gists/gitignore", package = "froggeR")
  if (template_path == "") {
    stop("Could not find .gitignore template in package installation")
  }

  file.copy(from = template_path, to = the_ignore_file, overwrite = FALSE)
  ui_done("Created .gitignore")

  if (!.initialize_proj) usethis::edit_file(the_ignore_file)
  
  return(invisible(the_ignore_file))
}
