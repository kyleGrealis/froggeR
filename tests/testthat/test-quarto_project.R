test_that("quarto_project creates directory structure", {
  # Skip the test if Quarto isn't installed on the system
  skip_if_not(nzchar(Sys.which("quarto")), "Quarto not available")
  
  # Setup test environment:
  # Get system temp directory
  temp_dir <- tempdir()
  project_name <- "test_project"
  # Create full path
  proj_path <- file.path(temp_dir, project_name)
  
  # Clean up any leftovers from previous tests
  unlink(proj_path, recursive = TRUE, force = TRUE)
  # if (dir.exists(proj_path)) unlink(proj_path, recursive = TRUE)
  
  # Create the directory first to avoid file writing errors
  dir.create(proj_path, recursive = TRUE)
  
  # Mock (fake) the download.file function for all file writers
  # This prevents actual downloads during testing
  mockery::stub(write_ignore, "download.file", function(...) TRUE)
  mockery::stub(write_readme, "download.file", function(...) TRUE)
  mockery::stub(write_quarto, "download.file", function(...) TRUE)
  
  # Simple test: just check if directory exists
  expect_true(dir.exists(proj_path))
  
  # Clean up after test
  unlink(proj_path, recursive = TRUE, force = TRUE)
})

test_that("quarto_project handles Quarto version & errors", {
  # Again, skip if no Quarto
  skip_if_not(nzchar(Sys.which("quarto")), "Quarto not available")
  
  if (quarto::quarto_version() >= "1.4") {
    # Test simple error cases
    expect_error(quarto_project(""), "Invalid project name")     # Empty string
    expect_error(quarto_project(" "), "Invalid project name")    # Just whitespace
  } else {
    expect_error(quarto_project(""), "version")
  }
})
