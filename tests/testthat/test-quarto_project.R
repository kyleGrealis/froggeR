library(testthat)
library(froggeR)

# Tests for quarto_project() - Main exported function ====

# Quarto version requirement tests ====

test_that("quarto_project errors if Quarto version < 1.6", {
  tmp_dir <- withr::local_tempdir()

  # Mock old Quarto version
  mockery::stub(
    froggeR::quarto_project,
    "quarto::quarto_version",
    "1.5.0"
  )

  expect_error(
    froggeR::quarto_project(name = "test-project", path = tmp_dir),
    "Quarto version 1.6 or greater"
  )
})

test_that("quarto_project succeeds with Quarto version >= 1.6", {
  tmp_dir <- withr::local_tempdir()

  # Mock sufficient Quarto version and stub other external calls
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")
  mockery::stub(froggeR::quarto_project, "quarto::quarto_create_project", function(name, dir, ...) {
    # Create the project directory that Quarto would normally create
    dir.create(file.path(dir, name), recursive = TRUE)
  })
  mockery::stub(froggeR::quarto_project, "rstudioapi::openProject", function(...) NULL)

  expect_silent(
    suppressMessages(
      froggeR::quarto_project(name = "test-project", path = tmp_dir, example = FALSE)
    )
  )
})


# Path validation tests ====

test_that("quarto_project errors on NULL path", {
  # Mock Quarto version to pass version check
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")

  expect_error(
    froggeR::quarto_project(name = "test-project", path = NULL),
    "Invalid `path`"
  )
})

test_that("quarto_project errors on NA path", {
  # Mock Quarto version to pass version check
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")

  expect_error(
    froggeR::quarto_project(name = "test-project", path = NA),
    "Invalid `path`"
  )
})

test_that("quarto_project errors on nonexistent path", {
  fake_path <- file.path(tempdir(), "nonexistent_dir_xyz123")

  # Mock Quarto version to pass version check
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")

  expect_error(
    froggeR::quarto_project(name = "test-project", path = fake_path),
    "Invalid `path`"
  )
})


# Name validation tests ====

test_that("quarto_project errors on invalid project name with spaces", {
  tmp_dir <- withr::local_tempdir()

  # Mock Quarto version to pass version check
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")

  expect_error(
    froggeR::quarto_project(name = "test project", path = tmp_dir),
    "Invalid project name"
  )
})

test_that("quarto_project errors on invalid project name with special characters", {
  tmp_dir <- withr::local_tempdir()

  # Mock Quarto version
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")

  invalid_names <- c("test@project", "test.project", "test/project", "test\\project", "test!project")

  for (name in invalid_names) {
    expect_error(
      froggeR::quarto_project(name = name, path = tmp_dir),
      "Invalid project name"
    )
  }
})

test_that("quarto_project accepts valid project names", {
  tmp_dir <- withr::local_tempdir()

  # Mock all external calls
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")
  mockery::stub(froggeR::quarto_project, "quarto::quarto_create_project", function(name, dir, ...) {
    dir.create(file.path(dir, name), recursive = TRUE)
  })
  mockery::stub(froggeR::quarto_project, "rstudioapi::openProject", function(...) NULL)

  valid_names <- c("test", "test-project", "test_project", "TestProject", "test123", "test-123_abc")

  for (name in valid_names) {
    # Create a unique subdirectory for each test
    test_dir <- file.path(tmp_dir, paste0("test_", basename(tempfile())))
    dir.create(test_dir)

    expect_silent(
      suppressMessages(
        froggeR::quarto_project(name = name, path = test_dir, example = FALSE)
      )
    )
  }
})


# Example parameter validation tests ====

test_that("quarto_project errors when example is not logical", {
  tmp_dir <- withr::local_tempdir()

  # Mock Quarto version
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")

  expect_error(
    froggeR::quarto_project(name = "test-project", path = tmp_dir, example = "yes"),
    "must be TRUE or FALSE"
  )

  expect_error(
    froggeR::quarto_project(name = "test-project", path = tmp_dir, example = 1),
    "must be TRUE or FALSE"
  )

  expect_error(
    froggeR::quarto_project(name = "test-project", path = tmp_dir, example = NULL),
    "must be TRUE or FALSE"
  )
})

