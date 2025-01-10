#' Create a project README file
#'
#' This function streamlines project documentation by a README.md file.
#'
#' @inheritParams write_ignore
#' 
#' @return Creates a comprehensive README template for project documentation.
#' @details
#' The README.md template includes structured sections for:
#' \itemize{
#'   \item Project description (study name, principal investigator, author)
#'   \item Project setup steps for reproducibility
#'   \item File and directory descriptions
#'   \item Miscellaneous project notes
#' }
#'
#' @examples
#' # Create a temporary directory for testing
#' tmp_dir <- tempdir()
#' 
#' # Write the README file
#' write_readme(path = tmp_dir)
#' 
#' # Confirm the file was created (optional, for user confirmation)
#' file.exists(file.path(tmp_dir, "README.md"))
#' 
#' # Clean up: Remove the created file
#' unlink(file.path(tmp_dir, "README.md"))
#' 
#' @export
 
write_readme <- function(path = here::here(), .initialize_proj = FALSE) {
  
  # Validate path
  if (is.null(path) || is.na(path) || !dir.exists(path)) {
    stop("Invalid `path`. Please enter a valid project directory.")
  }
  
  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)

  # Set up the full destination path
  the_readme_file <- file.path(path, 'README.md')

  # Handle README creation
  if (file.exists(the_readme_file)) {
    stop('A README.md already exists in the specified path.')
  }
  
  # Get README template path
  readme_path <- system.file("gists/README.md", package = "froggeR")
  if (readme_path == "") {
    stop("Could not find README template in package installation")
  }
  
  file.copy(from = readme_path, to = the_readme_file, overwrite = TRUE)
  ui_done("Created README.md")

  if (!.initialize_proj) usethis::edit_file(the_readme_file)
  
  return(invisible(the_readme_file))

}