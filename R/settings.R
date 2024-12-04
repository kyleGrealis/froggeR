#' Manage froggeR settings
#'
#' Check, display, or update froggeR settings for Quarto documents. Settings are
#' stored in your \code{.Rprofile} for persistence and made available immediately in the
#' current session.
#'
#' When run interactively, provides a menu to:\cr
#' * Check current settings\cr
#' * Update settings\cr
#' * Cancel
#'
#' When settings are created or updated, they are:\cr
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
      c("Check and display settings", 
        "Update settings",
        "Cancel"),
      title = "\nWelcome! Would you like to:"
    )
    
    switch(choice,
      # 1: Display current settings
      {
        if (is.null(settings)) {
          ui_info('No froggeR settings found.')
          return(invisible(NULL))
        }
        display_settings(settings)
      },
      # 2: Update settings
      {
        settings <- collect_settings()
        .write_options(settings)
        ui_done('Settings updated successfully!')
      },
      # 3: Cancel
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
  ui_info('Current froggeR settings:')
  cat(
    glue::glue(
      '  name: {settings$name}',
      '  email: {settings$email}',
      '  orcid: {settings$orcid}',
      '  url: {settings$url}',
      '  affiliations: {settings$affiliations}',
      '  toc: {settings$toc}',
      .sep = '\n'
    ),
    '\n'
  )
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
    # Find and remove existing blocks
    comment_line <- grep("^\\s*#\\s*froggeR\\s+Quarto\\s+YAML\\s+options:", existing_content)
    if (length(comment_line) > 0) existing_content <- existing_content[-comment_line]
    
    froggeR_lines <- grep("froggeR\\.options", existing_content)
    if (length(froggeR_lines) > 0) {
      existing_content <- existing_content[-froggeR_lines]
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
