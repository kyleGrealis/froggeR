# Tests for settings.R

# Test: settings() aborts in non-interactive mode --------------------------

test_that("settings() aborts when run in non-interactive session", {
  expect_error(
    settings(),
    class = "froggeR_interactive_only"
  )

  expect_error(
    settings(),
    "must be run in an interactive session"
  )
})


# Tests for .validate_name() -----------------------------------------------

test_that(".validate_name accepts valid names", {
  result <- froggeR:::.validate_name("John Doe")
  expect_true(result$valid)
  expect_equal(result$message, "")
})

test_that(".validate_name accepts minimum length name", {
  result <- froggeR:::.validate_name("AB")
  expect_true(result$valid)
})

test_that(".validate_name rejects single character name", {
  result <- froggeR:::.validate_name("A")
  expect_false(result$valid)
  expect_match(result$message, "at least 2 characters")
})

test_that(".validate_name rejects empty name", {
  result <- froggeR:::.validate_name("")
  expect_false(result$valid)
})

test_that(".validate_name rejects whitespace-only name", {
  result <- froggeR:::.validate_name("  ")
  expect_false(result$valid)
})


# Tests for .validate_email() -----------------------------------------------

test_that(".validate_email accepts valid email format", {
  result <- froggeR:::.validate_email("user@example.com")
  expect_true(result$valid)
  expect_equal(result$message, "")
})

test_that(".validate_email accepts email with subdomain", {
  result <- froggeR:::.validate_email("user@mail.example.com")
  expect_true(result$valid)
})

test_that(".validate_email rejects email without @", {
  result <- froggeR:::.validate_email("userexample.com")
  expect_false(result$valid)
  expect_match(result$message, "user@example.com")
})

test_that(".validate_email rejects email without domain", {
  result <- froggeR:::.validate_email("user@")
  expect_false(result$valid)
})

test_that(".validate_email rejects email without extension", {
  result <- froggeR:::.validate_email("user@example")
  expect_false(result$valid)
})


# Tests for .validate_orcid() -----------------------------------------------

test_that(".validate_orcid accepts valid ORCID format", {
  result <- froggeR:::.validate_orcid("0000-0001-2345-6789")
  expect_true(result$valid)
  expect_equal(result$message, "")
})

test_that(".validate_orcid accepts ORCID with X checksum", {
  result <- froggeR:::.validate_orcid("0000-0002-1825-009X")
  expect_true(result$valid)
})

test_that(".validate_orcid rejects ORCID without dashes", {
  result <- froggeR:::.validate_orcid("0000000123456789")
  expect_false(result$valid)
  expect_match(result$message, "0000-0000-0000-0000")
})

test_that(".validate_orcid rejects ORCID with letters", {
  result <- froggeR:::.validate_orcid("ABCD-1234-5678-9012")
  expect_false(result$valid)
})


# Tests for .validate_url() -------------------------------------------------

test_that(".validate_url accepts HTTPS URL", {
  result <- froggeR:::.validate_url("https://example.com")
  expect_true(result$valid)
  expect_equal(result$message, "")
})

test_that(".validate_url accepts HTTP URL", {
  result <- froggeR:::.validate_url("http://example.com")
  expect_true(result$valid)
})

test_that(".validate_url rejects URL without protocol", {
  result <- froggeR:::.validate_url("example.com")
  expect_false(result$valid)
  expect_match(result$message, "http://")
})

test_that(".validate_url rejects URL with wrong protocol", {
  result <- froggeR:::.validate_url("ftp://example.com")
  expect_false(result$valid)
})


# Tests for .validate_github() ----------------------------------------------

test_that(".validate_github accepts valid username", {
  result <- froggeR:::.validate_github("octocat")
  expect_true(result$valid)
  expect_equal(result$message, "")
})

test_that(".validate_github accepts username with hyphens", {
  result <- froggeR:::.validate_github("octo-cat")
  expect_true(result$valid)
})

test_that(".validate_github accepts username with numbers", {
  result <- froggeR:::.validate_github("user123")
  expect_true(result$valid)
})

test_that(".validate_github accepts single character username", {
  result <- froggeR:::.validate_github("a")
  expect_true(result$valid)
})

test_that(".validate_github accepts maximum length username", {
  # Max 39 characters for GitHub
  result <- froggeR:::.validate_github(paste0(rep("a", 39), collapse = ""))
  expect_true(result$valid)
})

