library(testthat)

# Tests for write_ignore() ------------------------------------------------

test_that("write_ignore creates .gitignore file successfully with minimal template", {
  tmp_dir <- withr::local_tempdir()

  result <- suppressMessages(write_ignore(path = tmp_dir, aggressive = FALSE))

  expect_true(file.exists(file.path(tmp_dir, ".gitignore")))
  expect_identical(result, normalizePath(file.path(tmp_dir, ".gitignore")))
})

test_that("write_ignore creates .gitignore file successfully with aggressive template", {
  tmp_dir <- withr::local_tempdir()

  result <- suppressMessages(write_ignore(path = tmp_dir, aggressive = TRUE))

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

test_that("write_ignore errors when file already exists", {
  tmp_dir <- withr::local_tempdir()

  # Create first .gitignore
  suppressMessages(write_ignore(path = tmp_dir))

  # Try to create again
  expect_error(
    write_ignore(path = tmp_dir),
    "A .gitignore file already exists",
    class = "froggeR_file_exists"
  )
})

test_that("write_ignore returns path invisibly", {
  tmp_dir <- withr::local_tempdir()

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


# Tests for create_ignore() -----------------------------------------------

test_that("create_ignore creates file with minimal template by default", {
  tmp_dir <- withr::local_tempdir()

  result <- suppressMessages(create_ignore(path = tmp_dir, aggressive = FALSE))

  expect_true(file.exists(result))
  expect_identical(basename(result), ".gitignore")

  # Verify it's the minimal version by checking file exists
  ignore_content <- readLines(result)
  expect_true(length(ignore_content) > 0)
})

test_that("create_ignore creates file with aggressive template when aggressive = TRUE", {
  tmp_dir <- withr::local_tempdir()

  result <- suppressMessages(create_ignore(path = tmp_dir, aggressive = TRUE))

  expect_true(file.exists(result))
  expect_identical(basename(result), ".gitignore")

  # Verify it's the aggressive version by checking file exists and has content
  ignore_content <- readLines(result)
  expect_true(length(ignore_content) > 0)
})

test_that("create_ignore errors when directory doesn't exist", {
  fake_path <- file.path(tempdir(), "nonexistent_directory_67890")

  expect_error(
    create_ignore(path = fake_path, aggressive = FALSE),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("create_ignore errors when .gitignore already exists", {
  tmp_dir <- withr::local_tempdir()

  # Create first .gitignore
  suppressMessages(create_ignore(path = tmp_dir))

  # Try to create again
  expect_error(
    create_ignore(path = tmp_dir),
    "A .gitignore file already exists",
    class = "froggeR_file_exists"
  )
})

test_that("create_ignore returns normalized path", {
  tmp_dir <- withr::local_tempdir()

  result <- suppressMessages(create_ignore(path = tmp_dir))

  # Result should be an absolute path
  expect_true(grepl("^/", result) || grepl("^[A-Z]:", result))
  expect_identical(basename(result), ".gitignore")
})

test_that("create_ignore handles NULL path", {
  expect_error(
    create_ignore(path = NULL, aggressive = FALSE),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("create_ignore handles NA path", {
  expect_error(
    create_ignore(path = NA, aggressive = FALSE),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})


# Edge Cases and Integration Tests ----------------------------------------

test_that("write_ignore and create_ignore produce identical files for minimal template", {
  tmp_dir1 <- withr::local_tempdir()
  tmp_dir2 <- withr::local_tempdir()

  result1 <- suppressMessages(write_ignore(path = tmp_dir1, aggressive = FALSE))
  result2 <- suppressMessages(create_ignore(path = tmp_dir2, aggressive = FALSE))

  content1 <- readLines(result1)
  content2 <- readLines(result2)

  expect_identical(content1, content2)
})

test_that("write_ignore and create_ignore produce identical files for aggressive template", {
  tmp_dir1 <- withr::local_tempdir()
  tmp_dir2 <- withr::local_tempdir()

  result1 <- suppressMessages(write_ignore(path = tmp_dir1, aggressive = TRUE))
  result2 <- suppressMessages(create_ignore(path = tmp_dir2, aggressive = TRUE))

  content1 <- readLines(result1)
  content2 <- readLines(result2)

  expect_identical(content1, content2)
})

test_that("minimal and aggressive templates are different", {
  tmp_dir1 <- withr::local_tempdir()
  tmp_dir2 <- withr::local_tempdir()

  minimal_file <- suppressMessages(create_ignore(path = tmp_dir1, aggressive = FALSE))
  aggressive_file <- suppressMessages(create_ignore(path = tmp_dir2, aggressive = TRUE))

  minimal_content <- readLines(minimal_file)
  aggressive_content <- readLines(aggressive_file)

  # Aggressive should have more lines (more comprehensive rules)
  expect_true(length(aggressive_content) > length(minimal_content))
})

test_that("created .gitignore files are readable and non-empty", {
  tmp_dir <- withr::local_tempdir()

  result <- suppressMessages(create_ignore(path = tmp_dir, aggressive = FALSE))

  # File should exist and be readable
  expect_true(file.exists(result))
  expect_true(file.access(result, mode = 4) == 0)  # mode 4 = read permission

  # File should not be empty
  info <- file.info(result)
  expect_true(info$size > 0)
})

test_that("write_ignore normalizes path correctly", {
  tmp_dir <- withr::local_tempdir()

  # Use path with trailing slash
  path_with_slash <- paste0(tmp_dir, "/")

  result <- suppressMessages(write_ignore(path = path_with_slash))

  # Should still create the file in the correct location
  expect_true(file.exists(result))
  expect_identical(normalizePath(dirname(result)), normalizePath(tmp_dir))
})

test_that("aggressive parameter is correctly passed through write_ignore to create_ignore", {
  tmp_dir1 <- withr::local_tempdir()
  tmp_dir2 <- withr::local_tempdir()

  # Create with write_ignore (aggressive = TRUE)
  result1 <- suppressMessages(write_ignore(path = tmp_dir1, aggressive = TRUE))

  # Create with create_ignore (aggressive = TRUE)
  result2 <- suppressMessages(create_ignore(path = tmp_dir2, aggressive = TRUE))

  content1 <- readLines(result1)
  content2 <- readLines(result2)

  # Should be identical
  expect_identical(content1, content2)
})
