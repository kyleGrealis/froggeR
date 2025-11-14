library(testthat)
library(froggeR)

# Tests for write_quarto() - Main exported function ====

test_that("write_quarto creates .qmd file successfully with example = FALSE", {
  tmp_dir <- withr::local_tempdir()

  result <- suppressMessages(froggeR::write_quarto(
    filename = "test-doc",
    path = tmp_dir,
    example = FALSE
  ))

  # File should be created
  expect_true(file.exists(file.path(tmp_dir, "test-doc.qmd")))

  # Function returns file path invisibly
  expect_type(result, "character")
  expect_equal(basename(result), "test-doc.qmd")
  expect_equal(normalizePath(dirname(result)), normalizePath(tmp_dir))
})

test_that("write_quarto creates .qmd file successfully with example = TRUE", {
  tmp_dir <- withr::local_tempdir()

  result <- suppressMessages(froggeR::write_quarto(
    filename = "example-doc",
    path = tmp_dir,
    example = TRUE
  ))

  # Main file should be created
  expect_true(file.exists(file.path(tmp_dir, "example-doc.qmd")))

  # Auxiliary files should be created (when example = TRUE)
  expect_true(file.exists(file.path(tmp_dir, "_variables.yml")))
  expect_true(file.exists(file.path(tmp_dir, "_quarto.yml")))
  expect_true(file.exists(file.path(tmp_dir, "custom.scss")))

  # Function returns file path invisibly
  expect_type(result, "character")
  expect_equal(basename(result), "example-doc.qmd")
})

test_that("write_quarto uses default filename when not provided", {
  tmp_dir <- withr::local_tempdir()

  result <- suppressMessages(froggeR::write_quarto(path = tmp_dir))

  # Default filename should be "Untitled-1"
  expect_true(file.exists(file.path(tmp_dir, "Untitled-1.qmd")))
  expect_equal(basename(result), "Untitled-1.qmd")
})

test_that("write_quarto does not call edit_file when non-interactive", {
  tmp_dir <- withr::local_tempdir()

  # In non-interactive mode (the default for testthat), edit_file should not be called
  # We just verify the function completes successfully without error
  expect_silent(
    suppressMessages(froggeR::write_quarto(path = tmp_dir, filename = "test"))
  )

  # Verify file was created
  expect_true(file.exists(file.path(tmp_dir, "test.qmd")))
})

test_that("write_quarto suppresses froggeR_file_exists error for auxiliary files", {
  tmp_dir <- withr::local_tempdir()

  # Create _variables.yml ahead of time
  writeLines("existing: content", file.path(tmp_dir, "_variables.yml"))

  # Should not error - should suppress the file_exists error for auxiliary files
  expect_silent(
    suppressMessages(froggeR::write_quarto(
      filename = "test-doc",
      path = tmp_dir,
      example = TRUE
    ))
  )

  # Main file should still be created
  expect_true(file.exists(file.path(tmp_dir, "test-doc.qmd")))
})

# Error handling tests ====

