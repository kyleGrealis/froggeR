library(testthat)
library(froggeR)

# Test write_readme() - Main exported function ====

test_that("write_readme creates README.md successfully", {
  tmp_dir <- withr::local_tempdir()

  result <- write_readme(path = tmp_dir)

  # File should be created
  expect_true(file.exists(file.path(tmp_dir, "README.md")))

  # Function returns file path invisibly
  expect_equal(basename(result), "README.md")
})

test_that("write_readme creates file with correct template content", {
  tmp_dir <- withr::local_tempdir()

  result <- write_readme(path = tmp_dir)
  content <- readLines(result)

  # Verify template content is present
  expect_true(any(grepl("^# Repository Name", content)))
  expect_true(any(grepl("\\*\\*Code Author\\*\\*:", content)))
  expect_true(any(grepl("\\*\\*Description\\*\\*:", content)))
  expect_true(any(grepl("\\*\\*Purpose\\*\\*:", content)))
  expect_true(any(grepl("## Directories", content)))
  expect_true(any(grepl("## File Descriptions", content)))
})

test_that("write_readme returns normalized absolute path", {
  tmp_dir <- withr::local_tempdir()

  result <- write_readme(path = tmp_dir)

  # Result should be absolute path
  expect_true(grepl("^/", result) || grepl("^[A-Z]:/", result) || grepl("^[A-Z]:\\\\", result))
  expect_equal(normalizePath(dirname(result)), normalizePath(tmp_dir))
})


# Error handling tests ====

test_that("write_readme errors when directory doesn't exist", {
  fake_path <- file.path(tempdir(), "nonexistent_dir_xyz123")

  expect_error(
    write_readme(path = fake_path),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_readme errors when file already exists", {
  tmp_dir <- withr::local_tempdir()

  # Create the file manually
  readme_file <- file.path(tmp_dir, "README.md")
  writeLines("# Test", readme_file)

  # Try to create - should error with appropriate message
  expect_error(
    write_readme(path = tmp_dir),
    "A README.md already exists"
  )
})

test_that("write_readme errors on NULL path", {
  expect_error(
    write_readme(path = NULL),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_readme errors on NA path", {
  expect_error(
    write_readme(path = NA),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_readme errors on empty string path", {
  expect_error(
    write_readme(path = ""),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})


# Edge cases and path handling ====

test_that("write_readme handles empty directory", {
  tmp_dir <- withr::local_tempdir()
  # Directory is empty by default

  result <- write_readme(path = tmp_dir)

  expect_true(file.exists(result))
  expect_equal(basename(result), "README.md")
})

test_that("write_readme handles path with trailing slash", {
  tmp_dir <- withr::local_tempdir()

  # Add trailing slash
  path_with_slash <- paste0(tmp_dir, "/")
  result <- write_readme(path = path_with_slash)

  # Should still create in correct location
  expect_true(file.exists(file.path(tmp_dir, "README.md")))
  expect_true(file.exists(result))
})

test_that("write_readme creates file in nested directory structure", {
  tmp_base <- withr::local_tempdir()
  nested_dir <- file.path(tmp_base, "project", "docs")
  dir.create(nested_dir, recursive = TRUE)

  result <- write_readme(path = nested_dir)

  expect_true(file.exists(result))
  expect_equal(basename(result), "README.md")
  expect_true(grepl("project/docs", result) || grepl("project\\\\docs", result))
})


# Content validation tests ====

test_that("write_readme file is valid markdown", {
  tmp_dir <- withr::local_tempdir()

  result <- write_readme(path = tmp_dir)
  content <- readLines(result)

  # File should not be empty
  expect_true(length(content) > 0)

  # First line should be a markdown header
  expect_true(startsWith(content[1], "# "))
})

test_that("write_readme file is readable", {
  tmp_dir <- withr::local_tempdir()

  result <- write_readme(path = tmp_dir)

  # Should be able to read the file without errors
  expect_silent({
    content <- readLines(result)
  })

  # Content should be character vector
  expect_type(content, "character")
})

test_that("write_readme file has expected structure sections", {
  tmp_dir <- withr::local_tempdir()

  result <- write_readme(path = tmp_dir)
  content <- paste(readLines(result), collapse = "\n")

  # Check for key markdown sections
  expect_true(grepl("Repository Name", content))
  expect_true(grepl("Code Author", content))
  expect_true(grepl("Description", content))
  expect_true(grepl("Purpose", content))
  expect_true(grepl("Directories", content))
  expect_true(grepl("File Descriptions", content))
})


# Test create_readme() - Internal helper function ====

test_that("create_readme creates README.md successfully", {
  tmp_dir <- withr::local_tempdir()

  result <- froggeR:::create_readme(path = tmp_dir)

  # File should be created
  expect_true(file.exists(file.path(tmp_dir, "README.md")))

  # Function returns file path
  expect_equal(basename(result), "README.md")
})

test_that("create_readme errors when file already exists", {
  tmp_dir <- withr::local_tempdir()

  # Create file first
  readme_file <- file.path(tmp_dir, "README.md")
  writeLines("# Test", readme_file)

  # Try to create again - should error
  expect_error(
    froggeR:::create_readme(path = tmp_dir),
    "A README.md already exists",
    class = "froggeR_file_exists"
  )
})

test_that("create_readme validates path input", {
  fake_path <- file.path(tempdir(), "nonexistent_dir_xyz456")

  expect_error(
    froggeR:::create_readme(path = fake_path),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("create_readme returns absolute path", {
  tmp_dir <- withr::local_tempdir()

  result <- froggeR:::create_readme(path = tmp_dir)

  # Result should be absolute path
  expect_true(grepl("^/", result) || grepl("^[A-Z]:/", result) || grepl("^[A-Z]:\\\\", result))
  expect_equal(normalizePath(dirname(result)), normalizePath(tmp_dir))
})

test_that("create_readme copies template correctly", {
  tmp_dir <- withr::local_tempdir()

  result <- froggeR:::create_readme(path = tmp_dir)

  # Get template content
  template_path <- system.file("gists/README.md", package = "froggeR")
  template_content <- readLines(template_path)

  # Get created file content
  created_content <- readLines(result)

  # Content should match template
  expect_equal(created_content, template_content)
})


# Template existence tests ====

test_that("README template file exists in package", {
  template_path <- system.file("gists/README.md", package = "froggeR")

  expect_true(file.exists(template_path))
  expect_false(template_path == "")
})

test_that("README template has expected content", {
  template_path <- system.file("gists/README.md", package = "froggeR")
  content <- readLines(template_path)

  # Template should have basic structure
  expect_true(length(content) > 0)
  expect_true(any(grepl("Repository Name", content)))
  expect_true(any(grepl("Code Author", content)))
})