test_that("quarto_project accepts TRUE and FALSE for example parameter", {
  tmp_dir <- withr::local_tempdir()

  # Mock all external calls
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")
  mockery::stub(froggeR::quarto_project, "quarto::quarto_create_project", function(name, dir, ...) {
    dir.create(file.path(dir, name), recursive = TRUE)
  })
  mockery::stub(froggeR::quarto_project, "rstudioapi::openProject", function(...) NULL)

  # Test example = TRUE
  test_dir_true <- file.path(tmp_dir, "test_true")
  dir.create(test_dir_true)
  expect_silent(
    suppressMessages(
      froggeR::quarto_project(name = "test-true", path = test_dir_true, example = TRUE)
    )
  )

  # Test example = FALSE
  test_dir_false <- file.path(tmp_dir, "test_false")
  dir.create(test_dir_false)
  expect_silent(
    suppressMessages(
      froggeR::quarto_project(name = "test-false", path = test_dir_false, example = FALSE)
    )
  )
})


# Directory existence tests ====

test_that("quarto_project errors when directory already exists", {
  tmp_dir <- withr::local_tempdir()

  # Create a directory that will conflict
  project_name <- "existing-project"
  existing_dir <- file.path(tmp_dir, project_name)
  dir.create(existing_dir)

  # Mock Quarto version
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")

  expect_error(
    froggeR::quarto_project(name = project_name, path = tmp_dir),
    "Directory named"
  )
})


# Successful project creation tests ====

test_that("quarto_project creates project directory", {
  tmp_dir <- withr::local_tempdir()

  # Mock all external calls
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")
  mockery::stub(froggeR::quarto_project, "quarto::quarto_create_project", function(name, dir, ...) {
    dir.create(file.path(dir, name), recursive = TRUE)
  })
  mockery::stub(froggeR::quarto_project, "rstudioapi::openProject", function(...) NULL)

  project_name <- "my-project"
  suppressMessages(
    froggeR::quarto_project(name = project_name, path = tmp_dir, example = FALSE)
  )

  project_dir <- file.path(tmp_dir, project_name)
  expect_true(dir.exists(project_dir))
})

test_that("quarto_project creates key project files", {
  tmp_dir <- withr::local_tempdir()

  # Mock all external calls
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")
  mockery::stub(froggeR::quarto_project, "quarto::quarto_create_project", function(name, dir, ...) {
    dir.create(file.path(dir, name), recursive = TRUE)
  })
  mockery::stub(froggeR::quarto_project, "rstudioapi::openProject", function(...) NULL)

  project_name <- "test-files"
  suppressMessages(
    froggeR::quarto_project(name = project_name, path = tmp_dir, example = FALSE)
  )

  project_dir <- file.path(tmp_dir, project_name)

  # Check that key files are created
  expect_true(file.exists(file.path(project_dir, "_quarto.yml")))
  expect_true(file.exists(file.path(project_dir, paste0(project_name, ".qmd"))))
  expect_true(file.exists(file.path(project_dir, "_variables.yml")))
  expect_true(file.exists(file.path(project_dir, "_brand.yml")))
  expect_true(file.exists(file.path(project_dir, "custom.scss")))
  expect_true(file.exists(file.path(project_dir, ".gitignore")))
  expect_true(file.exists(file.path(project_dir, "README.md")))
  expect_true(file.exists(file.path(project_dir, "dated_progress_notes.md")))
  expect_true(file.exists(file.path(project_dir, "references.bib")))
})

test_that("quarto_project updates _quarto.yml with project name", {
  tmp_dir <- withr::local_tempdir()

  # Mock all external calls
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")
  mockery::stub(froggeR::quarto_project, "quarto::quarto_create_project", function(name, dir, ...) {
    dir.create(file.path(dir, name), recursive = TRUE)
  })
  mockery::stub(froggeR::quarto_project, "rstudioapi::openProject", function(...) NULL)

  project_name <- "my-awesome-project"
  suppressMessages(
    froggeR::quarto_project(name = project_name, path = tmp_dir, example = FALSE)
  )

  project_dir <- file.path(tmp_dir, project_name)
  quarto_yml <- file.path(project_dir, "_quarto.yml")

  # Read the _quarto.yml file (suppress incomplete final line warning)
  content <- suppressWarnings(readLines(quarto_yml))

  # Check that the title was updated with the project name
  expect_true(any(grepl(sprintf('title: "%s"', project_name), content)))
})

