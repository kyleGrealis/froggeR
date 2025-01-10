test_that("write_scss fails with bad path", {
  expect_error(write_scss(path = "bad_path"), "Invalid `path`.")
  expect_error(write_scss(path = " "), "Invalid `path`.")
  expect_error(write_scss(path = NULL), "Invalid `path`.")
})

test_that("write_scss creates the SCSS file correctly", {
  tmp_dir <- tempdir()
  scss_file <- file.path(tmp_dir, "custom.scss")
  # Remove any prior instances
  unlink(scss_file)
  write_scss(tmp_dir, .initialize_proj = FALSE)
  expect_true(file.exists(scss_file))
  # Clean up
  unlink(scss_file)
  expect_false(file.exists(scss_file))
})

test_that('write_scss creates content correctly', {
  tmp_dir <- tempdir()
  scss_file <- file.path(tmp_dir, "custom.scss")
  # Remove any prior instances
  unlink(scss_file)
  suppressMessages(write_scss(tmp_dir, .initialize_proj = TRUE))
  # Check content
  file_content <- readLines(scss_file)
  expect_true("/*-- scss:defaults --*/" %in% file_content)
  expect_true("// $primary: #2c365e;" %in% file_content)
  expect_true("// $font-family-sans-serif: \"Open Sans\", sans-serif;" %in% file_content)
  # Clean up
  unlink(scss_file)
  expect_false(file.exists(scss_file))
})

test_that('write_scss recognizes overwrite error', {
  tmp_dir <- tempdir()
  scss_file <- file.path(tmp_dir, "custom.scss")
  # Remove any prior instances
  unlink(scss_file)
  suppressMessages(write_scss(tmp_dir, .initialize_proj = TRUE))
  # Test for error
  expect_error(write_scss(tmp_dir, .initialize_proj = TRUE), 'already exists')
  # Clean up
  unlink(scss_file)
  expect_false(file.exists(scss_file))
})
