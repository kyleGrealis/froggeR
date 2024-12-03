#' Create an aggressive project .gitignore file
#'
#' This function creates or updates a .gitignore file with enhanced security measures
#' designed to help prevent accidental data leaks. The template includes comprehensive
#' rules for common data file types and sensitive information.
#'
#' @param path The path to the main project level. Defaults to the
#' current working directory.
#' @return A .gitignore file with enhanced security rules. The file includes:
#' \itemize{
#'   \item R data files (.RData, .rda, .rds)
#'   \item Common data formats (CSV, Excel, text)
#'   \item System and temporary files
#'   \item IDE-specific files
#' }
#'
#' @details
#' If a .gitignore file already exists, the user will be prompted before any
#' overwriting occurs. The template provides substantial security enhancements
#' over basic .gitignore files.
#'
#' WARNING: Always consult your organization's data security team before using git
#' with any sensitive or protected health information (PHI). This template helps
#' prevent accidental data exposure but should not be considered a complete
#' security solution.
#'
#' @export
#' @examples
#' \dontrun{
#' # Create new .gitignore
#' write_ignore(path = "path/to/project")
#' }
write_ignore <- function(path = getwd()) {
  # Check if directory exists
  if (!dir.exists(path)) {
    stop("Directory does not exist")
  }
  
  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)
  
  # Define the target file path
  the_ignore_file <- file.path(path, '.gitignore')
  
  # Check for existing .gitignore
  if (file.exists(the_ignore_file)) {
    ui_info('**CAUTION!!**')
    if (ui_yeah('.gitignore found in project level directory! Would you like to overwrite it?')) {
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
        ui_done('.gitignore has been overwritten with enhanced security rules.')
      },
      error = function(e) {
        stop("Failed to download .gitignore template. Please check your internet connection.")
      })
    } else {
      ui_info("Keeping existing .gitignore")
    }
  } else {
    # Download and create new .gitignore
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
      ui_done('A new .gitignore file has been created with enhanced security rules.')
    },
    error = function(e) {
      stop("Failed to download .gitignore template. Please check your internet connection.")
    })
  }
  
  return(invisible(NULL))
}