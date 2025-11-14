# Tests for write_variables() and create_variables() functions

# Tests for write_variables() ------------------------------------------------

test_that("write_variables creates _variables.yml file in valid directory", {
  tmp_dir <- withr::local_tempdir()

  # Stub interactive() to return FALSE to avoid editor launch
  mockery::stub(froggeR::write_variables, "interactive", FALSE)

  # Call the function
  result <- suppressMessages(froggeR::write_variables(tmp_dir))

  # Check that file was created
  expect_true(file.exists(file.path(tmp_dir, "_variables.yml")))

  # Check that function returns the file path invisibly
  expect_type(result, "character")
  expect_equal(result, normalizePath(file.path(tmp_dir, "_variables.yml")))
})

test_that("write_variables errors when directory does not exist", {
  expect_error(
    froggeR::write_variables("/nonexistent/directory/path"),
    class = "froggeR_invalid_path"
  )
})

test_that("write_variables errors when _variables.yml already exists", {
  tmp_dir <- withr::local_tempdir()

  # Create an existing _variables.yml file
  existing_file <- file.path(tmp_dir, "_variables.yml")
  writeLines("existing: content", existing_file)

  # Stub interactive() to return FALSE
  mockery::stub(froggeR::write_variables, "interactive", FALSE)

  # Expect error about file already existing
  expect_error(
    suppressMessages(froggeR::write_variables(tmp_dir)),
    class = "froggeR_file_exists"
  )
})

test_that("write_variables does not call edit_file when non-interactive", {
  tmp_dir <- withr::local_tempdir()

  # Stub interactive() to return FALSE
  mockery::stub(froggeR::write_variables, "interactive", FALSE)

  # Mock usethis::edit_file to verify it's not called
  edit_mock <- mockery::mock()
  mockery::stub(froggeR::write_variables, "usethis::edit_file", edit_mock)

  # Call the function
  suppressMessages(froggeR::write_variables(tmp_dir))

  # Verify edit_file was never called
  mockery::expect_called(edit_mock, 0)
})

# Tests for create_variables() (internal) ------------------------------------

test_that("create_variables creates file with valid YAML structure", {
  tmp_dir <- withr::local_tempdir()

  # Call the internal function
  result <- suppressMessages(froggeR:::create_variables(tmp_dir))

  # Check that file was created
  expect_true(file.exists(result))

  # Read the created file and verify it's valid YAML
  content <- yaml::read_yaml(result)
  expect_type(content, "list")

  # Check that expected fields exist (based on config.yml template)
  expect_true(any(c("name", "email", "orcid", "url", "github", "affiliations") %in% names(content)))
})

test_that("create_variables returns character path", {
  tmp_dir <- withr::local_tempdir()

  result <- suppressMessages(froggeR:::create_variables(tmp_dir))

  expect_type(result, "character")
  expect_equal(basename(result), "_variables.yml")
  expect_equal(normalizePath(dirname(result)), normalizePath(tmp_dir))
})

test_that("create_variables errors when path is invalid", {
  expect_error(
    froggeR:::create_variables(NULL),
    class = "froggeR_invalid_path"
  )

  expect_error(
    froggeR:::create_variables(NA_character_),
    class = "froggeR_invalid_path"
  )

  expect_error(
    froggeR:::create_variables("/totally/fake/path"),
    class = "froggeR_invalid_path"
  )
})

test_that("create_variables errors when _variables.yml already exists", {
  tmp_dir <- withr::local_tempdir()

  # Create an existing _variables.yml file
  existing_file <- file.path(tmp_dir, "_variables.yml")
  writeLines("existing: content", existing_file)

  # Expect error about file already existing
  expect_error(
    suppressMessages(froggeR:::create_variables(tmp_dir)),
    "_variables.yml already exists",
    class = "froggeR_file_exists"
  )
})

test_that("create_variables creates file with expected YAML keys", {
  tmp_dir <- withr::local_tempdir()

  # Create the variables file (will use whatever template/config exists)
  result <- suppressMessages(froggeR:::create_variables(tmp_dir))

  # Verify file was created
  expect_true(file.exists(result))

  # Read the created file and verify it has valid YAML with expected keys
  content <- yaml::read_yaml(result)
  expect_type(content, "list")

  # Should have standard metadata fields
  expected_keys <- c("name", "email", "orcid", "url", "github", "affiliations")
  actual_keys <- names(content)
  expect_true(any(expected_keys %in% actual_keys))
})

# Tests for .handle_global_variables_migration() -----------------------------

test_that(".handle_global_variables_migration renames old config.yml to _variables.yml", {
  tmp_config <- withr::local_tempdir()

  # Create old config.yml file
  old_config <- file.path(tmp_config, "config.yml")
  yaml::write_yaml(
    list(name = "Old Config User", email = "old@example.com"),
    old_config
  )

  # Call the migration function
  result <- suppressMessages(froggeR:::.handle_global_variables_migration(tmp_config))

  # The function should return the new path
  expect_equal(result, file.path(tmp_config, "_variables.yml"))

  # The old config.yml should be renamed to _variables.yml
  expect_true(file.exists(file.path(tmp_config, "_variables.yml")))
  expect_false(file.exists(old_config))
})

test_that(".handle_global_variables_migration returns _variables.yml path when it exists", {
  tmp_config <- withr::local_tempdir()

  # Create _variables.yml directly
  new_config <- file.path(tmp_config, "_variables.yml")
  yaml::write_yaml(list(name = "Test"), new_config)

  # Call the migration function
  result <- suppressMessages(froggeR:::.handle_global_variables_migration(tmp_config))

  # Should return the _variables.yml path
  expect_equal(result, new_config)
  expect_true(file.exists(new_config))
})

test_that(".handle_global_variables_migration returns _variables.yml path when neither exists", {
  tmp_config <- withr::local_tempdir()

  # Call the migration function with no existing files
  result <- froggeR:::.handle_global_variables_migration(tmp_config)

  # Should return the _variables.yml path (even though it doesn't exist yet)
  expect_equal(result, file.path(tmp_config, "_variables.yml"))
})
