# Tests for save_brand() function

test_that("save_brand errors when no project _brand.yml exists", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(here = function(...) tmp_dir, .package = "here")

  expect_message(save_brand(), "No current _brand.yml file exists")
})

test_that("save_brand saves to global config when no global config exists", {
  tmp_project <- withr::local_tempdir()
  project_brand <- file.path(tmp_project, "_brand.yml")
  yaml::write_yaml(list(brand = "TestBrand", color = "blue"), project_brand)

  config_dir <- withr::local_tempdir()

  local_mocked_bindings(here = function(...) tmp_project, .package = "here")
  local_mocked_bindings(user_config_dir = function(...) config_dir, .package = "rappdirs")

  # Should copy without prompting since no global config exists
  suppressMessages(save_brand(save_logos = FALSE))

  saved_brand <- file.path(config_dir, "_brand.yml")
  expect_true(file.exists(saved_brand))

  saved_content <- yaml::read_yaml(saved_brand)
  expect_equal(saved_content$brand, "TestBrand")
  expect_equal(saved_content$color, "blue")
})

test_that("save_brand prompts for overwrite when global file exists and user confirms", {
  tmp_project <- withr::local_tempdir()
  project_brand <- file.path(tmp_project, "_brand.yml")
  yaml::write_yaml(list(brand = "NewBrand", color = "red"), project_brand)

  config_dir <- withr::local_tempdir()
  existing_brand <- file.path(config_dir, "_brand.yml")
  yaml::write_yaml(list(brand = "OldBrand", color = "green"), existing_brand)

  local_mocked_bindings(here = function(...) tmp_project, .package = "here")
  local_mocked_bindings(user_config_dir = function(...) config_dir, .package = "rappdirs")
  local_mocked_bindings(ui_yeah = function(...) TRUE, .package = "froggeR")

  # Should overwrite when user confirms
  suppressMessages(save_brand(save_logos = FALSE))

  saved_content <- yaml::read_yaml(existing_brand)
  expect_equal(saved_content$brand, "NewBrand")
  expect_equal(saved_content$color, "red")
})

test_that("save_brand respects user declining overwrite", {
  tmp_project <- withr::local_tempdir()
  project_brand <- file.path(tmp_project, "_brand.yml")
  yaml::write_yaml(list(brand = "NewBrand", color = "red"), project_brand)

  config_dir <- withr::local_tempdir()
  existing_brand <- file.path(config_dir, "_brand.yml")
  yaml::write_yaml(list(brand = "OldBrand", color = "green"), existing_brand)

  local_mocked_bindings(here = function(...) tmp_project, .package = "here")
  local_mocked_bindings(user_config_dir = function(...) config_dir, .package = "rappdirs")
  local_mocked_bindings(ui_yeah = function(...) FALSE, .package = "froggeR")

  # Should not overwrite when user declines
  suppressMessages(save_brand(save_logos = FALSE))

  saved_content <- yaml::read_yaml(existing_brand)
  expect_equal(saved_content$brand, "OldBrand")
  expect_equal(saved_content$color, "green")
})

test_that("save_brand skips logo copying when save_logos = FALSE", {
  tmp_project <- withr::local_tempdir()
  project_brand <- file.path(tmp_project, "_brand.yml")
  yaml::write_yaml(list(brand = "TestBrand"), project_brand)

  # Create logos directory in project
  logos_dir <- file.path(tmp_project, "logos")
  dir.create(logos_dir)
  writeLines("logo content", file.path(logos_dir, "logo.png"))

  config_dir <- withr::local_tempdir()

  local_mocked_bindings(here = function(...) tmp_project, .package = "here")
  local_mocked_bindings(user_config_dir = function(...) config_dir, .package = "rappdirs")

  # Should not copy logos when save_logos = FALSE
  suppressMessages(save_brand(save_logos = FALSE))

  expect_false(dir.exists(file.path(config_dir, "logos")))
})

test_that("save_brand copies logos directory when save_logos = TRUE and no global logos exist", {
  tmp_project <- withr::local_tempdir()
  project_brand <- file.path(tmp_project, "_brand.yml")
  yaml::write_yaml(list(brand = "TestBrand"), project_brand)

  # Create logos directory in project
  logos_dir <- file.path(tmp_project, "logos")
  dir.create(logos_dir)
  writeLines("logo content", file.path(logos_dir, "logo.png"))

  config_dir <- withr::local_tempdir()

  local_mocked_bindings(here = function(...) tmp_project, .package = "here")
  local_mocked_bindings(user_config_dir = function(...) config_dir, .package = "rappdirs")

  # Temporarily change working directory for the test
  withr::with_dir(tmp_project, {
    suppressMessages(save_brand(save_logos = TRUE))
  })

  expect_true(dir.exists(file.path(config_dir, "logos")))
  expect_true(file.exists(file.path(config_dir, "logos", "logo.png")))
})

