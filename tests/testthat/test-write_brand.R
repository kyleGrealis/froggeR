library(testthat)
library(froggeR)

# Test write_brand() public function ==========================================

test_that("write_brand creates _brand.yml file in valid directory", {
  # Create temp directory for testing
  temp_path <- withr::local_tempdir()

  # Suppress interactive editor and messages
  suppressMessages(
    write_brand(temp_path, restore_logos = FALSE)
  )

  # Verify file was created
  brand_file <- file.path(temp_path, "_brand.yml")
  expect_true(file.exists(brand_file))

  # Verify file contains expected YAML structure
  content <- readLines(brand_file)
  expect_true(any(grepl("meta:", content)))
  expect_true(any(grepl("logo:", content)))
  expect_true(any(grepl("color:", content)))
})

test_that("write_brand errors when _brand.yml already exists", {
  temp_path <- withr::local_tempdir()

  # Create the file first time
  suppressMessages(write_brand(temp_path, restore_logos = FALSE))

  # Attempt to create again should error
  expect_error(
    suppressMessages(write_brand(temp_path, restore_logos = FALSE)),
    "_brand.yml already exists in this project"
  )
})

test_that("write_brand errors when directory does not exist", {
  # Use a path that definitely doesn't exist
  fake_path <- file.path(tempdir(), "nonexistent_dir_12345")

  expect_error(
    write_brand(fake_path, restore_logos = FALSE),
    "Invalid path"
  )
})

test_that("write_brand returns path invisibly", {
  temp_path <- withr::local_tempdir()

  # write_brand returns invisibly, so we need to capture it differently
  suppressMessages(
    result <- write_brand(temp_path, restore_logos = FALSE)
  )

  # Result should be the path to the brand file
  expect_type(result, "character")
  expect_true(grepl("_brand.yml$", result))
  expect_true(file.exists(result))
})

# Test YAML content and structure =============================================

test_that("write_brand creates valid YAML with all expected sections", {
  temp_path <- withr::local_tempdir()

  suppressMessages(write_brand(temp_path, restore_logos = FALSE))

  brand_file <- file.path(temp_path, "_brand.yml")
  content <- readLines(brand_file)

  # Check for all major YAML sections (these are in package template and user config)
  expect_true(any(grepl("meta:", content)))
  expect_true(any(grepl("logo:", content)))
  expect_true(any(grepl("color:", content)))
  expect_true(any(grepl("typography:", content)))

  # Verify the YAML file is not empty
  expect_gt(length(content), 10)
})

test_that("write_brand file basename is always _brand.yml", {
  temp_path <- withr::local_tempdir()

  result <- suppressMessages(write_brand(temp_path, restore_logos = FALSE))

  expect_equal(basename(result), "_brand.yml")
})

# Test logo restoration behavior ===============================================

test_that("write_brand skips logo restoration when restore_logos = FALSE", {
  temp_path <- withr::local_tempdir()

  # Create brand without logo restoration
  result <- suppressMessages(write_brand(temp_path, restore_logos = FALSE))

  # Verify _brand.yml was created
  expect_true(file.exists(result))

  # Verify logos directory was NOT created
  logos_dir <- file.path(temp_path, "logos")
  expect_false(dir.exists(logos_dir))
})

test_that("write_brand handles logos directory when it already exists", {
  temp_path <- withr::local_tempdir()

  # Pre-create logos directory
  logos_dir <- file.path(temp_path, "logos")
  dir.create(logos_dir)

  # Should not error, just skip with message
  expect_message(
    write_brand(temp_path, restore_logos = TRUE),
    "Logos directory already exists.*Skipping"
  )

  # Verify _brand.yml was still created
  expect_true(file.exists(file.path(temp_path, "_brand.yml")))
})

# Test edge cases ==============================================================

test_that("write_brand handles paths with trailing slashes", {
  temp_path <- withr::local_tempdir()
  path_with_slash <- paste0(temp_path, "/")

  result <- suppressMessages(write_brand(path_with_slash, restore_logos = FALSE))

  expect_true(file.exists(result))
  expect_equal(basename(result), "_brand.yml")
})

test_that("write_brand creates proper brand.yml with expected structure", {
  temp_path <- withr::local_tempdir()

  # Create brand file
  result <- suppressMessages(write_brand(temp_path, restore_logos = FALSE))

  # Verify file was created
  expect_true(file.exists(result))

  # Verify content has proper structure (key sections from template or user config)
  content <- paste(readLines(result), collapse = "\n")

  # These sections should always be present
  expect_true(grepl("meta:", content))
  expect_true(grepl("logo:", content))
  expect_true(grepl("color:", content))
  expect_true(grepl("palette:", content))
  expect_true(grepl("typography:", content))
  expect_true(grepl("fonts:", content))
})

# Test input validation ========================================================

test_that("write_brand validates NULL path", {
  expect_error(
    write_brand(NULL, restore_logos = FALSE),
    "Invalid path"
  )
})

test_that("write_brand validates empty character vector", {
  # Empty character vector triggers a different error in the validator
  expect_error(
    write_brand(character(0), restore_logos = FALSE)
  )
})
