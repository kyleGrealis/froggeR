test_that("write_ignore fails with bad path", {
  expect_error(write_ignore(path = "bad_path"), "Invalid `path`.")
  expect_error(write_ignore(path = " "), "Invalid `path`.")
  expect_error(write_ignore(path = NULL), "Invalid `path`.")
})

test_that("write_ignore creates the .gitignore file correctly", {
  tmp_dir <- tempdir()
  ignore_file <- file.path(tmp_dir, ".gitignore")
  # Remove any prior instances
  unlink(ignore_file)
  write_ignore(tmp_dir, .initialize_proj = FALSE)
  expect_true(file.exists(ignore_file))
  # Clean up
  unlink(ignore_file)
  expect_false(file.exists(ignore_file))
})

test_that('write_ignore creates content correctly', {
  tmp_dir <- tempdir()
  ignore_file <- file.path(tmp_dir, ".gitignore")
  # Remove any prior instances
  unlink(ignore_file)
  suppressMessages(write_ignore(tmp_dir, .initialize_proj = TRUE))
  # Check content
  file_content <- readLines(ignore_file)
  expect_true("# History files" %in% file_content)
  expect_true(".Renviron" %in% file_content)
  expect_true("# R data" %in% file_content)
  expect_true("/.quarto/" %in% file_content)
  # Clean up
  unlink(ignore_file)
  expect_false(file.exists(ignore_file))
})

test_that('write_ignore recognizes overwrite error', {
  tmp_dir <- tempdir()
  ignore_file <- file.path(tmp_dir, ".gitignore")
  # Remove any prior instances
  unlink(ignore_file)
  suppressMessages(write_ignore(tmp_dir, .initialize_proj = TRUE))
  # Test for error
  expect_error(write_ignore(tmp_dir, .initialize_proj = TRUE), 'already exists')
  # Clean up
  unlink(ignore_file)
  expect_false(file.exists(ignore_file))
})
