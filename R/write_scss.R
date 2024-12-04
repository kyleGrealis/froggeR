#' Create a Quarto SCSS file
#'
#' This function creates the \code{.scss} file so that any Quarto project can be easily
#' customized with SCSS styling variables, mixins, and rules. It also updates the
#' Quarto YAML configuration to include the new style sheet.
#'
#' For more information on customizing Quarto documents with SCSS, please refer to:
#' 
#' - \url{https://quarto.org/docs/output-formats/html-themes.html#customizing-themes}
#' - \url{https://quarto.org/docs/output-formats/html-themes-more.html}. 
#' - \url{https://github.com/twbs/bootstrap/blob/main/scss/_variables.scss}
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
#' \dontrun{
#' # Create default custom.scss
#' write_scss(name = "custom", path = "path/to/project")
#' 
#' # Add another style sheet
#' write_scss(name = "special_theme", path = "path/to/project")
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
    content <- glue::glue(
      '/*-- scss:defaults --*/
      // Colors
      // $primary: #2c365e;  
      // $body-bg: #fefefe;
      // $link-color: $primary;
      // Fonts
      // $font-family-sans-serif: "Open Sans", sans-serif;
      // $font-family-monospace: "Source Code Pro", monospace;\n\n
      /*-- scss:mixins --*/\n\n
      /*-- scss:rules --*/
      // Custom theme rules
      // .title-block {{
      //   margin-bottom: 2rem;
      //   border-bottom: 3px solid $primary;
      // }}
      // code {{
      //   color: darken($primary, 10%);
      //   padding: 0.2em 0.4em;
      //   border-radius: 3px;
      // }}'
    )
    
    # Write SCSS file
    writeLines(content, the_scss_file)
    ui_done(paste0('Created ', name, '.scss'))
    
    # Update YAML after successful file creation only if not custom.scss
    if (name != "custom") {
      .update_yaml(name)
    }
    
    # Display reference links
    links <- glue::glue(
      'For more SCSS styling options, visit:
      - https://quarto.org/docs/output-formats/html-themes.html#customizing-themes
      - https://quarto.org/docs/output-formats/html-themes-more.html
      - https://github.com/twbs/bootstrap/blob/main/scss/_variables.scss'
    )
    ui_info(links)
  } else {
    ui_info("Operation cancelled - no file was created or modified.")
  }
  
  return(invisible(NULL))
}

# Helper function for YAML updates
.update_yaml <- function(name) {
  # Check if analysis.qmd exists
  if (!file.exists("analysis.qmd")) {
    ui_info("No analysis.qmd file found in the current directory.")
    return(invisible(NULL))
  }
  
  # Read the file content
  qmd_content <- readr::read_file("analysis.qmd")
  
  # Set up original & new YAML content
  original_yaml <- glue::glue(
    '
    format:
      html:
        embed-resources: true
        theme:
          - default
          - custom.scss'
  )
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
  if (grepl(original_yaml, qmd_content) && name != "custom") {
    # Replace and insert new SCSS file with proper indentation
    updated_content <- stringr::str_replace(
      qmd_content,
      original_yaml,
      new_yaml
    )
    
    # Update the YAML
    readr::write_file(
      updated_content,
      file = "analysis.qmd"
    )
    ui_done('The YAML in analysis.qmd has been updated.')
  } else if (!grepl(original_yaml, qmd_content)) {
    # Provide console feedback
    ui_info(glue::glue(
      'Be sure to update your listed SCSS files in the YAML manually:\n',
      'format:\n',
      '  html:\n',
      '    embed-resources: true\n',
      '    theme:\n',
      '      - default\n',
      '      - custom.scss\n',
      '      - {name}.scss       # Add this line\n'
    ))
  }
}