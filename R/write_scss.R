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
#' @param path The path to the main project level. Defaults to returned value
#' from \code{here::here()}.
#' @param name The name of the scss file without extension.
#' @return A \code{.scss} file to customize Quarto styling.
#' 
#' @export
#' @examples
#' \dontrun{
#' write_scss(path = here::here(), name = "custom")
#' }

write_scss <- function(path = here::here(), name = 'custom') {

  the_scss_file <- paste0(path, '/', name, '.scss')
  abort <- FALSE
 
  content <- glue::glue(
  '/*-- scss:defaults --*/
  // Colors
  // $primary: #2c365e;  
  // $body-bg: #fefefe;
  // $link-color: $primary;
  // $code-block-bg: #f8f9fa;
  
  // Fonts
  // $font-family-sans-serif: "Roboto", -apple-system, sans-serif;
  // $font-family-monospace: "Fira Code", monospace;
  // $headings-font-weight: 500;
  
  // Layout
  // $grid-breakpoint-lg: 1000px;
  // $container-max-width: 1200px;
  // $navbar-height: 60px;
  
  /*-- scss:mixins --*/
  // @mixin card-shadow {{
  //   box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  //   transition: box-shadow 0.3s ease;
  //   &:hover {{
  //     box-shadow: 0 6px 8px rgba(0, 0, 0, 0.15);
  //   }}
  // }}
  
  // @mixin responsive-font($min-size, $max-size) {{
  //   font-size: clamp($min-size, 2vw, $max-size);
  // }}
  
  /*-- scss:rules --*/
  // Custom theme rules
  // .title-block {{
  //   margin-bottom: 2rem;
  //   border-bottom: 3px solid $primary;
  // }}
  
  // .callout {{
  //   @include card-shadow;
  //   padding: 1.25rem;
  //   margin: 1rem 0;
  //   border-left: 4px solid $primary;
  // }}
  
  // code {{
  //   color: darken($primary, 10%);
  //   padding: 0.2em 0.4em;
  //   border-radius: 3px;
  // }}'
  )
 
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
      abort <- ui_nope('Proceed with creating new file?')
    }
  }
 
  if (!abort) {
    write(content, file = the_scss_file)
    ui_done(paste0('\n', name, '.scss has been created.\n\n'))
    links <- glue::glue(
      '-------------------------------------------------------------
        Please refer to these links for more SCSS styling options:
      - https://quarto.org/docs/output-formats/html-themes.html#customizing-themes
      - https://quarto.org/docs/output-formats/html-themes-more.html
      - https://github.com/twbs/bootstrap/blob/main/scss/_variables.scss
      --------------------------------------------------------------'
    )
    ui_info(links)
    message('\n')
  } else {
    ui_oops('\n.scss was not changed.\n\n')
  }
 }
 NULL
