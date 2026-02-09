library(testthat)
library(froggeR)


# Test init() basic behavior ====

test_that("init creates expected directory structure from template", {
  tmp_dir <- withr::local_tempdir()
  project_dir <- file.path(tmp_dir, "myproject")
  dir.create(project_dir)

  fake_zip <- tempfile(fileext = ".zip")
  .create_fake_template_zip(fake_zip)

  local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      file.copy(fake_zip, destfile, overwrite = TRUE)
      0L
    },
    .package = "utils"
  )
  local_mocked_bindings(
    user_config_dir = function(...) file.path(tmp_dir, "no_config"),
    .package = "rappdirs"
  )

  result <- init(path = project_dir)

  # Template directories should exist
  expect_true(dir.exists(file.path(project_dir, "R")))
  expect_true(dir.exists(file.path(project_dir, "pages")))
  expect_true(dir.exists(file.path(project_dir, "www")))
  expect_true(dir.exists(file.path(project_dir, "logos")))

  # data/ should be created by init even though it's not in template
  expect_true(dir.exists(file.path(project_dir, "data")))

  # Template files should exist
  expect_true(file.exists(file.path(project_dir, "_quarto.yml")))
  expect_true(file.exists(file.path(project_dir, "_brand.yml")))
  expect_true(file.exists(file.path(project_dir, "README.md")))
  expect_true(file.exists(file.path(project_dir, ".gitignore")))

  unlink(fake_zip)
})

test_that("init returns path invisibly", {
  tmp_dir <- withr::local_tempdir()
  project_dir <- file.path(tmp_dir, "myproject")
  dir.create(project_dir)

  fake_zip <- tempfile(fileext = ".zip")
  .create_fake_template_zip(fake_zip)

  local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      file.copy(fake_zip, destfile, overwrite = TRUE)
      0L
    },
    .package = "utils"
  )
  local_mocked_bindings(
    user_config_dir = function(...) file.path(tmp_dir, "no_config"),
    .package = "rappdirs"
  )

  result <- init(path = project_dir)

  expect_equal(normalizePath(result), normalizePath(project_dir))

  unlink(fake_zip)
})


# Config restore tests ====

test_that("init restores saved _variables.yml from global config", {
  tmp_dir <- withr::local_tempdir()
  project_dir <- file.path(tmp_dir, "myproject")
  dir.create(project_dir)

  # Set up fake global config
  fake_config <- file.path(tmp_dir, "config")
  dir.create(fake_config)
  writeLines("author:\n  name: Teek the Frog", file.path(fake_config, "_variables.yml"))

  fake_zip <- tempfile(fileext = ".zip")
  .create_fake_template_zip(fake_zip)

  local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      file.copy(fake_zip, destfile, overwrite = TRUE)
      0L
    },
    .package = "utils"
  )
  local_mocked_bindings(
    user_config_dir = function(...) fake_config,
    .package = "rappdirs"
  )

  init(path = project_dir)

  # _variables.yml should exist in project
  vars_file <- file.path(project_dir, "_variables.yml")
  expect_true(file.exists(vars_file))
  content <- readLines(vars_file)
  expect_true(any(grepl("Teek the Frog", content)))

  unlink(fake_zip)
})

test_that("init restores saved _brand.yml overwriting template version", {
  tmp_dir <- withr::local_tempdir()
  project_dir <- file.path(tmp_dir, "myproject")
  dir.create(project_dir)

  # Set up fake global config with custom brand
  fake_config <- file.path(tmp_dir, "config")
  dir.create(fake_config)
  writeLines("brand:\n  color:\n    primary: '#00FF00'", file.path(fake_config, "_brand.yml"))

  fake_zip <- tempfile(fileext = ".zip")
  .create_fake_template_zip(fake_zip)

  local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      file.copy(fake_zip, destfile, overwrite = TRUE)
      0L
    },
    .package = "utils"
  )
  local_mocked_bindings(
    user_config_dir = function(...) fake_config,
    .package = "rappdirs"
  )

  init(path = project_dir)

  # _brand.yml should contain the global version (overwritten)
  brand_content <- readLines(file.path(project_dir, "_brand.yml"))
  expect_true(any(grepl("#00FF00", brand_content)))

  unlink(fake_zip)
})

test_that("init restores saved logos from global config", {
  tmp_dir <- withr::local_tempdir()
  project_dir <- file.path(tmp_dir, "myproject")
  dir.create(project_dir)

  # Set up fake global config with logos
  fake_config <- file.path(tmp_dir, "config")
  dir.create(file.path(fake_config, "logos"), recursive = TRUE)
  writeLines("fake logo content", file.path(fake_config, "logos", "my-logo.png"))

  fake_zip <- tempfile(fileext = ".zip")
  .create_fake_template_zip(fake_zip)

  local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      file.copy(fake_zip, destfile, overwrite = TRUE)
      0L
    },
    .package = "utils"
  )
  local_mocked_bindings(
    user_config_dir = function(...) fake_config,
    .package = "rappdirs"
  )

  init(path = project_dir)

  # Logo should be in project
  expect_true(file.exists(file.path(project_dir, "logos", "my-logo.png")))

  unlink(fake_zip)
})


# Error handling tests ====

test_that("init creates non-existent directory", {
  tmp_dir <- withr::local_tempdir()
  project_dir <- file.path(tmp_dir, "brand-new-project")

  fake_zip <- tempfile(fileext = ".zip")
  .create_fake_template_zip(fake_zip)

  local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      file.copy(fake_zip, destfile, overwrite = TRUE)
      0L
    },
    .package = "utils"
  )
  local_mocked_bindings(
    user_config_dir = function(...) file.path(tmp_dir, "no_config"),
    .package = "rappdirs"
  )

  expect_false(dir.exists(project_dir))
  result <- init(path = project_dir)
  expect_true(dir.exists(project_dir))
  expect_true(file.exists(file.path(project_dir, "_quarto.yml")))

  unlink(fake_zip)
})

