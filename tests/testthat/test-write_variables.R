test_that("write_variables fails with bad path", {
  expect_error(write_variables(path = 'bad_path'))
})

test_that("write_variables creates or updates _variables.yml correctly", {
  tmp_dir <- tempdir()
  variables_file <- file.path(tmp_dir, "_variables.yml")
  
  # Ensure no pre-existing file
  unlink(variables_file, force = TRUE)
  expect_false(file.exists(variables_file))
  
  # Mock settings for the test
  mock_settings <- list(
    name = "Test User",
    email = "test@example.com",
    orcid = "0000-0000-0000-0000",
    url = "https://example.com",
    affiliations = "Test Institution",
    toc = "Table of Contents"
  )
  
  # Create the _variables.yml file
  write_variables(path = tmp_dir, settings = mock_settings)
  expect_true(file.exists(variables_file))
  
  # Validate content
  content <- yaml::read_yaml(variables_file)
  expect_equal(content, mock_settings)
  
  # Test overwrite behavior
  new_settings <- list(
    name = "New User",
    email = "new@example.com",
    orcid = "1234-5678-9012-3456",
    url = "https://newexample.com",
    affiliations = "New Institution",
    toc = "Updated Table of Contents"
  )
  write_variables(path = tmp_dir, settings = new_settings)
  updated_content <- yaml::read_yaml(variables_file)
  expect_equal(updated_content, new_settings)
  
  # Cleanup after test
  unlink(variables_file, force = TRUE)
  expect_false(file.exists(variables_file))
})
