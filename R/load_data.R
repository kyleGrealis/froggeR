#' Load Multiple Data Files into Environment
#'
#' This function loads all matching data files from a directory directly into
#' the R environment. It supports various file types and provides progress feedback
#' during loading.
#'
#' @param directory_path Character string specifying the path to the directory
#'   containing the data files.
#' @param file_type Character string specifying the type of files to load.
#'   Options include "sas7bdat", "csv", "xlsx", "rds", "dta", "sav".
#' @param recursive Logical indicating whether to search for files recursively
#'   in subdirectories. Default is TRUE.
#' @param pattern Optional character string containing a regular expression to
#'   match specific files. If provided, overrides file_type pattern matching.
#' @param loader_function Optional custom function to use for loading files.
#'   Must take a file path as input and return a data frame.
#' @param envir Environment where the loaded datasets should be placed.
#'   Default is the caller's environment.
#'
#' @return Invisibly returns NULL. Files are loaded directly into the specified
#'   environment.
#'
#' @details
#' The function automatically selects appropriate loader functions based on file
#' type:
#' * .sas7bdat - haven::read_sas
#' * .csv - readr::read_csv
#' * .xlsx - readxl::read_excel
#' * .rds - readRDS
#' * .dta - haven::read_stata
#' * .sav - haven::read_spss
#'
#' File names are converted to valid R object names using make.names().
#'
#' @examples
#' \dontrun{
#' # Load all SAS files from a directory
#' load_data("path/to/sas/files")
#'
#' # Load CSV files instead
#' load_data("path/to/csv/files", file_type = "csv")
#'
#' # Load files matching a specific pattern
#' load_data("path/to/files", pattern = "^prefix.*\\.sas7bdat$")
#'
#' # Use custom loader function
#' my_loader <- function(file) {
#'   read_csv(file, col_types = cols())
#' }
#' load_data("path/to/files", loader_function = my_loader)
#' }
#'
#' @importFrom utils txtProgressBar setTxtProgressBar
#' @importFrom tools file_path_sans_ext
#' @importFrom haven read_sas read_stata read_spss
#' @importFrom readr read_csv
#' @importFrom readxl read_excel
#'
#' @export
load_data <- function(
  directory_path,
  file_type = "sas7bdat",
  recursive = TRUE,
  pattern = NULL,
  loader_function = NULL,
  envir = parent.frame()
) {
# Start timing
start_time <- Sys.time()

# Input validation
if (!dir.exists(directory_path)) {
  stop("Directory does not exist: ", directory_path)
}

# Set up the file pattern
if (is.null(pattern)) {
  pattern <- paste0("\\.", file_type, "$")
}

# Determine the appropriate loader function
if (is.null(loader_function)) {
  loader_function <- switch(file_type,
    "sas7bdat" = haven::read_sas,
    "csv" = readr::read_csv,
    "xlsx" = function(x) readxl::read_excel(x, sheet = 1),
    "rds" = readRDS,
    "dta" = haven::read_stata,
    "sav" = haven::read_spss,
    stop("Unsupported file type: ", file_type)
  )
}

# List all matching files
files <- list.files(
  path = directory_path,
  pattern = pattern,
  full.names = TRUE,
  recursive = recursive
)

if (length(files) == 0) {
  stop("No files found matching pattern: ", pattern)
}

# Create a progress bar
message("Loading ", length(files), " files...")
pb <- txtProgressBar(min = 0, max = length(files), style = 3)

# Load each file into environment
loaded_names <- character()

for (i in seq_along(files)) {
  file_path <- files[i]
  file_name <- tools::file_path_sans_ext(basename(file_path))
  
  # Make the name valid for R
  valid_name <- make.names(file_name)
  
  # Load and assign to environment
  assign(valid_name, loader_function(file_path), envir = envir)
  loaded_names <- c(loaded_names, valid_name)
  
  # Update progress bar
  setTxtProgressBar(pb, i)
}

# Close progress bar
close(pb)

# Calculate execution time
end_time <- Sys.time()
execution_time <- difftime(end_time, start_time, units = "secs")

# Print summary
message("\nLoaded ", length(loaded_names), " files in ", 
        round(execution_time, 2), " seconds")
message("Available objects:", paste("\n -", loaded_names))

# Return nothing visibly
invisible(NULL)
}