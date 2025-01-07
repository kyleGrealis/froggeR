#' Create a project README file
#'
#' This function streamlines project documentation by creating and managing a README.md
#' file. It provides interactive prompts for existing files and maintains consistent 
#' project documentation structure.
#'
#' @param path The destination directory for the README file. Defaults to the current 
#' project's base directory (ie, value of \code{here::here()}).
#' @return Creates a comprehensive README template for project documentation.
#'
#' @details
#' The README.md template includes structured sections for:
#' \itemize{
#'   \item Project description (study name, principal investigator, author)
#'   \item Project setup steps for reproducibility
#'   \item File and directory descriptions
#'   \item Miscellaneous project notes
#' }
#'
#' If the README file already exists, the function will stop and warn the user. The 
#' templates include example documentation that can be modified to suit project needs.
#'
#' @export
#' @examples
#' # Create new README in temporary directory
#' tmp <- tempdir()
#' write_readme(path = tmp)
 
write_readme <- function(path = here::here()) {
  
  # Validate path
  if (is.null(path) || !dir.exists(path)) {
    stop("Invalid `path`. Please enter a valid project directory.")
  }
  
  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)
  
  # Get README template path first (fail fast)
  readme_path <- system.file("gists/README.md", package = "froggeR")
  if (readme_path == "") {
    stop("Could not find README template in package installation")
  }
  
  # Handle README creation/overwrite
  if (file.exists(file.path(path, 'README.md'))) {
    stop(
      'A README.md has been found in the specified directory! If you would like to ',
      'proceed, remove the existing README and rerun this function.'
    )
  }

  invisible(file.copy(
    from = readme_path,
    to = file.path(path, "README.md"),
    overwrite = TRUE
  ))
  ui_done("Created README.md")
  
  return(invisible(file.path(path, "README.md")))

}