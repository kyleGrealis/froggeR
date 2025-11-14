# Tests for internal utility functions in utils.R

# Tests for .validate_and_normalize_path() --------------------------------

test_that(".validate_and_normalize_path returns normalized path for valid directory", {
  tmp_dir <- withr::local_tempdir()
  result <- froggeR:::.validate_and_normalize_path(tmp_dir)

  expect_type(result, "character")
  expect_true(dir.exists(result))
})

test_that(".validate_and_normalize_path errors on NULL path", {
  expect_error(
    froggeR:::.validate_and_normalize_path(NULL),
    class = "froggeR_invalid_path"
  )
})

test_that(".validate_and_normalize_path errors on NA path", {
  expect_error(
    froggeR:::.validate_and_normalize_path(NA_character_),
    class = "froggeR_invalid_path"
  )
})

test_that(".validate_and_normalize_path errors on nonexistent directory", {
  expect_error(
    froggeR:::.validate_and_normalize_path("/nonexistent/path/that/does/not/exist"),
    class = "froggeR_invalid_path"
  )
})
