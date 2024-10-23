#' Create & write values to _variables.yml
#' 
#' This function will create variables that are used in the
#' \code{froggeR::write_quarto()} custom Quarto header. Document authors can easily reuse
#' a consistent document structure and appearance throughout their project. The function
#' will look for the existence of a Quarto project \code{_variables.yml}
#' file. If one exists, the user will be asked to proceed to overwrite it.
#' 
#' @param name A Quarto project name.
#' @return A _variables.yml file. As described above, the contents of this file are
#' used in the custom Quarto header for reusability.
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
#' write_variables(name = "my_quarto_project")
#' }

write_variables <- function(name) {

  # create the file in the Quarto project
  file <- paste0(here::here(), '/', name, '/', '_variables.yml')

  abort <- FALSE

  if (file.exists(file)) {
    ui_info('**CAUTION!!**')
    abort <- ui_nope('A _variables.yml file already exists! Overwrite?')
  }

  if (!abort) {

    readline(ui_info('\n You may leave any line blank. ENTER to continue.'))

    author <- readline('Enter author name: ')
    url <- readline('Enter URL to GitHub: ')
    email <- readline('Enter email address: ')
    orcid <- readline('Enter ORCID number: ')
    roles <- readline('Enter your role ("aut" = author, etc): ')
    affiliation <- readline('Enter affiliation: ')
    keywords <- readline('Enter project keywords (i.e., research, data science): ')
    theme <- readline('Enter Quarto project theme (leave blank for default): ')
    toc_title <- readline('Enter table of contents title. Can be "Table of Contents": ')

    content <- glue::glue('
    author: {author}
    email: {email}
    orcid: {orcid}
    url: {url}
    affiliations: {affiliation}
    roles: {roles}
    keywords: {keywords}
    theme: {theme}
    toc: {toc_title}
    ')

    write(content, file = file)
    ui_done('\n_variables.yml has been created.\n\n')

  } else {
    ui_oops('\n_variables.yml was not changed.\n\n')
  }
  
}
NULL