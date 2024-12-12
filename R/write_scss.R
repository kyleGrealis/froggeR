#' Create a Quarto SCSS file
#'
#' This function creates the \code{.scss} file so that any Quarto project can easily be
#' customized with SCSS styling variables, mixins, and rules. It also updates the
#' Quarto YAML configuration to include the new style sheet.
#'
#' For more information on customizing Quarto documents with SCSS, please refer to:\cr
#' * \url{https://quarto.org/docs/output-formats/html-themes.html#customizing-themes}\cr
#' * \url{https://quarto.org/docs/output-formats/html-themes-more.html}\cr
#' * \url{https://github.com/twbs/bootstrap/blob/main/scss/_variables.scss}
#'
#' @param name The name of the scss file without extension. Default \code{name} is
#' "custom".
#' @param path The path to the main project level. Defaults to the current
#' working directory
#' @return A \code{.scss} file to customize Quarto styling. If the file is not named
#' "custom.scss", the function will also attempt to update the Quarto YAML configuration.
#'
#' @export
#' @examples
#' \donttest{
#' # Create a new temporary directory for the example
#' temp_dir <- tempdir()
#' 
#' # Create default custom.scss
#' write_scss(name = "custom", path = temp_dir)
#'
#' # Add another style sheet
#' write_scss(name = "special_theme", path = temp_dir)
#' }
write_scss <- function(name = 'custom', path = getwd()) {
  # Check if directory exists
  if (!dir.exists(path)) {
    stop('Directory does not exist')
    return(NULL)
  }
  
  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)
  
  # Define the target file path
  the_scss_file <- file.path(path, paste0(name, '.scss'))
  
  # Check for existing .scss files
  listed_files <- list.files(
    path = path,
    pattern = '\\.scss$',
    full.names = TRUE,
    recursive = FALSE
  )
  
  # Determine if we should proceed with file creation
  proceed <- TRUE
  if (length(listed_files) > 0) {
    ui_info('**CAUTION!!**')
    # Check if file with same name exists
    if (any(basename(listed_files) == paste0(name, '.scss'))) {
      ui_info(paste0('A file named "', name, '.scss" already exists!'))
      proceed <- ui_yeah('Do you want to overwrite this specific file?')
    } else {
      ui_info(paste0('Other .scss files exist but none named "', name, '.scss"'))
      proceed <- ui_yeah('Would you like to create another SCSS file?')
    }
  }
  
  # Only proceed if user confirmed
  if (proceed) {
    # Define SCSS content
    content <- sprintf('
/*-- scss:defaults --*/
// Colors
// $primary: #2c365e;  
// $body-bg: #fefefe;
// $link-color: $primary;
// Fonts
// $font-family-sans-serif: "Open Sans", sans-serif;
// $font-family-monospace: "Source Code Pro", monospace;

/*-- scss:mixins --*/

/*-- scss:rules --*/
// Custom theme rules
// .title-block {
//   margin-bottom: 2rem;
//   border-bottom: 3px solid $primary;
// }
// code {
//   color: darken($primary, 10%%);
//   padding: 0.2em 0.4em;
//   border-radius: 3px;
// }
')
    
    # Write SCSS file
    writeLines(content, the_scss_file)
    ui_done(paste0('Created ', name, '.scss'))
    
    # Update YAML after successful file creation only if not custom.scss
    if (name != 'custom') {
      .update_yaml(name)
    }
    
  } else {
    ui_info('Operation cancelled - no file was created or modified.')
  }
  
  return(invisible(NULL))
}

# Helper function for YAML updates
.update_yaml <- function(name) {
  # Find all .qmd files in current directory (case-insensitive)
  qmd_files <- list.files(pattern = '\\.qmd$', ignore.case = TRUE)
  
  if (length(qmd_files) == 0) {
    ui_info('No .qmd files found in the current directory.')
    return(invisible(NULL))
  }
  
  # Present options to user
  message('\nFound the following .qmd file(s).\nWould you like to update any?')
  for (i in seq_along(qmd_files)) {
    message(sprintf('%d. %s', i, qmd_files[i]))
  }
  files_length_plus_one <- length(qmd_files) + 1
  message(sprintf('%d. I\'m not sure, but show me how.', files_length_plus_one))
  
  # Get user choice
  choice <- readline(prompt = '#>> ')
  
  if (choice == 'q') return(invisible(NULL))
  
  choice <- as.numeric(choice)
  
  if (choice == files_length_plus_one) {
    # Show manual update instructions
    message(glue::glue(
      '\n\nHere\'s how to update your listed SCSS files in the YAML:\n',
      'format:\n',
      '  html:\n',
      '    embed-resources: true\n',
      '    theme:\n',
      '      - default\n',
      '      - custom.scss\n',
      '      - {name}.scss       # Add this line\n',
      '\n'
    ))
    return(invisible(NULL))

  } else {
    # Update single file
    file <- qmd_files[choice]
    
    # Read the file content
    qmd_content <- readr::read_file(file)
    # print(qmd_content)  # debugging
    
    # Set up original YAML content based on platform
    original_yaml <- 
      if (.Platform$OS.type == 'windows') {
        'format:\r\n  html:\r\n    embed-resources: true\r\n    theme:\r\n      - default\r\n      - custom.scss'
      } else {
        'format:\n  html:\n    embed-resources: true\n    theme:\n      - default\n      - custom.scss'
      }

    new_yaml <- glue::glue(
      '
format:
  html:
    embed-resources: true
    theme:
      - default
      - custom.scss
      - {name}.scss'
    )
    
        # Check for custom.scss and ensure we're not processing custom.scss
    if (grepl(original_yaml, qmd_content) && name != 'custom') {
      # Replace and insert new SCSS file with proper indentation
      updated_content <- stringr::str_replace(
        qmd_content,
        original_yaml,
        new_yaml
      )

      # Attempt to write changes
      tryCatch({
        readr::write_file(
          updated_content,
          file = file
        )
        ui_done(sprintf('Updated %s', file))
      }, error = function(e) {
        ui_todo(sprintf(
          'Could not update %s. Please update your YAML manually:\n', file
        ))
        message(glue::glue(
          'format:\n',
          '  html:\n',
          '    embed-resources: true\n',
          '    theme:\n',
          '      - default\n',
          '      - custom.scss\n',
          '      - {name}.scss       # Add this line\n',
          '\n'
        ))
      })
    } else if (!grepl(original_yaml, qmd_content)) {
      # Provide console feedback for manual update
      ui_todo('Could not automatically update. Please update your YAML manually:')
      message(glue::glue(
        'format:\n',
        '  html:\n',
        '    embed-resources: true\n',
        '    theme:\n',
        '      - default\n',
        '      - custom.scss\n',
        '      - {name}.scss       # Add this line\n',
        '\n'
      ))
    }
  }

  # Display reference links
  links <- glue::glue(
    '\nFor more SCSS styling options, visit:
    - https://quarto.org/docs/output-formats/html-themes.html#customizing-themes
    - https://quarto.org/docs/output-formats/html-themes-more.html
    - https://github.com/twbs/bootstrap/blob/main/scss/_variables.scss'
  )
  ui_info(links)
  
}
