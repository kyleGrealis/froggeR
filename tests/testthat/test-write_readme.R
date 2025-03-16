test_that("write_readme fails with bad path", {
  expect_error(write_readme(path = "bad_path"), "Invalid `path`.")
  expect_error(write_readme(path = " "), "Invalid `path`.")
  expect_error(write_readme(path = NULL), "Invalid `path`.")
})

test_that("write_readme creates the README file correctly", {
  tmp_dir <- tempdir()
  readme_file <- file.path(tmp_dir, "README.md")
  # Remove any prior instances
  unlink(readme_file)
  write_readme(tmp_dir, .initialize_proj = FALSE)
  expect_true(file.exists(readme_file))
  # Clean up
  unlink(readme_file)
  expect_false(file.exists(readme_file))
})

test_that('write_readme creates content correctly', {
  tmp_dir <- tempdir()
  readme_file <- file.path(tmp_dir, "README.md")
  # Remove any prior instances
  unlink(readme_file)
  suppressMessages(write_readme(tmp_dir, .initialize_proj = TRUE))
  # Check content
  file_content <- readLines(readme_file)
  expect_true(any(grepl("Code Author", file_content)))
  expect_true(any(grepl("## Directories", file_content)))
  expect_true(any(grepl("File Descriptions", file_content)))
  # Clean up
  unlink(readme_file)
  expect_false(file.exists(readme_file))
})

test_that('write_readme recognizes overwrite error', {
  tmp_dir <- tempdir()
  readme_file <- file.path(tmp_dir, "README.md")
  # Remove any prior instances
  unlink(readme_file)
  suppressMessages(write_readme(tmp_dir, .initialize_proj = TRUE))
  # Test for error
  expect_error(write_readme(tmp_dir, .initialize_proj = TRUE), 'already exists')
  # Clean up
  unlink(readme_file)
  expect_false(file.exists(readme_file))
})
