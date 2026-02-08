# Shared test helpers for mocking .fetch_template()

#' Create a minimal fake .qmd template file
#' @return Path to the temporary file
.fake_qmd_template <- function() {
  tmp <- tempfile(fileext = ".qmd")
  writeLines(c("---", "title: 'Test'", "---", "", "Hello world."), tmp)
  tmp
}

#' Create a minimal fake .scss template file
#' @return Path to the temporary file
.fake_scss_template <- function() {
  tmp <- tempfile(fileext = ".scss")
  writeLines(c(
    "/*-- scss:defaults --*/",
    "$primary: #000;",
    "/*-- scss:mixins --*/",
    "/*-- scss:rules --*/"
  ), tmp)
  tmp
}

#' Create a minimal fake _brand.yml template file
#' @return Path to the temporary file
.fake_brand_template <- function() {
  tmp <- tempfile(fileext = ".yml")
  writeLines(c(
    "meta:",
    "  name: ~",
    "logo:",
    "  small: ~",
    "  medium: ~",
    "  large: ~",
    "color:",
    "  palette:",
    "    primary: '#000'",
    "  foreground: light",
    "  background: dark",
    "typography:",
    "  fonts:",
    "    - family: Arial"
  ), tmp)
  tmp
}

#' Create a minimal fake _variables.yml template file
#' @return Path to the temporary file
.fake_variables_template <- function() {
  tmp <- tempfile(fileext = ".yml")
  writeLines(c(
    "name: ~",
    "email: ~",
    "orcid: ~",
    "url: ~",
    "github: ~",
    "affiliations: ~"
  ), tmp)
  tmp
}

#' Create a minimal fake .gitignore template file
#' @return Path to the temporary file
.fake_gitignore_template <- function() {
  tmp <- tempfile()
  writeLines(c(
    "# R files",
    ".Rhistory",
    ".RData",
    ".Rproj.user",
    "",
    "# Data",
    "data/"
  ), tmp)
  tmp
}

#' Create a fake template zip for init() tests
#' @param zip_path Path where the zip file should be created
#' @return Invisible zip_path
.create_fake_template_zip <- function(zip_path) {
  staging <- tempfile("fake_template_")
  template_root <- file.path(staging, "frogger-templates-main")
  dir.create(template_root, recursive = TRUE)

  dir.create(file.path(template_root, "R"))
  dir.create(file.path(template_root, "pages"))
  dir.create(file.path(template_root, "www"))
  dir.create(file.path(template_root, "logos"))

  writeLines("project:\n  title: \"\"", file.path(template_root, "_quarto.yml"))
  writeLines("brand:\n  color: {}", file.path(template_root, "_brand.yml"))
  writeLines("# README", file.path(template_root, "README.md"))
  writeLines("# gitignore", file.path(template_root, ".gitignore"))

  withr::with_dir(staging, {
    utils::zip(zip_path, files = "frogger-templates-main", flags = "-rq")
  })

  unlink(staging, recursive = TRUE)
  invisible(zip_path)
}
