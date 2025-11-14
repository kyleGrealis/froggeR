# Tests for save_variables() function

test_that("save_variables errors when no project _variables.yml exists", {
  tmp_dir <- withr::local_tempdir()
  mockery::stub(froggeR::save_variables, "here::here", tmp_dir)

  # Expect a message about missing file
  expect_message(froggeR::save_variables(), "No current _variables.yml file exists")
})

test_that("save_variables returns NULL invisibly", {
  tmp_project <- withr::local_tempdir()
  project_vars <- file.path(tmp_project, "_variables.yml")
  yaml::write_yaml(list(name = "Test"), project_vars)

  config_dir <- withr::local_tempdir()

  mockery::stub(froggeR::save_variables, "here::here", tmp_project)
  mockery::stub(froggeR::save_variables, "rappdirs::user_config_dir", config_dir)

  result <- suppressMessages(suppressWarnings(froggeR::save_variables()))
  expect_null(result)
})

test_that("save_variables prints success message on completion", {
  tmp_project <- withr::local_tempdir()
  project_vars <- file.path(tmp_project, "_variables.yml")
  yaml::write_yaml(list(name = "Test"), project_vars)

  config_dir <- withr::local_tempdir()

  mockery::stub(froggeR::save_variables, "here::here", tmp_project)
  mockery::stub(froggeR::save_variables, "rappdirs::user_config_dir", config_dir)

  # The function should print completion messages
  expect_message(froggeR::save_variables(), "Saved _variables.yml to system configuration")
})
