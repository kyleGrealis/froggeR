#' Create a Quarto SCSS file
#'
#' This function creates the \code{.scss} file so that any Quarto project can be easily
#' customized with SCSS styling variables, mixins, and rules.
#'
#' @details
#' The function includes a robust YAML handling mechanism that:
#' \itemize{
#'   \item Safely adds new project-level SCSS files without disrupting existing ones
#'   \item Provides instructions for adding SCSS files to Quarto YAML
#' }
#'
#' For more information on customizing Quarto documents with SCSS, please refer to
#' \url{https://quarto.org/docs/output-formats/html-themes.html#customizing-themes},
#' \url{https://quarto.org/docs/output-formats/html-themes-more.html}, and
#' \url{https://github.com/twbs/bootstrap/blob/main/scss/_variables.scss} will provide
#' you with over 1500 lines of SCSS variables.
#'
#' @param name The name of the scss file without extension. Default \code{name} is
#' "custom".
#' @param path The destination directory for the SCSS file. Defaults to the current 
#' project's base directory (ie, value of \code{here::here()}).
#' 
#' @return A \code{.scss} file to customize Quarto styling. If \code{name} is not
#' "custom", the function will also attempt to update the Quarto document's YAML to
#' include the new SCSS file while preserving any existing SCSS configurations.
#'
#' @export
#' @examples
#' \donttest{
#'   # Create the default custom.scss in a temporary directory
#'   write_scss(name = "custom", path = tempdir())
#'
#'   # Add another SCSS file and update YAML in the temporary directory
#'   write_scss(name = "special_theme", path = tempdir())
#' }

write_scss <- function(name = "custom", path = here::here()) {
  
  # Argument validation
  if (!is.character(name) || length(name) != 1 || name == "") {
    stop("Invalid `name`. Please provide a valid name for the SCSS file.")
  }
  if (tolower(name) %in% c("default", "quarto", "html")) {
    stop("Invalid `name`. Please avoid using reserved names like 'default', 'quarto', or 'html'.")
  }
  if (is.null(path) || !dir.exists(path)) {
    stop("Invalid `path`. Please ensure the directory exists and is accessible.")
  }

  # Set SCSS file name
  name <- tools::file_path_sans_ext(name)
  
  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)
  
  # Define the target file path
  the_scss_file <- file.path(path, paste0(name, ".scss"))

  # Check existing .scss files
  if (file.exists(the_scss_file)) {
    stop(paste0('A file named "', name, '.scss" already exists!'))
  }

  # Write the SCSS file
  scss_template <- .generate_scss_template()
  writeLines(scss_template, the_scss_file)


  if (interactive()) {
    ui_done(paste0("Created ", name, ".scss"))
    if (name != "custom") { .update_yaml_message(name) }
    # ui_info(sprintf(
    #   'Run %s for more information on SCSS styling', col_green('`?froggeR::write_scss')
    # ))
  }

  return(invisible(the_scss_file))

}

# Helper functions
.generate_scss_template <- function() {
  glue::glue(
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
}

.update_yaml_message <- function(name) {

  new_yaml <- glue::glue(
"
format:
  html:
    embed-resources: true
    theme:
      - default
      - custom.scss
      - {name}.scss     # Add this line"
  )
  
  ui_info(glue::glue(
    "\nUpdate your Quarto document YAML to include the new SCSS file:\n",
    new_yaml
  ))
}
