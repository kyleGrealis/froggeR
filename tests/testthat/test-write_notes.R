library(testthat)
library(froggeR)

# Test write_notes() - Main exported function ====

test_that("write_notes creates dated_progress_notes.md successfully", {
  tmp_dir <- withr::local_tempdir()

  result <- write_notes(path = tmp_dir)

  # File should be created
  expect_true(file.exists(file.path(tmp_dir, "dated_progress_notes.md")))

  # Function returns file path invisibly
  expect_equal(basename(result), "dated_progress_notes.md")

  # Content should include current date and header
  content <- readLines(file.path(tmp_dir, "dated_progress_notes.md"))
  expect_match(content[1], "# Project updates")
  expect_match(content[3], format(Sys.Date(), "%b %d, %Y"))
  expect_match(content[3], "project started")
})

test_that("write_notes creates file with correct content structure", {
  tmp_dir <- withr::local_tempdir()

  result <- write_notes(path = tmp_dir)
  content <- readLines(result)

  # Verify exact content format
  expect_length(content, 3)
  expect_equal(content[1], "# Project updates")
  expect_equal(content[2], "")
  expect_true(grepl("^\\* ", content[3]))
  expect_true(grepl("project started$", content[3]))
})

test_that("write_notes returns normalized absolute path", {
  tmp_dir <- withr::local_tempdir()

  result <- write_notes(path = tmp_dir)

  # Result should be absolute path
  expect_true(grepl("^/", result) || grepl("^[A-Z]:/", result) || grepl("^[A-Z]:\\\\", result))
  expect_equal(normalizePath(dirname(result)), normalizePath(tmp_dir))
})


# Error handling tests ====

test_that("write_notes errors when directory doesn't exist", {
  fake_path <- file.path(tempdir(), "nonexistent_dir_xyz123")

  expect_error(
    write_notes(path = fake_path),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_notes errors when file already exists", {
  tmp_dir <- withr::local_tempdir()

  # Create the file manually
  notes_file <- file.path(tmp_dir, "dated_progress_notes.md")
  writeLines("# Test", notes_file)

  # Try to create - should error with appropriate message
  expect_error(
    write_notes(path = tmp_dir),
    "A dated_progress_notes.md already exists"
  )
})

test_that("write_notes errors on NULL path", {
  expect_error(
    write_notes(path = NULL),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_notes errors on NA path", {
  expect_error(
    write_notes(path = NA),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_notes errors on empty string path", {
  expect_error(
    write_notes(path = ""),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})


# Edge cases and path handling ====

test_that("write_notes handles empty directory", {
  tmp_dir <- withr::local_tempdir()
  # Directory is empty by default

  result <- write_notes(path = tmp_dir)

  expect_true(file.exists(result))
  expect_equal(basename(result), "dated_progress_notes.md")
})

test_that("write_notes handles path with trailing slash", {
  tmp_dir <- withr::local_tempdir()

  # Add trailing slash
  path_with_slash <- paste0(tmp_dir, "/")
  result <- write_notes(path = path_with_slash)

  # Should still create in correct location
  expect_true(file.exists(file.path(tmp_dir, "dated_progress_notes.md")))
  expect_true(file.exists(result))
})

test_that("write_notes date format is correct", {
  tmp_dir <- withr::local_tempdir()

  result <- write_notes(path = tmp_dir)
  content <- readLines(result)

  # Date should be in format like "Jan 13, 2025"
  expected_date <- format(Sys.Date(), "%b %d, %Y")
  expect_true(grepl(expected_date, content[3], fixed = TRUE))
})

test_that("write_notes creates file in nested directory structure", {
  tmp_base <- withr::local_tempdir()
  nested_dir <- file.path(tmp_base, "project", "docs")
  dir.create(nested_dir, recursive = TRUE)

  result <- write_notes(path = nested_dir)

  expect_true(file.exists(result))
  expect_equal(basename(result), "dated_progress_notes.md")
  expect_true(grepl("project/docs", result) || grepl("project\\\\docs", result))
})


# Content validation tests ====

test_that("write_notes file contains valid markdown header", {
  tmp_dir <- withr::local_tempdir()

  result <- write_notes(path = tmp_dir)
  content <- readLines(result)

  # First line should be markdown header
  expect_true(startsWith(content[1], "# "))
  expect_equal(content[1], "# Project updates")
})

test_that("write_notes file bullet point has correct format", {
  tmp_dir <- withr::local_tempdir()

  result <- write_notes(path = tmp_dir)
  content <- readLines(result)

  # Third line should be bullet with date
  expect_true(grepl("^\\* [A-Z][a-z]{2} \\d{2}, \\d{4}: project started$", content[3]))
})
