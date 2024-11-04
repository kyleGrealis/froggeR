#' Load Multiple Data Files into Environment
#'
#' This function loads all supported data files from a directory directly into
#' the R environment. It automatically detects file types and provides progress feedback
#' during loading.
#'
#' @param directory_path Character string specifying the path to the directory
#'   containing the data files.
#' @param recursive Logical indicating whether to search for files recursively
#'   in subdirectories. Default is TRUE.
#' @param pattern Optional character string containing a regular expression to
#'   match specific files. If provided, overrides automatic file type detection.
#' @param loader_function Optional custom function to use for loading files.
#'   Must take a file path as input and return a data frame.
#' @param envir Environment where the loaded datasets should be placed.
#'   Default is the caller's environment.
#'
#' @return Invisibly returns NULL. Files are loaded directly into the specified
#'   environment.
#'
#' @details
#' The function automatically detects and loads the following file types:
#' * .rda/.RData - load
#' * .rds - readRDS
#' * .sas7bdat - haven::read_sas
#' * .csv - readr::read_csv
#' * .xlsx - readxl::read_excel
#' * .dta - haven::read_stata
#' * .sav - haven::read_spss
#'
#' File names are converted to valid R object names using make.names().
#'
#' @examples
#' \dontrun{
#' # Load all supported files from a directory
#' load_data("path/to/data")
#'
#' # Load files matching a specific pattern
#' load_data("path/to/files", pattern = "^prefix.*")
#'
#' # Use custom loader function
#' my_loader <- function(file) {
#'   read_csv(file, col_types = cols())
#' }
#' load_data("path/to/files", loader_function = my_loader)
#' }
#'
#' @importFrom utils txtProgressBar setTxtProgressBar
#' @importFrom tools file_path_sans_ext file_ext
#' @importFrom haven read_sas read_stata read_spss
#' @importFrom readr read_csv
#' @importFrom readxl read_excel
#'
#' @export
load_data <- function(
  directory_path,
  recursive = TRUE,
  pattern = NULL,
  loader_function = NULL,
  envir = parent.frame()
) {
# Start timing
start_time <- Sys.time()

# Input validation
if (!dir.exists(directory_path)) {
  stop('Directory does not exist: ', directory_path)
}

# Set up supported file types pattern if no pattern provided
if (is.null(pattern)) {
  pattern <- '\\.(rda|RData|rds|sas7bdat|csv|xlsx|dta|sav)$'
}

# List all matching files
files <- list.files(
  path = directory_path,
  pattern = pattern,
  full.names = TRUE,
  recursive = recursive
)

if (length(files) == 0) {
  stop('No supported files found in directory')
}

# Create a progress bar
message('Loading ', length(files), ' files...')
pb <- txtProgressBar(min = 0, max = length(files), style = 3)

# Load each file into environment
loaded_names <- character()
skipped_files <- character()

for (i in seq_along(files)) {
  file_path <- files[i]
  file_name <- tools::file_path_sans_ext(basename(file_path))
  file_ext <- tolower(tools::file_ext(file_path))
  
  # Make the name valid for R
  valid_name <- make.names(file_name)
  
  # Handle loading based on file type
  if (is.null(loader_function)) {
    if (file_ext %in% c('rda', 'rdata', 'rds')) {
      # For .rda/.RData files, load directly into environment
      tryCatch({
        load(file_path, envir = envir)
        loaded_names <- c(loaded_names, valid_name)
      }, error = function(e) {
        skipped_files <- c(skipped_files, basename(file_path))
      })
    } else {
      # For other files, use appropriate loader
      current_loader <- switch(file_ext,
        'sas7bdat' = haven::read_sas,
        'csv' = readr::read_csv,
        'xlsx' = function(x) readxl::read_excel(x, sheet = 1),
        'dta' = haven::read_stata,
        'sav' = haven::read_spss,
        NULL
      )
      
      if (is.null(current_loader)) {
        skipped_files <- c(skipped_files, basename(file_path))
        next
      }
      
      # Try to load and assign to environment
      tryCatch({
        assign(valid_name, current_loader(file_path), envir = envir)
        loaded_names <- c(loaded_names, valid_name)
      }, error = function(e) {
        skipped_files <- c(skipped_files, basename(file_path))
      })
    }
  } else {
    # Use custom loader function
    tryCatch({
      assign(valid_name, loader_function(file_path), envir = envir)
      loaded_names <- c(loaded_names, valid_name)
    }, error = function(e) {
      skipped_files <- c(skipped_files, basename(file_path))
    })
  }
  
  # Update progress bar
  setTxtProgressBar(pb, i)
}

# Close progress bar
close(pb)

# Calculate execution time
end_time <- Sys.time()
execution_time <- difftime(end_time, start_time, units = 'secs')

# Print summary
message('\nLoaded ', length(loaded_names), ' files in ', 
        round(execution_time, 2), ' seconds')
message('Available objects:', paste('\n -', loaded_names))

if (length(skipped_files) > 0) {
  message('\nSkipped files:', paste('\n -', skipped_files))
}

# Return nothing visibly
invisible(NULL)
}