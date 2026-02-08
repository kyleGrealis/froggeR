library(testthat)
library(froggeR)

# Tests for write_variables() ====

test_that("write_variables creates _variables.yml file in valid directory", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_variables_template(),
    .package = "froggeR"
  )
  local_mocked_bindings(
    user_config_dir = function(...) file.path(tempdir(), "no_config"),
    .package = "rappdirs"
  )

  result <- suppressMessages(write_variables(tmp_dir))

  expect_true(file.exists(file.path(tmp_dir, "_variables.yml")))
  expect_type(result, "character")
  expect_equal(result, normalizePath(file.path(tmp_dir, "_variables.yml")))
})

test_that("write_variables errors when directory does not exist", {
  expect_error(
    write_variables("/nonexistent/directory/path"),
    class = "froggeR_invalid_path"
  )
})

test_that("write_variables opens existing file without error", {
  tmp_dir <- withr::local_tempdir()

  existing_file <- file.path(tmp_dir, "_variables.yml")
  writeLines("existing: content", existing_file)

  local_mocked_bindings(
    user_config_dir = function(...) file.path(tempdir(), "no_config"),
    .package = "rappdirs"
  )

  result <- suppressMessages(write_variables(tmp_dir))
  expect_equal(result, normalizePath(existing_file))

  # Content should be unchanged
  expect_equal(readLines(existing_file), "existing: content")
})

test_that("write_variables creates file with valid YAML structure", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_variables_template(),
    .package = "froggeR"
  )
  local_mocked_bindings(
    user_config_dir = function(...) file.path(tempdir(), "no_config"),
    .package = "rappdirs"
  )

  result <- suppressMessages(write_variables(tmp_dir))

  content <- yaml::read_yaml(result)
  expect_type(content, "list")

  expected_keys <- c("name", "email", "orcid", "url", "github", "affiliations")
  expect_true(any(expected_keys %in% names(content)))
})

test_that("write_variables returns normalized absolute path", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_variables_template(),
    .package = "froggeR"
  )
  local_mocked_bindings(
    user_config_dir = function(...) file.path(tempdir(), "no_config"),
    .package = "rappdirs"
  )

  result <- suppressMessages(write_variables(tmp_dir))

  expect_true(grepl("^/", result) || grepl("^[A-Z]:", result))
  expect_equal(basename(result), "_variables.yml")
})

test_that("write_variables errors on invalid paths", {
  expect_error(
    write_variables(NULL),
    class = "froggeR_invalid_path"
  )

  expect_error(
    write_variables(NA_character_),
    class = "froggeR_invalid_path"
  )

  expect_error(
    write_variables("/totally/fake/path"),
    class = "froggeR_invalid_path"
  )
})

test_that("write_variables uses global config when available", {
  tmp_dir <- withr::local_tempdir()
  fake_config_dir <- withr::local_tempdir()

  # Create a fake global config file
  global_config <- file.path(fake_config_dir, "_variables.yml")
  writeLines(c("name: Global User", "email: global@example.com"), global_config)

  local_mocked_bindings(
    user_config_dir = function(...) fake_config_dir,
    .package = "rappdirs"
  )

  result <- suppressMessages(write_variables(tmp_dir))

  content <- readLines(file.path(tmp_dir, "_variables.yml"))
  expect_true(any(grepl("Global User", content)))
})

test_that("write_variables handles path with trailing slash", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_variables_template(),
    .package = "froggeR"
  )
  local_mocked_bindings(
    user_config_dir = function(...) file.path(tempdir(), "no_config"),
    .package = "rappdirs"
  )

  path_with_slash <- paste0(tmp_dir, "/")
  result <- suppressMessages(write_variables(path_with_slash))

  expect_true(file.exists(result))
  expect_equal(basename(result), "_variables.yml")
})
