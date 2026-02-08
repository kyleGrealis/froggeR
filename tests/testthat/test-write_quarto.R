library(testthat)
library(froggeR)

# Tests for write_quarto() ====

test_that("write_quarto creates .qmd file in pages/ directory", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_qmd_template(),
    .package = "froggeR"
  )

  result <- suppressMessages(write_quarto(
    filename = "test-doc",
    path = tmp_dir
  ))

  expect_true(file.exists(file.path(tmp_dir, "pages", "test-doc.qmd")))
  expect_type(result, "character")
  expect_equal(basename(result), "test-doc.qmd")
})

test_that("write_quarto uses default filename", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_qmd_template(),
    .package = "froggeR"
  )

  result <- suppressMessages(write_quarto(path = tmp_dir))

  expect_true(file.exists(file.path(tmp_dir, "pages", "Untitled-1.qmd")))
})

test_that("write_quarto does not call edit_file when non-interactive", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_qmd_template(),
    .package = "froggeR"
  )

  expect_silent(
    suppressMessages(write_quarto(path = tmp_dir, filename = "test"))
  )

  expect_true(file.exists(file.path(tmp_dir, "pages", "test.qmd")))
})

test_that("write_quarto creates pages/ directory automatically", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_qmd_template(),
    .package = "froggeR"
  )

  suppressMessages(write_quarto(filename = "test", path = tmp_dir))

  expect_true(dir.exists(file.path(tmp_dir, "pages")))
})


# Error handling tests ====

test_that("write_quarto errors when directory doesn't exist", {
  fake_path <- file.path(tempdir(), "nonexistent_dir_xyz123")

  expect_error(
    write_quarto(path = fake_path, filename = "test"),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_quarto errors when .qmd file already exists", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_qmd_template(),
    .package = "froggeR"
  )

  pages_dir <- file.path(tmp_dir, "pages")
  dir.create(pages_dir)
  writeLines("---\ntitle: Test\n---", file.path(pages_dir, "existing.qmd"))

  expect_error(
    write_quarto(path = tmp_dir, filename = "existing"),
    "existing.qmd already exists",
    class = "froggeR_file_exists"
  )
})

test_that("write_quarto errors on NULL path", {
  expect_error(
    write_quarto(path = NULL, filename = "test"),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_quarto errors on NA path", {
  expect_error(
    write_quarto(path = NA, filename = "test"),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_quarto errors on invalid path", {
  expect_error(
    write_quarto(filename = "test", path = "/totally/fake/path"),
    class = "froggeR_invalid_path"
  )
})


# Filename validation tests ====

test_that("write_quarto validates filename is character", {
  expect_error(
    write_quarto(filename = 123, path = tempdir()),
    "Invalid filename: must be a character string"
  )

  expect_error(
    write_quarto(filename = NULL, path = tempdir()),
    "Invalid filename: must be a character string"
  )

  expect_error(
    write_quarto(filename = NA, path = tempdir()),
    "Invalid filename: must be a character string"
  )
})

test_that("write_quarto validates filename format", {
  expect_error(
    write_quarto(filename = "test file.qmd", path = tempdir()),
    "Invalid filename. Use only letters, numbers, hyphens, and underscores"
  )

  expect_error(
    write_quarto(filename = "test@file", path = tempdir()),
    "Invalid filename. Use only letters, numbers, hyphens, and underscores"
  )
})

test_that("write_quarto accepts valid filename formats", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_qmd_template(),
    .package = "froggeR"
  )

  valid_names <- c("test", "test-123", "test_file", "MyFile", "test-file_123")

  for (name in valid_names) {
    result <- suppressMessages(write_quarto(filename = name, path = tmp_dir))
    expect_true(file.exists(result))
    expect_equal(basename(result), paste0(name, ".qmd"))
  }
})


# Content validation tests ====

test_that("created .qmd file is readable and not empty", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_qmd_template(),
    .package = "froggeR"
  )

  result <- suppressMessages(write_quarto(filename = "readable", path = tmp_dir))

  content <- readLines(result)
  expect_type(content, "character")
  expect_true(length(content) > 0)
})

test_that("created .qmd file has .qmd extension", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_qmd_template(),
    .package = "froggeR"
  )

  result <- suppressMessages(write_quarto(filename = "ext-test", path = tmp_dir))

  expect_equal(tools::file_ext(result), "qmd")
})

test_that("write_quarto returns normalized absolute path", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_qmd_template(),
    .package = "froggeR"
  )

  result <- suppressMessages(write_quarto(
    filename = "test-path",
    path = tmp_dir
  ))

  expect_true(grepl("^/", result) || grepl("^[A-Z]:/", result) || grepl("^[A-Z]:\\\\", result))
})

test_that("write_quarto handles path with trailing slash", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_qmd_template(),
    .package = "froggeR"
  )

  path_with_slash <- paste0(tmp_dir, "/")
  result <- suppressMessages(write_quarto(filename = "test", path = path_with_slash))

  expect_true(file.exists(result))
})
