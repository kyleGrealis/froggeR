test_that("write_notes creates notes file correctly", {
  tmp_dir <- tempdir()
  notes_path <- file.path(tmp_dir, "dated_progress_notes.md")
  
  # Ensure the file doesn't exist before the test
  if (file.exists(notes_path)) file.remove(notes_path)
  
  # Create the file
  write_notes(path = tmp_dir)
  expect_true(file.exists(notes_path))
  
  # Check content
  content <- readLines(notes_path)
  expect_true(grepl("project started", content[2]))
  
  # Test no overwrite
  expect_error(write_notes(path = tmp_dir), "has been found")
  
  # Cleanup after test
  if (file.exists(notes_path)) file.remove(notes_path)
})
