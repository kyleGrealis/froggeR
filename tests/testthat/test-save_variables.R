# Tests for save_variables() function

test_that("save_variables errors when no project _variables.yml exists", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(here = function(...) tmp_dir, .package = "here")

  expect_message(save_variables(), "No current _variables.yml file exists")
})

test_that("save_variables saves to global config when no global config exists", {
  tmp_project <- withr::local_tempdir()
  project_vars <- file.path(tmp_project, "_variables.yml")
  yaml::write_yaml(list(name = "Test User", email = "test@example.com"), project_vars)

  config_dir <- withr::local_tempdir()

  local_mocked_bindings(here = function(...) tmp_project, .package = "here")
  local_mocked_bindings(user_config_dir = function(...) config_dir, .package = "rappdirs")

  # Should copy without prompting since no global config exists
  suppressMessages(save_variables())

  saved_vars <- file.path(config_dir, "_variables.yml")
  expect_true(file.exists(saved_vars))

  saved_content <- yaml::read_yaml(saved_vars)
  expect_equal(saved_content$name, "Test User")
  expect_equal(saved_content$email, "test@example.com")
})

test_that("save_variables prompts for overwrite when global file exists and user confirms", {
  tmp_project <- withr::local_tempdir()
  project_vars <- file.path(tmp_project, "_variables.yml")
  yaml::write_yaml(list(name = "New Name", email = "new@example.com"), project_vars)

  config_dir <- withr::local_tempdir()
  existing_vars <- file.path(config_dir, "_variables.yml")
  yaml::write_yaml(list(name = "Old Name", email = "old@example.com"), existing_vars)

  local_mocked_bindings(here = function(...) tmp_project, .package = "here")
  local_mocked_bindings(user_config_dir = function(...) config_dir, .package = "rappdirs")
  local_mocked_bindings(ui_yeah = function(...) TRUE, .package = "froggeR")

  # Should overwrite when user confirms
  suppressMessages(save_variables())

  saved_content <- yaml::read_yaml(existing_vars)
  expect_equal(saved_content$name, "New Name")
  expect_equal(saved_content$email, "new@example.com")
})

test_that("save_variables respects user declining overwrite", {
  tmp_project <- withr::local_tempdir()
  project_vars <- file.path(tmp_project, "_variables.yml")
  yaml::write_yaml(list(name = "New Name", email = "new@example.com"), project_vars)

  config_dir <- withr::local_tempdir()
  existing_vars <- file.path(config_dir, "_variables.yml")
  yaml::write_yaml(list(name = "Old Name", email = "old@example.com"), existing_vars)

  local_mocked_bindings(here = function(...) tmp_project, .package = "here")
  local_mocked_bindings(user_config_dir = function(...) config_dir, .package = "rappdirs")
  local_mocked_bindings(ui_yeah = function(...) FALSE, .package = "froggeR")

  # Should not overwrite when user declines
  suppressMessages(save_variables())

  saved_content <- yaml::read_yaml(existing_vars)
  expect_equal(saved_content$name, "Old Name")
  expect_equal(saved_content$email, "old@example.com")
})

test_that("save_variables returns NULL invisibly", {
  tmp_project <- withr::local_tempdir()
  project_vars <- file.path(tmp_project, "_variables.yml")
  yaml::write_yaml(list(name = "Test"), project_vars)

  config_dir <- withr::local_tempdir()

  local_mocked_bindings(here = function(...) tmp_project, .package = "here")
  local_mocked_bindings(user_config_dir = function(...) config_dir, .package = "rappdirs")

  result <- suppressMessages(suppressWarnings(save_variables()))
  expect_null(result)
})

test_that("save_variables prints success message on completion", {
  tmp_project <- withr::local_tempdir()
  project_vars <- file.path(tmp_project, "_variables.yml")
  yaml::write_yaml(list(name = "Test"), project_vars)

  config_dir <- withr::local_tempdir()

  local_mocked_bindings(here = function(...) tmp_project, .package = "here")
  local_mocked_bindings(user_config_dir = function(...) config_dir, .package = "rappdirs")

  # The function should print completion messages
  expect_message(save_variables(), "Saved _variables.yml to system configuration")
})

test_that("save_variables prints no-change message when user declines overwrite", {
  tmp_project <- withr::local_tempdir()
  project_vars <- file.path(tmp_project, "_variables.yml")
  yaml::write_yaml(list(name = "Test"), project_vars)

  config_dir <- withr::local_tempdir()
  existing_vars <- file.path(config_dir, "_variables.yml")
  yaml::write_yaml(list(name = "Existing"), existing_vars)

  local_mocked_bindings(here = function(...) tmp_project, .package = "here")
  local_mocked_bindings(user_config_dir = function(...) config_dir, .package = "rappdirs")
  local_mocked_bindings(ui_yeah = function(...) FALSE, .package = "froggeR")

  expect_message(save_variables(), "No changes were made")
})
