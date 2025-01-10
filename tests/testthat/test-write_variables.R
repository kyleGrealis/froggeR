test_that("write_variables fails with bad path", {
  expect_error(write_variables(path = 'bad_path'), 'Invalid `path`.')
  expect_error(write_variables(path = ' '), 'Invalid `path`.')
  expect_error(write_variables(path = NULL), 'Invalid `path`.')
})

test_that("write_variables creates _variables.yml correctly", {
  tmp_dir <- tempdir()
  variables_file <- file.path(tmp_dir, "_variables.yml")
  # Remove any prior instances
  unlink(variables_file)
  write_variables(tmp_dir, .initialize_proj = FALSE)
  expect_true(file.exists(variables_file))
  # Clean up
  unlink(variables_file)
  expect_false(file.exists(variables_file))
})

test_that("write_variables creates content correctly", {
  tmp_dir <- tempdir()
  variables_file <- file.path(tmp_dir, "_variables.yml")
  # Remove any prior instances
  unlink(variables_file)
  suppressMessages(write_variables(tmp_dir, .initialize_proj = TRUE))
  # Check content
  file_content <- readLines(variables_file)
  expect_true(any(grepl('^name: ', file_content)))
  expect_true(any(grepl('^email: ', file_content)))
  expect_true(any(grepl('^orcid: ', file_content)))
  expect_true(any(grepl('^url: ', file_content)))
  expect_true(any(grepl(': Table of Contents$', file_content)))
  # Clean up
  unlink(variables_file)
  expect_false(file.exists(variables_file))
})

test_that('write_variables recognizes overwrite error', {
  tmp_dir <- tempdir()
  variables_file <- file.path(tmp_dir, "_variables.yml")
  # Remove any prior instances
  unlink(variables_file)
  suppressMessages(write_variables(tmp_dir, .initialize_proj = TRUE))
  # Test for error
  expect_error(write_variables(tmp_dir, .initialize_proj = TRUE), 'already exists')
  # Clean up
  unlink(variables_file)
  expect_false(file.exists(variables_file))
})
