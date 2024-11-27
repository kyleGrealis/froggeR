#' Create a Quarto SCSS file
#' 
#' This function creates the \code{.scss} file so that any Quarto project can be easily 
#' customized with SCSS styling variables, mixins, and rules.
#' 
#' For more information on customizing Quarto documents with SCSS, please refer to
#' \url{https://quarto.org/docs/output-formats/html-themes.html#customizing-themes} and
#' \url{https://quarto.org/docs/output-formats/html-themes-more.html}. If you really
#' would like to go down a rabbit hole: 
#' \url{https://github.com/twbs/bootstrap/blob/main/scss/_variables.scss} will provide
#' you with over 1500 lines of SCSS variables!
#' 
#' @param name The name of the scss file without extension.
#' @param path The path to the main project level. Defaults to the current
#' working directory
#' @return A \code{.scss} file to customize Quarto styling.
#' 
#' @export
#' @examples
#' \dontrun{
#' write_scss(name = "custom", path = "path/to/project")
#' }

write_scss <- function(name = 'custom', path = getwd()) {

  # Check if directory exists
  if (!dir.exists(path)) {
    stop('Directory does not exist') 
  }

  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)

  # Warn user if a .scss file is found in project
  listed_files <- list.files(
    path = path, 
    pattern = '\\.scss$', 
    full.names = TRUE, 
    recursive = FALSE
  )
  
  if (length(listed_files) > 0) {
    ui_info('**CAUTION!!**')
    # Check if file with same name exists
    if (any(basename(listed_files) == paste0(name, '.scss'))) {
      ui_info(paste0('A file named "', name, '.scss" already exists!'))
      abort <- ui_nope('Do you want to overwrite this specific file?')
    } else {
      ui_info(paste0('Other .scss files exist but none named "', name, '.scss"'))
      abort <- ui_nope('Proceed with creating another SCSS file?')
    }
  }
 
  # Define SCSS content
  content <- glue::glue(
'/*-- scss:defaults --*/
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
  the_scss_file <- file.path(path, paste0(name, '.scss'))
  writeLines(content, the_scss_file)
  ui_done(paste0('Created ', name, '.scss'))

  # Display reference links
  links <- glue::glue(
    'For more SCSS styling options, visit:
    - https://quarto.org/docs/output-formats/html-themes.html#customizing-themes
    - https://quarto.org/docs/output-formats/html-themes-more.html
    - https://github.com/twbs/bootstrap/blob/main/scss/_variables.scss'
  )
  ui_info(links)

  return(invisible(NULL))

 }
