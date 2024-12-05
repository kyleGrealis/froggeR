#' Manage froggeR settings
#'
#' Check, display, or initialize froggeR settings for Quarto documents. Settings are
#' stored in your \code{.Rprofile} for persistence and made available immediately in the
#' current session.
#'
#' When run interactively, provides a menu to:\cr
#' * Check current settings\cr
#' * Initialize settings (first-time setup)\cr
#' * Get help updating settings\cr
#' * Cancel
#'
#' When settings are created, they are:\cr
#' * Stored in your \code{.Rprofile} for persistence across sessions\cr
#' * Made available immediately in the current session\cr
#' * Used to populate Quarto document variables
#'
#' The following is added to your \code{.Rprofile} when settings are saved:
#'
#' \preformatted{options(
#'   froggeR.options = list(
#'     name = "Your Name",
#'     email = "your.email@example.com",
#'     orcid = "0000-0000-0000-0000",  # optional
#'     url = "https://github.com/username",  # optional
#'     affiliations = "Your Institution",  # optional
#'     toc = "Table of Contents"  # defaults if empty
#'   )
#' )}
#'
#' @param interactive If TRUE (default), provides menu-driven interface. Set to FALSE
#' for non-interactive use by other functions.
#' @return Invisibly returns the current settings list
#'
#' @export
#' @examples
#' \dontrun{
#' # Interactive menu for users
#' froggeR_settings()
#'
#' # Get current settings
#' settings <- froggeR_settings(interactive = FALSE)
#' }
froggeR_settings <- function(interactive = TRUE) {
  # Get current settings if they exist
  settings <- getOption('froggeR.options')
  
  if (interactive) {
    # Interactive menu for users
    choice <- utils::menu(
      c("Check current settings", 
        "Initialize settings (first-time setup)",
        "Get help updating settings",
        "Cancel"),
      title = glue::glue(
        'Please select from the following {col_green("froggeR")} settings options:'
      )
    )
    
    switch(choice,
      # 1: Display current settings
      {
        if (is.null(settings)) {
          ui_oops(
            glue::glue(
              'No {col_green("froggeR")} settings found.'
            )
          )
          return(invisible(NULL))
        }
        display_settings(settings)
      },
      # 2: Initialize settings
      {
        if (!is.null(settings)) {
          ui_oops('Settings already exist. To update them, use option 3 for guidance.')
          return(invisible(NULL))
        }
        settings <- collect_settings()
        .write_options(settings)
        ui_done('Settings initialized successfully!')
      },
      # 3: Help updating settings
      {
        message('\nTo update your settings:')
        message(glue::glue('1. Run: {col_blue("usethis::edit_r_profile()")}'))
        message('2. Carefully edit your settings in the .Rprofile file')
        message('3. Save and close the file')
        message('4. Restart your R session')
        message('\nNeed help? Visit: https://github.com/kyleGrealis/froggeR')
      },
      # 4: Cancel
      {
        return(invisible(NULL))
      }
    )
  } else {
    # Non-interactive mode for internal use
    if (is.null(settings)) {
      settings <- collect_settings()
      .write_options(settings)
    }
  }
  
  invisible(settings)
}

# Helper function to collect settings from user
collect_settings <- function() {
  list(
    name = readline('Author name: '),
    email = readline('Email address: '),
    orcid = readline('ORCID (optional): '),
    url = readline('Enter URL (optional): '),
    affiliations = readline('Affiliation (optional): '),
    toc = { 
      toc <- readline('Table of contents title (ENTER for default): ')
      if (toc == '') 'Table of Contents' else toc
    }
  )
}

# Helper function to display current settings
display_settings <- function(settings) {
  ui_info(glue::glue('Current {col_green("froggeR")} settings:'))
  message(glue::glue(
'\n
  name: {settings$name}
  email: {settings$email}
  orcid: {settings$orcid}
  url: {settings$url}
  affiliations: {settings$affiliations}
  toc: {settings$toc}

'
  ))
}

# Internal function to write settings to .Rprofile
.write_options <- function(settings) {
  # Find .Rprofile location
  rprofile_path <- path.expand('~/.Rprofile')
  
  # Backup existing .Rprofile if it exists
  if (file.exists(rprofile_path)) {
    backup_path <- paste0(rprofile_path, '.backup')
    file.copy(rprofile_path, backup_path, overwrite = TRUE)
    ui_done('Created .Rprofile backup')
  }
  
  # Create content for .Rprofile
  content <- glue::glue('
# froggeR Quarto YAML options:
options(
  froggeR.options = list(
    name = "{settings$name}",
    email = "{settings$email}",
    orcid = "{settings$orcid}",
    url = "{settings$url}",
    affiliations = "{settings$affiliations}",
    toc = "{settings$toc}"
  )
)
'
  )
  
  # Read existing content
  existing_content <- if (file.exists(rprofile_path)) {
    readLines(rprofile_path)
  } else {
    character(0)
  }
  
    # Remove any existing froggeR.options block
  if (length(existing_content) > 0) {
    # Find the start of any froggeR blocks
    comment_lines <- grep("^\\s*#\\s*froggeR\\s+Quarto\\s+YAML\\s+options:", existing_content)
    options_lines <- grep("^\\s*options\\s*\\(", existing_content)
    
    # For each potential block start
    for (start_line in c(comment_lines, options_lines)) {
      if (start_line <= length(existing_content)) {
        # Find the matching closing parenthesis
        bracket_count <- 0
        end_line <- start_line
        
        # Look for complete block (handles nested parentheses)
        for (i in start_line:length(existing_content)) {
          line <- existing_content[i]
          bracket_count <- bracket_count + 
            stringr::str_count(line, "\\(") - 
            stringr::str_count(line, "\\)")
          
          if (bracket_count <= 0) {
            end_line <- i
            break
          }
        }
        
        # Remove the block if it contains froggeR settings
        block_text <- paste(existing_content[start_line:end_line], collapse = " ")
        if (grepl("froggeR\\.options|name\\s*=|email\\s*=", block_text)) {
          existing_content <- existing_content[-(start_line:end_line)]
        }
      }
    }
    
    # Remove any duplicate closing parentheses
    existing_content <- existing_content[!grepl("^\\s*\\)\\s*$", existing_content)]
    
    # Remove any empty lines at the end
    while (length(existing_content) > 0 && grepl("^\\s*$", existing_content[length(existing_content)])) {
      existing_content <- existing_content[-length(existing_content)]
    }
  }
  
  # Write updated content
  writeLines(c(existing_content, content), rprofile_path)
  
  # Set options for current session
  options(froggeR.options = settings)
}

# Internal function to write variables.yml
.write_variables <- function(path, settings) {
  content <- glue::glue(
'author: {settings$name}
email: {settings$email}
orcid: {settings$orcid}
url: {settings$url}
affiliations: {settings$affiliations}
toc: {settings$toc}'
  )
  
  writeLines(content, file.path(path, '_variables.yml'))
  ui_done('Created _variables.yml')
}
