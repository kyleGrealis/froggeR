test_that("validates write_ignore path", {
  expect_error(write_ignore(path = NULL), "Invalid `path`.")
  expect_error(write_ignore(path = " "), "Invalid `path`.")
})

test_that("write_ignore creates enhanced .gitignore file correctly", {
  tmp_dir <- tempdir()
  unlink(file.path(tmp_dir, ".gitignore"))
  
  the_ignore_path <- file.path(tmp_dir, ".gitignore")
  
  # Ensure the file doesn't exist before the test
  unlink(the_ignore_path)
  if (file.exists(the_ignore_path)) file.remove(the_ignore_path)
  
  # Create the file
  write_ignore(path = tmp_dir)
  expect_true(file.exists(the_ignore_path))
  
  # # Check content
  content <- suppressWarnings(readLines(the_ignore_path))
  expect_true("# History files" %in% content)  # beginning of .gitignore
  expect_true("# Quarto" %in% content)         # at the end of .gitignore
  
  # Test no overwrite
  if (interactive()) expect_error(write_ignore(path = tmp_dir), "found in project")
  
  # Cleanup after test
  unlink(the_ignore_path)
  if (file.exists(the_ignore_path)) file.remove(the_ignore_path)
})