test_that(".validate_github rejects username with leading hyphen", {
  result <- froggeR:::.validate_github("-octocat")
  expect_false(result$valid)
})

test_that(".validate_github rejects username with trailing hyphen", {
  result <- froggeR:::.validate_github("octocat-")
  expect_false(result$valid)
})

test_that(".validate_github rejects username that's too long", {
  # 40 characters should fail
  result <- froggeR:::.validate_github(paste0(rep("a", 40), collapse = ""))
  expect_false(result$valid)
})

test_that(".validate_github rejects username with special characters", {
  result <- froggeR:::.validate_github("octo_cat")
  expect_false(result$valid)
})


# Tests for .format_yaml_value() --------------------------------------------

test_that(".format_yaml_value returns value for non-empty string", {
  expect_equal(froggeR:::.format_yaml_value("test"), "test")
})

test_that(".format_yaml_value returns placeholder for empty string", {
  expect_equal(froggeR:::.format_yaml_value(""), "(not set)")
})

test_that(".format_yaml_value returns placeholder for NA", {
  expect_equal(froggeR:::.format_yaml_value(NA_character_), "(not set)")
})


# Tests for .format_metadata_preview() --------------------------------------

test_that(".format_metadata_preview formats complete metadata", {
  metadata <- list(
    name = "Jane Doe",
    email = "jane@example.com",
    orcid = "0000-0001-2345-6789",
    url = "https://janedoe.com",
    github = "janedoe",
    affiliations = "University of Example"
  )

  result <- froggeR:::.format_metadata_preview(metadata)

  expect_type(result, "character")
  expect_match(result, "^---")
  expect_match(result, "name: Jane Doe")
  expect_match(result, "email: jane@example.com")
  expect_match(result, "orcid: 0000-0001-2345-6789")
  expect_match(result, "url: https://janedoe.com")
  expect_match(result, "github: janedoe")
  expect_match(result, "affiliations: University of Example")
  expect_match(result, "---$")
})

test_that(".format_metadata_preview handles missing values", {
  metadata <- list(
    name = "Jane Doe",
    email = "jane@example.com",
    orcid = NA,
    url = "",
    github = NA_character_,
    affiliations = ""
  )

  result <- froggeR:::.format_metadata_preview(metadata)

  expect_match(result, "orcid: \\(not set\\)")
  expect_match(result, "url: \\(not set\\)")
  expect_match(result, "github: \\(not set\\)")
  expect_match(result, "affiliations: \\(not set\\)")
})


# Tests for .save_metadata_to_yaml() ----------------------------------------

test_that(".save_metadata_to_yaml writes metadata to file", {
  tmp_dir <- withr::local_tempdir()
  metadata_file <- file.path(tmp_dir, "_variables.yml")

  metadata <- list(
    name = "Test User",
    email = "test@example.com",
    orcid = "",
    url = "",
    github = "",
    affiliations = ""
  )

  froggeR:::.save_metadata_to_yaml(metadata, metadata_file, "test")

  expect_true(file.exists(metadata_file))

  # Verify content
  saved_data <- yaml::read_yaml(metadata_file)
  expect_equal(saved_data$name, "Test User")
  expect_equal(saved_data$email, "test@example.com")
})

test_that(".save_metadata_to_yaml creates directory if needed", {
  tmp_dir <- withr::local_tempdir()
  nested_path <- file.path(tmp_dir, "nested", "dir")
  metadata_file <- file.path(nested_path, "_variables.yml")

  metadata <- list(
    name = "Test User",
    email = "test@example.com"
  )

  froggeR:::.save_metadata_to_yaml(metadata, metadata_file, "test")

  expect_true(dir.exists(nested_path))
  expect_true(file.exists(metadata_file))
})

test_that(".save_metadata_to_yaml errors with informative message on write failure", {
  skip_on_os("windows")  # /proc doesn't exist on Windows
  # Try to write to a path that can't be created
  metadata <- list(name = "Test")

  # Use /proc which typically can't have files written to it
  expect_error(
    froggeR:::.save_metadata_to_yaml(metadata, "/proc/invalid/file.yml", "test"),
    "Failed to save metadata"
  )

  expect_error(
    froggeR:::.save_metadata_to_yaml(metadata, "/proc/invalid/file.yml", "test"),
    class = "froggeR_save_error"
  )
})
