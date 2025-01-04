# Load required libraries
library(testthat)
library(withr)

test_that("write_scss creates the SCSS file correctly", {
  
  # Set up a temporary directory
  tmp_dir <- tempdir()
  
  # Define file path
  file_path <- file.path(tmp_dir, "custom.scss")
  
  # Ensure the file doesn't exist before the test
  if (file.exists(file_path)) file.remove(file_path)
  
  # Test: Create a custom.scss file
  file_path <- write_scss(name = "custom", path = tmp_dir)
  
  # Expectations: File is created
  expect_true(file.exists(file_path))
  expect_equal(file_path, file.path(tmp_dir, "custom.scss"))
  
  # Check the content of the file
  file_content <- readLines(file_path)
  expect_true("/*-- scss:defaults --*/" %in% file_content)
  expect_true("// $primary: #2c365e;" %in% file_content)
  expect_true("// $font-family-sans-serif: \"Open Sans\", sans-serif;" %in% file_content)
  
  # Test: Attempting to overwrite should error
  expect_error(
    write_scss(name = "custom", path = tmp_dir),
    "A file named \"custom.scss\" already exists!"
  )
  
  # Cleanup
  file.remove(file_path)
})

test_that("write_scss validates input arguments", {
  
  # Invalid name
  expect_error(write_scss(name = "", path = tempdir()), "Invalid `name`")
  
  # Non-existent path
  invalid_path <- file.path(tempdir(), "non_existent_dir")
  expect_error(write_scss(name = "custom", path = invalid_path), "Invalid `path`")
})

test_that("write_scss handles interactive vs non-interactive modes", {
  
  # Set up a temporary directory
  tmp_dir <- tempdir()
  
  # Simulate interactive session
  withr::with_envvar(
    list(R_INTERACTIVE = "1"), 
    {
      # Define file path
      file_path <- file.path(tmp_dir, "interactive_test.scss")
      
      # Ensure the file doesn't exist before the test
      if (file.exists(file_path)) file.remove(file_path)
      
      # Test: Create the SCSS file
      file_path <- write_scss(name = "interactive_test", path = tmp_dir)
      expect_true(file.exists(file_path))
      
      # Cleanup
      file.remove(file_path)
    }
  )
  
  # Simulate non-interactive session
  withr::with_envvar(
    list(R_INTERACTIVE = "0"), 
    {
      # Define file path
      file_path <- file.path(tmp_dir, "noninteractive_test.scss")
      
      # Ensure the file doesn't exist before the test
      if (file.exists(file_path)) file.remove(file_path)
      
      # Test: Create the SCSS file
      file_path <- write_scss(name = "noninteractive_test", path = tmp_dir)
      expect_true(file.exists(file_path))
      
      # Cleanup
      file.remove(file_path)
    }
  )
})
