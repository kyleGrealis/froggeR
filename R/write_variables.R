#' Create & write values to _variables.yml
#' 
#' This function will create variables that are used in the
#' \code{froggeR::write_quarto()} custom Quarto header. Document authors can easily reuse
#' a consistent document structure and appearance throughout their project. The function
#' will look for the existence of a Quarto project \code{_variables.yml}
#' file. If one exists, the user will be asked to proceed to overwrite it.
#' 
#' @param path A Quarto project name or other folder. Defaults to the current
#' working directory.
#' @return A _variables.yml file.
#' 
#' NOTE: Be sure to inspect the contents that are created. You can choose to add more
#' key:value pairs and use them in the Quarto header or anywhere else within the
#' Quarto document. Refer to \url{https://quarto.org/docs/authoring/variables.html} 
#' for more details on how to use custom variables.
#' 
#' WARNING: Altering the names of existing key:value pairs may cause unintended
#' consequences, so proceed with caution!
#' 
#' @export
#' @examples
#' \dontrun{
#' write_variables(path = "path/to/project")
#' }

write_variables <- function(path = getwd()) {

  # Check if directory exists
  if (!dir.exists(path)) {
    # Exit if directory does not exist
    stop("Directory does not exist") 
    return(NULL)
  } 

  # Normalize the path for consistency
  path <- normalizePath(path, mustWork = TRUE)

  # create the file in the Quarto project
  file <- file.path(path, '_variables.yml')

  abort <- FALSE

  if (file.exists(file)) {
    ui_info('**CAUTION!!**')
    abort <- ui_nope('A _variables.yml file already exists! Overwrite?')
  }

  if (!abort) {

    # Write user information to .Rprofile:
    froggeR::write_options()

    # Write froggeR.options into _variable.yml
    opts <- getOption('froggeR.options')
    if (!is.null(opts)) {
      content <- glue::glue('
        author: {opts$name}
        email: {opts$email}
        orcid: {opts$orcid}
        url: {opts$url}
        affiliations: {opts$affiliations}
        toc: {opts$toc}
      ')
    }

    write(content, file = file)
    message('------------------------------------------------------')
    ui_done('\n_variables.yml has been created.\n\n')

  } else {
    ui_oops('\n_variables.yml was not changed.\n\n')
  }
  
}
NULL