test_that("quarto_project creates logos directory for brand", {
  tmp_dir <- withr::local_tempdir()

  # Set up global logos directory for testing
  config_path <- file.path(tmp_dir, "froggeR_config")
  logos_path <- file.path(config_path, "logos")
  dir.create(logos_path, recursive = TRUE)

  # Mock rappdirs::user_config_dir globally using local_mocked_bindings
  local_mocked_bindings(
    user_config_dir = function(...) config_path,
    .package = "rappdirs"
  )

  # Mock all external calls
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")
  mockery::stub(froggeR::quarto_project, "quarto::quarto_create_project", function(name, dir, ...) {
    dir.create(file.path(dir, name), recursive = TRUE)
  })
  mockery::stub(froggeR::quarto_project, "rstudioapi::openProject", function(...) NULL)

  project_name <- "branded-project"
  suppressMessages(
    froggeR::quarto_project(name = project_name, path = tmp_dir, example = FALSE)
  )

  project_dir <- file.path(tmp_dir, project_name)
  logos_dir <- file.path(project_dir, "logos")

  # The create_brand function should create the logos directory when global logos exist
  expect_true(dir.exists(logos_dir))
})


# Return value tests ====

test_that("quarto_project returns project path invisibly", {
  tmp_dir <- withr::local_tempdir()

  # Mock all external calls
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")
  mockery::stub(froggeR::quarto_project, "quarto::quarto_create_project", function(name, dir, ...) {
    dir.create(file.path(dir, name), recursive = TRUE)
  })
  mockery::stub(froggeR::quarto_project, "rstudioapi::openProject", function(...) NULL)

  project_name <- "return-test"
  result <- suppressMessages(
    froggeR::quarto_project(name = project_name, path = tmp_dir, example = FALSE)
  )

  # Check return value
  expect_type(result, "character")
  expect_equal(basename(result), project_name)
  expect_equal(normalizePath(dirname(result)), normalizePath(tmp_dir))

  # Verify it's the correct project directory
  expect_true(dir.exists(result))
})


# Example parameter behavior tests ====

test_that("quarto_project creates example content when example = TRUE", {
  tmp_dir <- withr::local_tempdir()

  # Mock all external calls
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")
  mockery::stub(froggeR::quarto_project, "quarto::quarto_create_project", function(name, dir, ...) {
    dir.create(file.path(dir, name), recursive = TRUE)
  })
  mockery::stub(froggeR::quarto_project, "rstudioapi::openProject", function(...) NULL)

  project_name <- "example-project"
  suppressMessages(
    froggeR::quarto_project(name = project_name, path = tmp_dir, example = TRUE)
  )

  project_dir <- file.path(tmp_dir, project_name)
  qmd_file <- file.path(project_dir, paste0(project_name, ".qmd"))

  # Read the created .qmd file (suppress incomplete final line warning)
  content <- suppressWarnings(readLines(qmd_file))

  # Example content should be more substantial than basic template
  # The custom_quarto.qmd template is used when example = TRUE
  expect_true(length(content) > 10)
})

test_that("quarto_project creates basic content when example = FALSE", {
  tmp_dir <- withr::local_tempdir()

  # Mock all external calls
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")
  mockery::stub(froggeR::quarto_project, "quarto::quarto_create_project", function(name, dir, ...) {
    dir.create(file.path(dir, name), recursive = TRUE)
  })
  mockery::stub(froggeR::quarto_project, "rstudioapi::openProject", function(...) NULL)

  project_name <- "basic-project"
  suppressMessages(
    froggeR::quarto_project(name = project_name, path = tmp_dir, example = FALSE)
  )

  project_dir <- file.path(tmp_dir, project_name)
  qmd_file <- file.path(project_dir, paste0(project_name, ".qmd"))

  # Verify the file was created
  expect_true(file.exists(qmd_file))
})


# RStudio integration tests ====

