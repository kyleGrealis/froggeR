#' Create an aggressive project \code{.gitignore} file
#'
#' This function creates or updates a \code{.gitignore} file with enhanced security 
#' measures designed to help prevent accidental data leaks. The template includes 
#' comprehensive rules for common data file types and sensitive information.
#'
#' @param path The path to the main project level. Defaults to the current project's base
#'   directory (ie, value of \code{here::here()}).
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
#' @export
#' @examples
#' \donttest{
#' # Create new .gitignore
#' write_ignore(path = tempdir())
#' }
#' 
write_ignore <- function(path = here::here()) {
 
  # Validate path
  if (is.null(path) || !dir.exists(path)) {
    stop("Invalid `path`. Please enter a valid project directory.")
  }
  
  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)
  
  # Define the target file path
  the_ignore_file <- file.path(path, '.gitignore')
  
  # Check for existing .gitignore
  if (file.exists(the_ignore_file)) {
    if (interactive()) {
      ui_info('**CAUTION!!**')
      proceed <- ui_yeah('.gitignore found in project level directory! Would you like to overwrite it?')
    } else {
      stop('A .gitignore has been found in the project.')
    }
  }

  if (!(file.exists(the_ignore_file)) || proceed) {
    # Download and create .gitignore
    tryCatch({
      download.file(
        url = paste0(
          'https://gist.githubusercontent.com/RaymondBalise/',
          '1978fb42fc520ca57f670908e111585e/',
          'raw/e0b0ac8c7726f488fcc52b3b8269e449cbf33c15/.gitignore'
        ),
        destfile = the_ignore_file,
        quiet = TRUE
      )
      ui_done('Created .gitignore with enhanced security rules.')
    },
    error = function(e) {
      stop("Failed to download .gitignore template. Please check your internet connection.")
    })
  } else {
    ui_oops("No changes to .gitignore")
  }
  
  return(invisible(the_ignore_file))
}