test_that("save_brand prompts for overwrite when global logos exist and user confirms", {
  tmp_project <- withr::local_tempdir()
  project_brand <- file.path(tmp_project, "_brand.yml")
  yaml::write_yaml(list(brand = "TestBrand"), project_brand)

  # Create logos directory in project
  logos_dir <- file.path(tmp_project, "logos")
  dir.create(logos_dir)
  writeLines("new logo content", file.path(logos_dir, "logo.png"))

  config_dir <- withr::local_tempdir()

  # Create existing logos in config
  config_logos <- file.path(config_dir, "logos")
  dir.create(config_logos)
  writeLines("old logo content", file.path(config_logos, "logo.png"))

  local_mocked_bindings(here = function(...) tmp_project, .package = "here")
  local_mocked_bindings(user_config_dir = function(...) config_dir, .package = "rappdirs")
  local_mocked_bindings(ui_yeah = function(...) TRUE, .package = "froggeR")

  # Temporarily change working directory for the test
  withr::with_dir(tmp_project, {
    suppressMessages(save_brand(save_logos = TRUE))
  })

  # Should have new logo content
  logo_content <- readLines(file.path(config_logos, "logo.png"))
  expect_equal(logo_content, "new logo content")
})

test_that("save_brand respects user declining logos overwrite", {
  tmp_project <- withr::local_tempdir()
  project_brand <- file.path(tmp_project, "_brand.yml")
  yaml::write_yaml(list(brand = "TestBrand"), project_brand)

  # Create logos directory in project
  logos_dir <- file.path(tmp_project, "logos")
  dir.create(logos_dir)
  writeLines("new logo content", file.path(logos_dir, "logo.png"))

  config_dir <- withr::local_tempdir()

  # Create existing logos in config
  config_logos <- file.path(config_dir, "logos")
  dir.create(config_logos)
  writeLines("old logo content", file.path(config_logos, "logo.png"))

  local_mocked_bindings(here = function(...) tmp_project, .package = "here")
  local_mocked_bindings(user_config_dir = function(...) config_dir, .package = "rappdirs")
  local_mocked_bindings(ui_yeah = function(...) FALSE, .package = "froggeR")

  # Temporarily change working directory for the test
  withr::with_dir(tmp_project, {
    suppressMessages(save_brand(save_logos = TRUE))
  })

  # Should still have old logo content
  logo_content <- readLines(file.path(config_logos, "logo.png"))
  expect_equal(logo_content, "old logo content")
})

test_that("save_brand handles missing logos directory gracefully", {
  tmp_project <- withr::local_tempdir()
  project_brand <- file.path(tmp_project, "_brand.yml")
  yaml::write_yaml(list(brand = "TestBrand"), project_brand)

  # No logos directory created

  config_dir <- withr::local_tempdir()

  local_mocked_bindings(here = function(...) tmp_project, .package = "here")
  local_mocked_bindings(user_config_dir = function(...) config_dir, .package = "rappdirs")

  # Temporarily change working directory for the test
  withr::with_dir(tmp_project, {
    # Should handle missing logos gracefully
    expect_message(save_brand(save_logos = TRUE), "No project-level 'logos' directory")
  })

  expect_false(dir.exists(file.path(config_dir, "logos")))
})

test_that("save_brand returns NULL invisibly", {
  tmp_project <- withr::local_tempdir()
  project_brand <- file.path(tmp_project, "_brand.yml")
  yaml::write_yaml(list(brand = "TestBrand"), project_brand)

  config_dir <- withr::local_tempdir()

  local_mocked_bindings(here = function(...) tmp_project, .package = "here")
  local_mocked_bindings(user_config_dir = function(...) config_dir, .package = "rappdirs")

  result <- suppressMessages(save_brand(save_logos = FALSE))
  expect_null(result)
})

test_that("save_brand prints success message on completion", {
  tmp_project <- withr::local_tempdir()
  project_brand <- file.path(tmp_project, "_brand.yml")
  yaml::write_yaml(list(brand = "TestBrand"), project_brand)

  config_dir <- withr::local_tempdir()

  local_mocked_bindings(here = function(...) tmp_project, .package = "here")
  local_mocked_bindings(user_config_dir = function(...) config_dir, .package = "rappdirs")

  # The function should print completion messages
  expect_message(save_brand(save_logos = FALSE), "Saved _brand.yml to system configuration")
})
