library(testthat)
library(froggeR)

# Tests for write_ignore() ====

test_that("write_ignore creates .gitignore file successfully", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_gitignore_template(),
    .package = "froggeR"
  )

  result <- suppressMessages(write_ignore(path = tmp_dir))

  expect_true(file.exists(file.path(tmp_dir, ".gitignore")))
  expect_identical(result, normalizePath(file.path(tmp_dir, ".gitignore")))
})

test_that("write_ignore errors when directory doesn't exist", {
  fake_path <- file.path(tempdir(), "nonexistent_directory_12345")

  expect_error(
    write_ignore(path = fake_path),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_ignore opens existing file without error", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_gitignore_template(),
    .package = "froggeR"
  )

  suppressMessages(write_ignore(path = tmp_dir))

  # Calling again should succeed (opens existing file)
  result <- suppressMessages(write_ignore(path = tmp_dir))
  expect_true(file.exists(result))
  expect_identical(basename(result), ".gitignore")
})

test_that("write_ignore returns path invisibly", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_gitignore_template(),
    .package = "froggeR"
  )

  result <- suppressMessages(write_ignore(path = tmp_dir))

  expect_identical(result, normalizePath(file.path(tmp_dir, ".gitignore")))
})

test_that("write_ignore handles NULL path", {
  expect_error(
    write_ignore(path = NULL),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_ignore handles NA path", {
  expect_error(
    write_ignore(path = NA),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})


# Content and edge cases ====

test_that("created .gitignore is readable and non-empty", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_gitignore_template(),
    .package = "froggeR"
  )

  result <- suppressMessages(write_ignore(path = tmp_dir))

  expect_true(file.exists(result))
  expect_true(file.access(result, mode = 4) == 0)

  info <- file.info(result)
  expect_true(info$size > 0)
})

test_that("write_ignore normalizes path correctly", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_gitignore_template(),
    .package = "froggeR"
  )

  path_with_slash <- paste0(tmp_dir, "/")
  result <- suppressMessages(write_ignore(path = path_with_slash))

  expect_true(file.exists(result))
  expect_identical(normalizePath(dirname(result)), normalizePath(tmp_dir))
})