test_that("write_quarto errors when directory doesn't exist", {
  fake_path <- file.path(tempdir(), "nonexistent_dir_xyz123")

  expect_error(
    froggeR::write_quarto(path = fake_path, filename = "test"),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_quarto errors when .qmd file already exists", {
  tmp_dir <- withr::local_tempdir()

  # Create the .qmd file manually
  qmd_file <- file.path(tmp_dir, "existing.qmd")
  writeLines("---\ntitle: Test\n---", qmd_file)

  # Try to create - should error with appropriate message
  expect_error(
    froggeR::write_quarto(path = tmp_dir, filename = "existing"),
    "existing.qmd already exists",
    class = "froggeR_file_exists"
  )
})

test_that("write_quarto errors on NULL path", {
  expect_error(
    froggeR::write_quarto(path = NULL, filename = "test"),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_quarto errors on NA path", {
  expect_error(
    froggeR::write_quarto(path = NA, filename = "test"),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})


# Tests for create_quarto() - Internal helper function ====

test_that("create_quarto creates .qmd file with basic template", {
  tmp_dir <- withr::local_tempdir()

  # Access internal function
  create_quarto <- get("create_quarto", envir = asNamespace("froggeR"))

  result <- suppressMessages(create_quarto(
    filename = "basic-doc",
    path = tmp_dir,
    example = FALSE
  ))

  # File should be created
  expect_true(file.exists(result))
  expect_equal(basename(result), "basic-doc.qmd")

  # Content should be from basic_quarto.qmd template
  content <- readLines(result)
  expect_true(length(content) > 0)
})

test_that("create_quarto creates .qmd file with custom template", {
  tmp_dir <- withr::local_tempdir()

  # Access internal function
  create_quarto <- get("create_quarto", envir = asNamespace("froggeR"))

  result <- suppressMessages(create_quarto(
    filename = "custom-doc",
    path = tmp_dir,
    example = TRUE
  ))

  # File should be created
  expect_true(file.exists(result))
  expect_equal(basename(result), "custom-doc.qmd")

  # Content should be from custom_quarto.qmd template
  content <- readLines(result)
  expect_true(length(content) > 0)
})

test_that("create_quarto returns normalized absolute path", {
  tmp_dir <- withr::local_tempdir()

  # Access internal function
  create_quarto <- get("create_quarto", envir = asNamespace("froggeR"))

  result <- suppressMessages(create_quarto(
    filename = "test-path",
    path = tmp_dir,
    example = FALSE
  ))

  # Result should be absolute path
  expect_true(grepl("^/", result) || grepl("^[A-Z]:/", result) || grepl("^[A-Z]:\\\\", result))
  expect_equal(normalizePath(dirname(result)), normalizePath(tmp_dir))
})

test_that("create_quarto errors when path is invalid", {
  # Access internal function
  create_quarto <- get("create_quarto", envir = asNamespace("froggeR"))

  expect_error(
    create_quarto(filename = "test", path = NULL, example = FALSE),
    class = "froggeR_invalid_path"
  )

  expect_error(
    create_quarto(filename = "test", path = NA_character_, example = FALSE),
    class = "froggeR_invalid_path"
  )

  expect_error(
    create_quarto(filename = "test", path = "/totally/fake/path", example = FALSE),
    class = "froggeR_invalid_path"
  )
})

test_that("create_quarto errors when .qmd file already exists", {
  tmp_dir <- withr::local_tempdir()

  # Access internal function
  create_quarto <- get("create_quarto", envir = asNamespace("froggeR"))

  # Create an existing .qmd file
  existing_file <- file.path(tmp_dir, "duplicate.qmd")
  writeLines("---\ntitle: Existing\n---", existing_file)

  # Expect error about file already existing
  expect_error(
    suppressMessages(create_quarto(
      filename = "duplicate",
      path = tmp_dir,
      example = FALSE
    )),
    "duplicate.qmd already exists",
    class = "froggeR_file_exists"
  )
})

test_that("create_quarto validates filename is character", {
  tmp_dir <- withr::local_tempdir()

  # Access internal function
  create_quarto <- get("create_quarto", envir = asNamespace("froggeR"))

  # Non-character filename
  expect_error(
    create_quarto(filename = 123, path = tmp_dir, example = FALSE),
    "Invalid filename: must be a character string"
  )

  expect_error(
    create_quarto(filename = NULL, path = tmp_dir, example = FALSE),
    "Invalid filename: must be a character string"
  )

  expect_error(
    create_quarto(filename = NA, path = tmp_dir, example = FALSE),
    "Invalid filename: must be a character string"
  )
})

test_that("create_quarto validates filename format", {
  tmp_dir <- withr::local_tempdir()

  # Access internal function
  create_quarto <- get("create_quarto", envir = asNamespace("froggeR"))

  # Invalid characters in filename
  expect_error(
    create_quarto(filename = "test file.qmd", path = tmp_dir, example = FALSE),
    "Invalid filename. Use only letters, numbers, hyphens, and underscores"
  )

  expect_error(
    create_quarto(filename = "test@file", path = tmp_dir, example = FALSE),
    "Invalid filename. Use only letters, numbers, hyphens, and underscores"
  )

  expect_error(
    create_quarto(filename = "test/file", path = tmp_dir, example = FALSE),
    "Invalid filename. Use only letters, numbers, hyphens, and underscores"
  )
})

test_that("create_quarto accepts valid filename formats", {
  tmp_dir <- withr::local_tempdir()

  # Access internal function
  create_quarto <- get("create_quarto", envir = asNamespace("froggeR"))

  # Valid filenames with letters, numbers, hyphens, underscores
  valid_names <- c("test", "test-123", "test_file", "MyFile", "test-file_123")

  for (name in valid_names) {
    result <- suppressMessages(create_quarto(
      filename = name,
      path = tmp_dir,
      example = FALSE
    ))
    expect_true(file.exists(result))
    expect_equal(basename(result), paste0(name, ".qmd"))
  }
})


# Template file validation tests ====

test_that("basic_quarto.qmd template exists in package", {
  template_path <- system.file("gists/basic_quarto.qmd", package = "froggeR")

  expect_true(file.exists(template_path))
  expect_false(template_path == "")
})

test_that("custom_quarto.qmd template exists in package", {
  template_path <- system.file("gists/custom_quarto.qmd", package = "froggeR")

  expect_true(file.exists(template_path))
  expect_false(template_path == "")
})

test_that("basic template content is valid Quarto markdown", {
  template_path <- system.file("gists/basic_quarto.qmd", package = "froggeR")
  content <- readLines(template_path)

  # Template should have content
  expect_true(length(content) > 0)

  # Should contain YAML frontmatter (--- markers)
  expect_true(any(grepl("^---", content)))
})

test_that("custom template content is valid Quarto markdown", {
  template_path <- system.file("gists/custom_quarto.qmd", package = "froggeR")
  content <- readLines(template_path)

  # Template should have content
  expect_true(length(content) > 0)

  # Should contain YAML frontmatter (--- markers)
  expect_true(any(grepl("^---", content)))
})

test_that("create_quarto basic template matches created file", {
  tmp_dir <- withr::local_tempdir()

  # Access internal function
  create_quarto <- get("create_quarto", envir = asNamespace("froggeR"))

  result <- suppressMessages(create_quarto(
    filename = "test",
    path = tmp_dir,
    example = FALSE
  ))

  # Get template content
  template_path <- system.file("gists/basic_quarto.qmd", package = "froggeR")
  template_content <- readLines(template_path)

  # Get created file content
  created_content <- readLines(result)

  # Content should match template
  expect_equal(created_content, template_content)
})

test_that("create_quarto custom template matches created file", {
  tmp_dir <- withr::local_tempdir()

  # Access internal function
  create_quarto <- get("create_quarto", envir = asNamespace("froggeR"))

  result <- suppressMessages(create_quarto(
    filename = "test",
    path = tmp_dir,
    example = TRUE
  ))

  # Get template content
  template_path <- system.file("gists/custom_quarto.qmd", package = "froggeR")
  template_content <- suppressWarnings(readLines(template_path))

  # Get created file content
  created_content <- readLines(result)

  # Content should match template
  expect_equal(created_content, template_content)
})


# Edge cases and path handling ====

test_that("create_quarto handles path with trailing slash", {
  tmp_dir <- withr::local_tempdir()

  # Access internal function
  create_quarto <- get("create_quarto", envir = asNamespace("froggeR"))

  # Add trailing slash
  path_with_slash <- paste0(tmp_dir, "/")
  result <- suppressMessages(create_quarto(
    filename = "test",
    path = path_with_slash,
    example = FALSE
  ))

  # Should still create in correct location
  expect_true(file.exists(file.path(tmp_dir, "test.qmd")))
  expect_true(file.exists(result))
})

test_that("create_quarto creates file in nested directory structure", {
  tmp_base <- withr::local_tempdir()
  nested_dir <- file.path(tmp_base, "project", "docs")
  dir.create(nested_dir, recursive = TRUE)

  # Access internal function
  create_quarto <- get("create_quarto", envir = asNamespace("froggeR"))

  result <- suppressMessages(create_quarto(
    filename = "nested-doc",
    path = nested_dir,
    example = FALSE
  ))

  expect_true(file.exists(result))
  expect_equal(basename(result), "nested-doc.qmd")
  expect_true(grepl("project/docs", result) || grepl("project\\\\docs", result))
})

test_that("create_quarto handles empty directory", {
  tmp_dir <- withr::local_tempdir()
  # Directory is empty by default

  # Access internal function
  create_quarto <- get("create_quarto", envir = asNamespace("froggeR"))

  result <- suppressMessages(create_quarto(
    filename = "first-file",
    path = tmp_dir,
    example = FALSE
  ))

  expect_true(file.exists(result))
  expect_equal(basename(result), "first-file.qmd")
})


# File content validation tests ====

test_that("created .qmd file is readable", {
  tmp_dir <- withr::local_tempdir()

  # Access internal function
  create_quarto <- get("create_quarto", envir = asNamespace("froggeR"))

  result <- suppressMessages(create_quarto(
    filename = "readable",
    path = tmp_dir,
    example = FALSE
  ))

  # Should be able to read the file without errors
  expect_silent({
    content <- readLines(result)
  })

  # Content should be character vector
  expect_type(content, "character")
})

test_that("created .qmd file is not empty", {
  tmp_dir <- withr::local_tempdir()

  # Access internal function
  create_quarto <- get("create_quarto", envir = asNamespace("froggeR"))

  result <- suppressMessages(create_quarto(
    filename = "not-empty",
    path = tmp_dir,
    example = FALSE
  ))

  content <- readLines(result)

  # File should not be empty
  expect_true(length(content) > 0)
})

test_that("created .qmd file has .qmd extension", {
  tmp_dir <- withr::local_tempdir()

  # Access internal function
  create_quarto <- get("create_quarto", envir = asNamespace("froggeR"))

  result <- suppressMessages(create_quarto(
    filename = "extension-test",
    path = tmp_dir,
    example = FALSE
  ))

  # Extension should be .qmd
  expect_true(grepl("\\.qmd$", result))
  expect_equal(tools::file_ext(result), "qmd")
})
