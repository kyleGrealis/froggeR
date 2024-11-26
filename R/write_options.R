#' Write user settings to .Rprofile
#' 
#' This function interactively collects and writes user settings to the .Rprofile file
#' for use across R sessions and projects. It displays existing settings if present and
#' allows users to either keep or replace them.
#' 
#' Storing user details in the .Rprofile allows \code{froggeR} to populate the Quarto
#' YAML header using custom content across projects. This encourages a consistent style
#' and formatted output.
#' 
#' @return Invisibly returns TRUE if successful, FALSE if cancelled, errors otherwise
#' 
#' @details 
#' The function will:
#' 1. Look for .Rprofile in the user's home directory
#' 2. Display existing settings if found
#' 3. Allow user to keep or replace settings
#' 4. Backup the existing .Rprofile
#' 5. Interactively collect new settings if needed
#' 6. Write settings to .Rprofile
#' 
#' Settings are stored in a list accessible via \code{getOption("froggeR.options")}.
#' 
#' @export
#' @examples
#' \dontrun{
#' write_options()
#' }
write_options <- function() {
  # Find .Rprofile location
  rprofile_path <- path.expand('~/.Rprofile')
  
  # Check for existing froggeR.options
  existing_opts <- getOption('froggeR.options')
  
  if (!is.null(existing_opts)) {
    ui_info('Current froggeR settings:')
    # Existing settings in a formatted way
    opts_display <- paste(
      glue::glue("  name: {existing_opts$name %||% ''}"),
      glue::glue("  email: {existing_opts$email %||% ''}"),
      glue::glue("  orcid: {existing_opts$orcid %||% ''}"),
      glue::glue("  url: {existing_opts$url %||% ''}"),
      glue::glue("  affiliations: {existing_opts$affiliations %||% ''}"),
      glue::glue("  toc: {existing_opts$toc %||% ''}"),
      sep = '\n'
    )
    # Display settings and advise how to update
    cat(opts_display, '\n\n')
    message(
      glue::glue(
        '\nUse {col_blue("usethis::edit_r_profile()")} to manually update your froggeR.options'
      )
    )
    return(invisible(NULL))
  }
    
  # Backup existing .Rprofile if it exists
  if (file.exists(rprofile_path)) {
    backup_path <- paste0(rprofile_path, '.backup')
    backup_success <- file.copy(rprofile_path, backup_path, overwrite = TRUE)
    ui_done('Created .Rprofile backup')
  }
  
  # Collect new values interactively
  ui_info('Enter your profile information (press ENTER to skip):\n')
  
  name <- readline('Author name: ')
  email <- readline('Email address: ')
  orcid <- readline('ORCID (optional): ')
  url <- readline('Enter URL (optional): ')
  affiliations <- readline('Affiliation (optional): ')
  toc <- readline('Table of contents title (ENTER for default): ')
  
  # Set default 'Table of Contents' if empty
  if (toc == '') toc <- 'Table of Contents'
  
  # Create content using glue
  content <- glue::glue("

# froggeR Quarto YAML options:
options(
  froggeR.options = list(
    name = '{name}',
    email = '{email}',
    orcid = '{orcid}',
    url = '{url}',
    affiliations = '{affiliations}',
    toc = '{toc}'
  )
)\n")
  
  ###################################################################################
  # This section is used to search the .Rprofile for existing froggeR.options content
  # If content exists and the user chooses to overwrite it, the following "if"
  # statement will remove the commented line in the .Rprofile that identifies the 
  # content section ("# froggeR Quarto YAML options:") and the entire block of 
  # options.
  ###################################################################################
  # Read existing content
  existing_content <- if (file.exists(rprofile_path)) {
    readLines(rprofile_path)
  } else {
    character(0)
  }
  
  # Remove any existing froggeR.options block
  if (length(existing_content) > 0) {
    # Find where froggeR.options blocks start
    froggeR_lines <- grep('froggeR\\.options', existing_content)
    
    if (length(froggeR_lines) > 0) {
      # Remove the comment header if it exists
      comment_line <- grep('^\\s*#\\s*froggeR\\s+Quarto\\s+YAML\\s+options:', existing_content)
      if (length(comment_line) > 0) {
        existing_content <- existing_content[-comment_line]
      }
      
      # Process each froggeR.options block found (in reverse to maintain line numbers)
      for (start_line in rev(froggeR_lines)) {
        # Find the start of the options() call
        while (start_line > 1 && 
              !grepl('^\\s*options\\(', existing_content[start_line])) {
          start_line <- start_line - 1
        }
        
        # Find the matching closing parenthesis
        end_line <- start_line
        open_count <- sum(stringr::str_count(existing_content[start_line], '\\('))
        close_count <- sum(stringr::str_count(existing_content[start_line], '\\)'))
        
        # Keep going until we find the matching closing parenthesis
        while (open_count > close_count && end_line < length(existing_content)) {
          end_line <- end_line + 1
          open_count <- open_count + sum(
            stringr::str_count(existing_content[end_line], '\\(')
          )
          close_count <- close_count + sum(
            stringr::str_count(existing_content[end_line], '\\)')
          )
        }
        
        # Include any trailing empty lines
        while (end_line + 1 <= length(existing_content) && 
              trimws(existing_content[end_line + 1]) == '') {
          end_line <- end_line + 1
        }
        
        # Remove the entire block
        existing_content <- existing_content[-(start_line:end_line)]
      }
    }
  }
  
  # Write updated content
  writeLines(c(existing_content, content), rprofile_path)
  ui_done('Settings written to .Rprofile\n')
  message(
    glue::glue(
      'Use {col_blue("usethis::edit_r_profile()")} to manually change your options at any time.'
    )
  )
  ui_info(col_green('Restart R for changes to take effect.'))
  
  return(invisible(TRUE))
}
