library(testthat)
library(froggeR)

# Test write_brand() ====

test_that("write_brand creates _brand.yml file in valid directory", {
  temp_path <- withr::local_tempdir()
  fake_config <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_brand_template(),
    .package = "froggeR"
  )
  local_mocked_bindings(
    user_config_dir = function(...) fake_config,
    .package = "rappdirs"
  )

  suppressMessages(write_brand(temp_path, restore_logos = FALSE))

  brand_file <- file.path(temp_path, "_brand.yml")
  expect_true(file.exists(brand_file))

  content <- readLines(brand_file)
  expect_true(any(grepl("meta:", content)))
  expect_true(any(grepl("logo:", content)))
  expect_true(any(grepl("color:", content)))
})

test_that("write_brand opens existing _brand.yml without error", {
  temp_path <- withr::local_tempdir()
  fake_config <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_brand_template(),
    .package = "froggeR"
  )
  local_mocked_bindings(
    user_config_dir = function(...) fake_config,
    .package = "rappdirs"
  )

  suppressMessages(write_brand(temp_path, restore_logos = FALSE))

  # Calling again should succeed (opens existing file)
  result <- suppressMessages(write_brand(temp_path, restore_logos = FALSE))
  expect_true(file.exists(result))
  expect_equal(basename(result), "_brand.yml")
})

test_that("write_brand errors when directory does not exist", {
  fake_path <- file.path(tempdir(), "nonexistent_dir_12345")

  expect_error(
    write_brand(fake_path, restore_logos = FALSE),
    "Invalid path"
  )
})

test_that("write_brand returns path invisibly", {
  temp_path <- withr::local_tempdir()
  fake_config <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_brand_template(),
    .package = "froggeR"
  )
  local_mocked_bindings(
    user_config_dir = function(...) fake_config,
    .package = "rappdirs"
  )

  suppressMessages(
    result <- write_brand(temp_path, restore_logos = FALSE)
  )

  expect_type(result, "character")
  expect_true(grepl("_brand.yml$", result))
  expect_true(file.exists(result))
})


# Test YAML content and structure ====

test_that("write_brand creates valid YAML with expected sections", {
  temp_path <- withr::local_tempdir()
  fake_config <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_brand_template(),
    .package = "froggeR"
  )
  local_mocked_bindings(
    user_config_dir = function(...) fake_config,
    .package = "rappdirs"
  )

  suppressMessages(write_brand(temp_path, restore_logos = FALSE))

  brand_file <- file.path(temp_path, "_brand.yml")
  content <- readLines(brand_file)

  expect_true(any(grepl("meta:", content)))
  expect_true(any(grepl("logo:", content)))
  expect_true(any(grepl("color:", content)))
  expect_true(any(grepl("typography:", content)))

  expect_gt(length(content), 5)
})

test_that("write_brand file basename is always _brand.yml", {
  temp_path <- withr::local_tempdir()
  fake_config <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_brand_template(),
    .package = "froggeR"
  )
  local_mocked_bindings(
    user_config_dir = function(...) fake_config,
    .package = "rappdirs"
  )

  result <- suppressMessages(write_brand(temp_path, restore_logos = FALSE))

  expect_equal(basename(result), "_brand.yml")
})


# Test logo restoration ====

test_that("write_brand skips logo restoration when restore_logos = FALSE", {
  temp_path <- withr::local_tempdir()
  fake_config <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_brand_template(),
    .package = "froggeR"
  )
  local_mocked_bindings(
    user_config_dir = function(...) fake_config,
    .package = "rappdirs"
  )

  result <- suppressMessages(write_brand(temp_path, restore_logos = FALSE))

  expect_true(file.exists(result))
  expect_false(dir.exists(file.path(temp_path, "logos")))
})

test_that("write_brand handles logos directory when it already exists", {
  temp_path <- withr::local_tempdir()
  fake_config <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_brand_template(),
    .package = "froggeR"
  )
  local_mocked_bindings(
    user_config_dir = function(...) fake_config,
    .package = "rappdirs"
  )

  logos_dir <- file.path(temp_path, "logos")
  dir.create(logos_dir)

  expect_message(
    write_brand(temp_path, restore_logos = TRUE),
    "Logos directory already exists.*Skipping"
  )

  expect_true(file.exists(file.path(temp_path, "_brand.yml")))
})


# Edge cases ====

test_that("write_brand handles paths with trailing slashes", {
  temp_path <- withr::local_tempdir()
  fake_config <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_brand_template(),
    .package = "froggeR"
  )
  local_mocked_bindings(
    user_config_dir = function(...) fake_config,
    .package = "rappdirs"
  )

  path_with_slash <- paste0(temp_path, "/")
  result <- suppressMessages(write_brand(path_with_slash, restore_logos = FALSE))

  expect_true(file.exists(result))
  expect_equal(basename(result), "_brand.yml")
})


# Input validation ====

test_that("write_brand validates NULL path", {
  expect_error(
    write_brand(NULL, restore_logos = FALSE),
    "Invalid path"
  )
})

test_that("write_brand validates empty character vector", {
  expect_error(
    write_brand(character(0), restore_logos = FALSE)
  )
})
