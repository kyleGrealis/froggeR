library(testthat)
library(froggeR)

# Test write_scss() - Main exported function ====

test_that("write_scss creates custom.scss successfully", {
  tmp_dir <- withr::local_tempdir()

  result <- write_scss(path = tmp_dir)

  # File should be created
  expect_true(file.exists(file.path(tmp_dir, "custom.scss")))

  # Function returns file path invisibly
  expect_equal(basename(result), "custom.scss")
})

test_that("write_scss creates file with correct template content", {
  tmp_dir <- withr::local_tempdir()

  result <- write_scss(path = tmp_dir)
  content <- readLines(result)

  # Verify SCSS template content is present
  expect_true(any(grepl("^/\\*-- scss:defaults --\\*/", content)))
  expect_true(any(grepl("^/\\*-- scss:mixins --\\*/", content)))
  expect_true(any(grepl("^/\\*-- scss:rules --\\*/", content)))
})

test_that("write_scss returns normalized absolute path", {
  tmp_dir <- withr::local_tempdir()

  result <- write_scss(path = tmp_dir)

  # Result should be absolute path
  expect_true(grepl("^/", result) || grepl("^[A-Z]:/", result) || grepl("^[A-Z]:\\\\", result))
  expect_equal(normalizePath(dirname(result)), normalizePath(tmp_dir))
})


# Error handling tests ====

test_that("write_scss errors when directory doesn't exist", {
  fake_path <- file.path(tempdir(), "nonexistent_dir_xyz123")

  expect_error(
    write_scss(path = fake_path),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_scss errors when file already exists", {
  tmp_dir <- withr::local_tempdir()

  # Create the file manually
  scss_file <- file.path(tmp_dir, "custom.scss")
  writeLines("/* test */", scss_file)

  # Try to create - should error with appropriate message
  expect_error(
    write_scss(path = tmp_dir),
    "A SCSS file already exists"
  )
})

test_that("write_scss errors on NULL path", {
  expect_error(
    write_scss(path = NULL),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_scss errors on NA path", {
  expect_error(
    write_scss(path = NA),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_scss errors on empty string path", {
  expect_error(
    write_scss(path = ""),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})


# Edge cases and path handling ====

test_that("write_scss handles empty directory", {
  tmp_dir <- withr::local_tempdir()
  # Directory is empty by default

  result <- write_scss(path = tmp_dir)

  expect_true(file.exists(result))
  expect_equal(basename(result), "custom.scss")
})

test_that("write_scss handles path with trailing slash", {
  tmp_dir <- withr::local_tempdir()

  # Add trailing slash
  path_with_slash <- paste0(tmp_dir, "/")
  result <- write_scss(path = path_with_slash)

  # Should still create in correct location
  expect_true(file.exists(file.path(tmp_dir, "custom.scss")))
  expect_true(file.exists(result))
})

test_that("write_scss creates file in nested directory structure", {
  tmp_base <- withr::local_tempdir()
  nested_dir <- file.path(tmp_base, "project", "docs")
  dir.create(nested_dir, recursive = TRUE)

  result <- write_scss(path = nested_dir)

  expect_true(file.exists(result))
  expect_equal(basename(result), "custom.scss")
  expect_true(grepl("project/docs", result) || grepl("project\\\\docs", result))
})


# Content validation tests ====

test_that("write_scss file is valid SCSS", {
  tmp_dir <- withr::local_tempdir()

  result <- write_scss(path = tmp_dir)
  content <- readLines(result)

  # File should not be empty
  expect_true(length(content) > 0)

  # Should contain SCSS sections
  expect_true(any(grepl("scss:defaults", content)))
  expect_true(any(grepl("scss:mixins", content)))
  expect_true(any(grepl("scss:rules", content)))
})

test_that("write_scss file is readable", {
  tmp_dir <- withr::local_tempdir()

  result <- write_scss(path = tmp_dir)

  # Should be able to read the file without errors
  expect_silent({
    content <- readLines(result)
  })

  # Content should be character vector
  expect_type(content, "character")
})

test_that("write_scss file has expected SCSS structure", {
  tmp_dir <- withr::local_tempdir()

  result <- write_scss(path = tmp_dir)
  content <- paste(readLines(result), collapse = "\n")

  # Check for SCSS-specific patterns
  expect_true(grepl("/\\*-- scss:defaults --\\*/", content))
  expect_true(grepl("/\\*-- scss:mixins --\\*/", content))
  expect_true(grepl("/\\*-- scss:rules --\\*/", content))

  # Should contain color variable examples
  expect_true(grepl("\\$primary", content))
})


# Template existence tests ====

test_that("SCSS template file exists in package", {
  template_path <- system.file("gists/custom.scss", package = "froggeR")

  expect_true(file.exists(template_path))
  expect_false(template_path == "")
})

test_that("SCSS template has expected content", {
  template_path <- system.file("gists/custom.scss", package = "froggeR")
  content <- readLines(template_path)

  # Template should have SCSS structure
  expect_true(length(content) > 0)
  expect_true(any(grepl("scss:defaults", content)))
  expect_true(any(grepl("scss:rules", content)))
})

test_that("write_scss template matches created file", {
  tmp_dir <- withr::local_tempdir()

  result <- write_scss(path = tmp_dir)

  # Get template content
  template_path <- system.file("gists/custom.scss", package = "froggeR")
  template_content <- readLines(template_path)

  # Get created file content
  created_content <- readLines(result)

  # Content should match template
  expect_equal(created_content, template_content)
})
