library(testthat)
library(froggeR)

# Test write_scss() ====

test_that("write_scss creates www/custom.scss successfully", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_scss_template(),
    .package = "froggeR"
  )

  result <- write_scss(path = tmp_dir)

  expect_true(file.exists(file.path(tmp_dir, "www", "custom.scss")))
  expect_true(dir.exists(file.path(tmp_dir, "www")))
  expect_equal(basename(result), "custom.scss")
})

test_that("write_scss creates file with SCSS template content", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_scss_template(),
    .package = "froggeR"
  )

  result <- write_scss(path = tmp_dir)
  content <- readLines(result)

  expect_true(any(grepl("scss:defaults", content)))
  expect_true(any(grepl("scss:mixins", content)))
  expect_true(any(grepl("scss:rules", content)))
})

test_that("write_scss returns normalized absolute path", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_scss_template(),
    .package = "froggeR"
  )

  result <- write_scss(path = tmp_dir)

  expect_true(grepl("^/", result) || grepl("^[A-Z]:/", result) || grepl("^[A-Z]:\\\\", result))
  expect_equal(normalizePath(dirname(result)), normalizePath(file.path(tmp_dir, "www")))
})


# Filename parameter tests ====

test_that("write_scss creates file with custom filename", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_scss_template(),
    .package = "froggeR"
  )

  result <- write_scss("tables", path = tmp_dir)

  expect_true(file.exists(file.path(tmp_dir, "www", "tables.scss")))
  expect_equal(basename(result), "tables.scss")
})

test_that("write_scss strips www/ prefix from filename", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_scss_template(),
    .package = "froggeR"
  )

  result <- write_scss("www/custom2.scss", path = tmp_dir)

  expect_true(file.exists(file.path(tmp_dir, "www", "custom2.scss")))
  expect_equal(basename(result), "custom2.scss")
})

test_that("write_scss strips .scss extension from filename", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_scss_template(),
    .package = "froggeR"
  )

  result <- write_scss("custom3.scss", path = tmp_dir)

  expect_true(file.exists(file.path(tmp_dir, "www", "custom3.scss")))
  expect_equal(basename(result), "custom3.scss")
})

test_that("write_scss treats bare name and full path equivalently", {
  tmp1 <- withr::local_tempdir()
  tmp2 <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_scss_template(),
    .package = "froggeR"
  )

  result1 <- write_scss("custom2", path = tmp1)
  result2 <- write_scss("www/custom2.scss", path = tmp2)

  expect_equal(basename(result1), basename(result2))
  expect_equal(basename(result1), "custom2.scss")
})


# Error handling tests ====

test_that("write_scss errors when directory doesn't exist", {
  fake_path <- file.path(tempdir(), "nonexistent_dir_xyz123")

  expect_error(
    write_scss(path = fake_path),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_scss opens existing file without error", {
  tmp_dir <- withr::local_tempdir()

  www_dir <- file.path(tmp_dir, "www")
  dir.create(www_dir)
  writeLines("/* test */", file.path(www_dir, "custom.scss"))

  # Should succeed (opens existing file)
  result <- suppressMessages(write_scss(path = tmp_dir))
  expect_true(file.exists(result))
  expect_equal(basename(result), "custom.scss")

  # Content should be unchanged
  expect_equal(readLines(result), "/* test */")
})

test_that("write_scss errors on NULL path", {
  expect_error(
    write_scss(path = NULL),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_scss errors on NA path", {
  expect_error(
    write_scss(path = NA),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_scss errors on empty string path", {
  expect_error(
    write_scss(path = ""),
    "Invalid path",
    class = "froggeR_invalid_path"
  )
})

test_that("write_scss errors on invalid filename characters", {
  tmp_dir <- withr::local_tempdir()

  expect_error(
    write_scss("bad file name!", path = tmp_dir),
    "Invalid filename"
  )
})


# Edge cases ====

test_that("write_scss handles empty directory", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_scss_template(),
    .package = "froggeR"
  )

  result <- write_scss(path = tmp_dir)

  expect_true(file.exists(result))
  expect_equal(basename(result), "custom.scss")
})

test_that("write_scss handles path with trailing slash", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_scss_template(),
    .package = "froggeR"
  )

  path_with_slash <- paste0(tmp_dir, "/")
  result <- write_scss(path = path_with_slash)

  expect_true(file.exists(file.path(tmp_dir, "www", "custom.scss")))
  expect_true(file.exists(result))
})

test_that("write_scss creates file in nested directory structure", {
  tmp_base <- withr::local_tempdir()
  nested_dir <- file.path(tmp_base, "project", "docs")
  dir.create(nested_dir, recursive = TRUE)

  local_mocked_bindings(
    .fetch_template = function(...) .fake_scss_template(),
    .package = "froggeR"
  )

  result <- write_scss(path = nested_dir)

  expect_true(file.exists(result))
  expect_equal(basename(result), "custom.scss")
  expect_true(grepl("project/docs/www", result) || grepl("project\\\\docs\\\\www", result))
})


# Content validation tests ====

test_that("write_scss file is readable and not empty", {
  tmp_dir <- withr::local_tempdir()

  local_mocked_bindings(
    .fetch_template = function(...) .fake_scss_template(),
    .package = "froggeR"
  )

  result <- write_scss(path = tmp_dir)
  content <- readLines(result)

  expect_type(content, "character")
  expect_true(length(content) > 0)
})