test_that("init errors on NULL path", {
  expect_error(
    init(path = NULL),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("init errors on NA path", {
  expect_error(
    init(path = NA),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("init handles download failure gracefully", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      stop("Connection refused")
    },
    .package = "utils"
  )

  expect_error(
    init(path = tmp_dir),
    "Failed to download",
    class = "froggeR_download_error"
  )
})

test_that("init handles empty zip gracefully", {
  tmp_dir <- withr::local_tempdir()

  # Create a zip with just a flat file (no subdirectory)
  empty_zip <- tempfile(fileext = ".zip")
  staging <- tempfile("empty_")
  dir.create(staging)
  writeLines("", file.path(staging, "dummy.txt"))
  withr::with_dir(staging, {
    utils::zip(empty_zip, files = "dummy.txt", flags = "-rq")
  })
  unlink(staging, recursive = TRUE)

  local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      file.copy(empty_zip, destfile, overwrite = TRUE)
      0L
    },
    .package = "utils"
  )

  # Flat zip has no subdirectories, so extracted_dirs will be empty
  expect_error(
    init(path = tmp_dir),
    "empty or could not be extracted",
    class = "froggeR_download_error"
  )

  unlink(empty_zip)
})


# data/ directory tests ====

test_that("init creates data/ directory even when template doesn't include it", {
  tmp_dir <- withr::local_tempdir()
  project_dir <- file.path(tmp_dir, "myproject")
  dir.create(project_dir)

  fake_zip <- tempfile(fileext = ".zip")
  .create_fake_template_zip(fake_zip)

  local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      file.copy(fake_zip, destfile, overwrite = TRUE)
      0L
    },
    .package = "utils"
  )
  local_mocked_bindings(
    user_config_dir = function(...) file.path(tmp_dir, "no_config"),
    .package = "rappdirs"
  )

  init(path = project_dir)

  expect_true(dir.exists(file.path(project_dir, "data")))

  unlink(fake_zip)
})


# No config restore when config doesn't exist ====

test_that("init works fine without any global config", {
  tmp_dir <- withr::local_tempdir()
  project_dir <- file.path(tmp_dir, "myproject")
  dir.create(project_dir)

  fake_zip <- tempfile(fileext = ".zip")
  .create_fake_template_zip(fake_zip)

  # Point to a non-existent config directory
  fake_config <- file.path(tmp_dir, "no_such_config")

  local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      file.copy(fake_zip, destfile, overwrite = TRUE)
      0L
    },
    .package = "utils"
  )
  local_mocked_bindings(
    user_config_dir = function(...) fake_config,
    .package = "rappdirs"
  )

  # Should not error
  result <- init(path = project_dir)
  expect_equal(normalizePath(result), normalizePath(project_dir))

  # Template files should still be there
  expect_true(file.exists(file.path(project_dir, "_quarto.yml")))

  unlink(fake_zip)
})


# Additive behavior tests ====

test_that("init skips existing files and does not overwrite them", {
  tmp_dir <- withr::local_tempdir()
  project_dir <- file.path(tmp_dir, "myproject")
  dir.create(project_dir)

  # Pre-populate with a README that should NOT be overwritten
  original_content <- "My existing README content"
  writeLines(original_content, file.path(project_dir, "README.md"))

  fake_zip <- tempfile(fileext = ".zip")
  .create_fake_template_zip(fake_zip)

  local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      file.copy(fake_zip, destfile, overwrite = TRUE)
      0L
    },
    .package = "utils"
  )
  local_mocked_bindings(
    user_config_dir = function(...) file.path(tmp_dir, "no_config"),
    .package = "rappdirs"
  )

  init(path = project_dir)

  # README.md should still have original content
  expect_equal(readLines(file.path(project_dir, "README.md")), original_content)

  # Template files that didn't exist should be created
  expect_true(file.exists(file.path(project_dir, "_quarto.yml")))
  expect_true(file.exists(file.path(project_dir, "_brand.yml")))

  unlink(fake_zip)
})

test_that("init does not overwrite pre-existing config files during restore", {
  tmp_dir <- withr::local_tempdir()
  project_dir <- file.path(tmp_dir, "myproject")
  dir.create(project_dir)

  # Pre-populate with existing _variables.yml
  original_vars <- "author:\n  name: Original Author"
  writeLines(original_vars, file.path(project_dir, "_variables.yml"))

  # Set up global config with different content
  fake_config <- file.path(tmp_dir, "config")
  dir.create(fake_config)
  writeLines(
    "author:\n  name: Global Config Author",
    file.path(fake_config, "_variables.yml")
  )

  fake_zip <- tempfile(fileext = ".zip")
  .create_fake_template_zip(fake_zip)

  local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      file.copy(fake_zip, destfile, overwrite = TRUE)
      0L
    },
    .package = "utils"
  )
  local_mocked_bindings(
    user_config_dir = function(...) fake_config,
    .package = "rappdirs"
  )

  init(path = project_dir)

  # Pre-existing _variables.yml should NOT be overwritten by config restore
  content <- readLines(file.path(project_dir, "_variables.yml"))
  expect_true(any(grepl("Original Author", content)))
  expect_false(any(grepl("Global Config Author", content)))

  unlink(fake_zip)
})
