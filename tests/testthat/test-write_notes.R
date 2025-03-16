test_that("write_notes fails with bad path", {
  expect_error(write_notes(path = "bad_path"), "Invalid `path`.")
  expect_error(write_notes(path = " "), "Invalid `path`.")
  expect_error(write_notes(path = NULL), "Invalid `path`.")
})

test_that("write_notes creates the notes file correctly", {
  tmp_dir <- tempdir()
  notes_file <- file.path(tmp_dir, "dated_progress_notes.md")
  # Remove any prior instances
  unlink(notes_file)
  write_notes(tmp_dir, .initialize_proj = FALSE)
  expect_true(file.exists(notes_file))
  # Clean up
  unlink(notes_file)
  expect_false(file.exists(notes_file))
})

test_that('write_notes creates content correctly', {
  tmp_dir <- tempdir()
  notes_file <- file.path(tmp_dir, "dated_progress_notes.md")
  # Remove any prior instances
  unlink(notes_file)
  suppressMessages(write_notes(tmp_dir, .initialize_proj = TRUE))
  # Check content
  file_content <- readLines(notes_file)
  expect_true("# Project updates" %in% file_content)
  expect_true(any(grepl(": project started$", file_content)))
  # Clean up
  unlink(notes_file)
  expect_false(file.exists(notes_file))
})

test_that('write_notes recognizes overwrite error', {
  tmp_dir <- tempdir()
  notes_file <- file.path(tmp_dir, "dated_progress_notes.md")
  # Remove any prior instances
  unlink(notes_file)
  suppressMessages(write_notes(tmp_dir, .initialize_proj = TRUE))
  # Test for error
  expect_error(write_notes(tmp_dir, .initialize_proj = TRUE), 'already exists')
  # Clean up
  unlink(notes_file)
  expect_false(file.exists(notes_file))
})