test_that("quarto_project does not call openProject in non-interactive mode", {
  tmp_dir <- withr::local_tempdir()

  # Mock all external calls
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")
  mockery::stub(froggeR::quarto_project, "quarto::quarto_create_project", function(name, dir, ...) {
    dir.create(file.path(dir, name), recursive = TRUE)
  })

  # Create a mock that will error if called
  mock_open <- mockery::mock(stop("openProject should not be called in non-interactive mode"))
  mockery::stub(froggeR::quarto_project, "rstudioapi::openProject", mock_open)

  # In non-interactive mode (testthat default), openProject should not be called
  suppressMessages(
    froggeR::quarto_project(name = "test-no-open", path = tmp_dir, example = FALSE)
  )

  # Verify openProject was never called - length(mockery::mock_calls(mock)) returns number of calls
  expect_equal(length(mockery::mock_calls(mock_open)), 0)
})


# Edge cases and path handling ====

test_that("quarto_project handles path with trailing slash", {
  tmp_dir <- withr::local_tempdir()
  path_with_slash <- paste0(tmp_dir, "/")

  # Mock all external calls
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")
  mockery::stub(froggeR::quarto_project, "quarto::quarto_create_project", function(name, dir, ...) {
    dir.create(file.path(dir, name), recursive = TRUE)
  })
  mockery::stub(froggeR::quarto_project, "rstudioapi::openProject", function(...) NULL)

  project_name <- "slash-test"
  result <- suppressMessages(
    froggeR::quarto_project(name = project_name, path = path_with_slash, example = FALSE)
  )

  # Should still create in correct location
  expect_true(dir.exists(result))
  expect_equal(basename(result), project_name)
})

test_that("quarto_project normalizes path correctly", {
  tmp_dir <- withr::local_tempdir()

  # Mock all external calls
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")
  mockery::stub(froggeR::quarto_project, "quarto::quarto_create_project", function(name, dir, ...) {
    dir.create(file.path(dir, name), recursive = TRUE)
  })
  mockery::stub(froggeR::quarto_project, "rstudioapi::openProject", function(...) NULL)

  project_name <- "normalize-test"
  result <- suppressMessages(
    froggeR::quarto_project(name = project_name, path = tmp_dir, example = FALSE)
  )

  # Result should be absolute path
  expect_true(grepl("^/", result) || grepl("^[A-Z]:/", result) || grepl("^[A-Z]:\\\\", result))
})


# Quarto create_project call tests ====

test_that("quarto_project calls quarto::quarto_create_project with correct parameters", {
  tmp_dir <- withr::local_tempdir()

  # Mock Quarto version
  mockery::stub(froggeR::quarto_project, "quarto::quarto_version", "1.6.0")

  # Track the arguments passed to quarto_create_project
  captured_args <- NULL
  mock_func <- function(name, dir, quiet, no_prompt) {
    captured_args <<- list(name = name, dir = dir, quiet = quiet, no_prompt = no_prompt)
    dir.create(file.path(dir, name), recursive = TRUE)
    NULL
  }

  mockery::stub(froggeR::quarto_project, "quarto::quarto_create_project", mock_func)
  mockery::stub(froggeR::quarto_project, "rstudioapi::openProject", function(...) NULL)

  project_name <- "param-test"
  suppressMessages(
    froggeR::quarto_project(name = project_name, path = tmp_dir, example = FALSE)
  )

  # Verify the function was called (captured_args should not be NULL)
  expect_false(is.null(captured_args))

  # Verify the name parameter
  expect_equal(captured_args$name, project_name)

  # Verify dir parameter (should be normalized path)
  expect_equal(normalizePath(captured_args$dir), normalizePath(tmp_dir))

  # Verify quiet parameter
  expect_true(captured_args$quiet)
})


# Template file validation ====

test_that("quarto.yml template exists in package", {
  template_path <- system.file("gists/quarto.yml", package = "froggeR")

  expect_true(file.exists(template_path))
  expect_false(template_path == "")
})

test_that("references.bib template exists in package", {
  template_path <- system.file("gists/references.bib", package = "froggeR")

  expect_true(file.exists(template_path))
  expect_false(template_path == "")
})
