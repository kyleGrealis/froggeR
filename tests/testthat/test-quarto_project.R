library(testthat)
library(froggeR)

# Suppress both warnings (deprecation) and messages (ui_*) from quarto_project
.quiet_qp <- function(expr) {
  suppressWarnings(suppressMessages(expr))
}


# Deprecation warning test ====

test_that("quarto_project emits deprecation warning", {
  tmp_dir <- withr::local_tempdir()

  fake_zip <- tempfile(fileext = ".zip")
  .create_fake_template_zip(fake_zip)

  local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      file.copy(fake_zip, destfile, overwrite = TRUE)
      0L
    },
    .package = "utils"
  )
  local_mocked_bindings(
    user_config_dir = function(...) file.path(tmp_dir, "no_config"),
    .package = "rappdirs"
  )

  expect_warning(
    suppressMessages(quarto_project(name = "test-deprecation", path = tmp_dir)),
    "deprecated"
  )

  unlink(fake_zip)
})


# Path validation tests ====

test_that("quarto_project errors on NULL path", {
  expect_error(
    .quiet_qp(quarto_project(name = "test", path = NULL)),
    "Invalid `path`"
  )
})

test_that("quarto_project errors on NA path", {
  expect_error(
    .quiet_qp(quarto_project(name = "test", path = NA)),
    "Invalid `path`"
  )
})

test_that("quarto_project errors on nonexistent path", {
  fake_path <- file.path(tempdir(), "nonexistent_dir_xyz123")

  expect_error(
    .quiet_qp(quarto_project(name = "test", path = fake_path)),
    "Invalid `path`"
  )
})


# Name validation tests ====

test_that("quarto_project errors on invalid project name with spaces", {
  tmp_dir <- withr::local_tempdir()

  expect_error(
    .quiet_qp(quarto_project(name = "test project", path = tmp_dir)),
    "Invalid project name"
  )
})

test_that("quarto_project errors on invalid project name with special characters", {
  tmp_dir <- withr::local_tempdir()

  invalid_names <- c("test@project", "test.project", "test/project", "test!project")

  for (name in invalid_names) {
    expect_error(
      .quiet_qp(quarto_project(name = name, path = tmp_dir)),
      "Invalid project name"
    )
  }
})


# Directory existence tests ====

test_that("quarto_project errors when directory already exists", {
  tmp_dir <- withr::local_tempdir()
  project_name <- "existing-project"
  dir.create(file.path(tmp_dir, project_name))

  expect_error(
    .quiet_qp(quarto_project(name = project_name, path = tmp_dir)),
    "Directory named"
  )
})


# Delegation to init() ====

test_that("quarto_project creates directory and delegates to init", {
  tmp_dir <- withr::local_tempdir()

  fake_zip <- tempfile(fileext = ".zip")
  .create_fake_template_zip(fake_zip)

  local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      file.copy(fake_zip, destfile, overwrite = TRUE)
      0L
    },
    .package = "utils"
  )
  local_mocked_bindings(
    user_config_dir = function(...) file.path(tmp_dir, "no_config"),
    .package = "rappdirs"
  )

  project_name <- "delegated-project"
  result <- .quiet_qp(quarto_project(name = project_name, path = tmp_dir))

  project_dir <- file.path(tmp_dir, project_name)

  expect_true(dir.exists(project_dir))
  expect_true(file.exists(file.path(project_dir, "_quarto.yml")))
  expect_true(dir.exists(file.path(project_dir, "data")))

  unlink(fake_zip)
})

test_that("quarto_project returns project path invisibly", {
  tmp_dir <- withr::local_tempdir()

  fake_zip <- tempfile(fileext = ".zip")
  .create_fake_template_zip(fake_zip)

  local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      file.copy(fake_zip, destfile, overwrite = TRUE)
      0L
    },
    .package = "utils"
  )
  local_mocked_bindings(
    user_config_dir = function(...) file.path(tmp_dir, "no_config"),
    .package = "rappdirs"
  )

  project_name <- "return-test"
  result <- .quiet_qp(quarto_project(name = project_name, path = tmp_dir))

  expect_type(result, "character")
  expect_true(dir.exists(result))

  unlink(fake_zip)
})
