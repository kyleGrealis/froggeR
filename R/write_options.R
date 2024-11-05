#' Write user settings to .Rprofile
#' 
#' This function interactively collects and writes user settings to the .Rprofile file
#' for use across R sessions and projects. It displays existing settings if present and
#' allows users to either keep or replace them.
#' 
#' @return Invisibly returns TRUE if successful, FALSE if cancelled, errors otherwise
#' 
#' @details 
#' The function will:
#' 1. Look for .Rprofile in the user's home directory
#' 2. Display existing settings if found
#' 3. Allow user to keep or replace settings
#' 4. Interactively collect new settings if needed
#' 5. Write settings to .Rprofile
#' 
#' Settings are stored in a list accessible via `getOption("froggeR.options")`
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
    cat('\n')  # Add blank line for readability
    
    # Display existing settings in a formatted way
    opts_display <- paste(
      glue::glue("  name: {existing_opts$name %||% ''}"),
      glue::glue("  email: {existing_opts$email %||% ''}"),
      glue::glue("  orcid: {existing_opts$orcid %||% ''}"),
      glue::glue("  url: {existing_opts$url %||% ''}"),
      glue::glue("  affiliations: {existing_opts$affiliations %||% ''}"),
      # glue::glue("  roles: {existing_opts$roles %||% ''}"),
      # glue::glue("  keywords: {existing_opts$keywords %||% ''}"),
      glue::glue("  toc: {existing_opts$toc %||% ''}"),
      sep = '\n'
    )
    cat(opts_display, '\n\n')
    
    if (ui_nope('Would you like to replace these settings?')) {
      ui_done('Keeping existing settings')
      return(invisible(FALSE))
    }
  }

  # Backup existing .Rprofile if it exists
  if (file.exists(rprofile_path)) {
    backup_path <- paste0(rprofile_path, '.backup')
    backup_success <- file.copy(rprofile_path, backup_path, overwrite = TRUE)
    
    message('\n------------------------------------------------------')
    if (backup_success) {
      ui_done(glue::glue('Backup created at {col_green(backup_path)}'))
    } else {
      ui_oops('Failed to create backup! Please check file permissions.')
      return(invisible(FALSE))
    }
    message('------------------------------------------------------\n')
  }
  
  # Collect new values interactively
  message(
    glue::glue(
      '\nInput your profile information. This will be used to populate the Quarto header in any {col_green("froggeR")} Quarto document throughout your projects.'
    )
  )
  enter_msg <- glue::glue(
    'You may leave any line blank by pressing {col_blue("ENTER")} to skip.'
  )
  ui_info(enter_msg)
  message('\n------------------------------------------------------')
  
  name <- readline('Enter author name: ')
  email <- readline('Enter email address: ')
  orcid <- readline('Enter ORCID number: ')
  url <- readline('Enter URL to GitHub: ')
  affiliations <- readline('Enter affiliation: ')
  # roles <- readline('Enter your role ("aut" = author, etc): ')
  # keywords <- readline('Enter project keywords (i.e., research): ')
  # toc <- readline('Enter table of contents title (default: "Table of Contents"): ')
  message('Enter table of contents title.')
  toc <- readline('The default is "Table of Contents": ')
  
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
  
  # Read existing content
  existing_content <- if (file.exists(rprofile_path)) {
    readLines(rprofile_path)
  } else {
    character(0)
  }
  
  # Remove any existing froggeR.options block
  if (length(existing_content) > 0) {
    # Find where froggeR.options blocks start
    froggeR_lines <- grep("froggeR\\.options", existing_content)
    
    if (length(froggeR_lines) > 0) {
      # Also find and remove the comment line if it exists
      comment_line <- grep("^\\s*#\\s*froggeR\\s+Quarto\\s+YAML\\s+options:", existing_content)
      if (length(comment_line) > 0) {
        existing_content <- existing_content[-comment_line]
      }
      
      for (start_line in rev(froggeR_lines)) {
        # Look backwards for the options( start
        while (start_line > 1 && !grepl("^\\s*options\\(", existing_content[start_line])) {
          start_line <- start_line - 1
        }
        
        # Look forwards for the closing parenthesis
        end_line <- start_line
        open_count <- sum(stringr::str_count(existing_content[start_line], "\\("))
        close_count <- sum(stringr::str_count(existing_content[start_line], "\\)"))
        
        while (open_count > close_count && end_line < length(existing_content)) {
          end_line <- end_line + 1
          open_count <- open_count + sum(stringr::str_count(existing_content[end_line], "\\("))
          close_count <- close_count + sum(stringr::str_count(existing_content[end_line], "\\)"))
        }
        
        # Remove entire block including trailing whitespace
        while (end_line + 1 <= length(existing_content) && 
               trimws(existing_content[end_line + 1]) == "") {
          end_line <- end_line + 1
        }
        
        existing_content <- existing_content[-(start_line:end_line)]
      }
    }
  }
  
  # Write updated content
  writeLines(c(existing_content, content), rprofile_path)
  
  message('------------------------------------------------------')
  ui_done('Settings successfully written to .Rprofile\n')

  if (ui_yeah('Would you like to view your updated .Rprofile?')) {
    usethis::edit_r_profile()
  }
  message(
    glue::glue(
      'Use {col_blue("usethis::edit_r_profile()")} to manually change your options at any time.'
    )
  )
  ui_info(col_green('Restart R for changes to take effect.'))
  
  invisible(TRUE)
}
NULL
