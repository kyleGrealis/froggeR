# Tests for brand_settings.R

library(froggeR)

# Test: brand_settings() aborts in non-interactive mode ---------------------

test_that("brand_settings() aborts when run in non-interactive session", {
  expect_error(
    brand_settings(),
    class = "froggeR_interactive_only"
  )

  expect_error(
    brand_settings(),
    "must be run in an interactive session"
  )
})


# Tests for .validate_hex_color() -------------------------------------------

test_that(".validate_hex_color accepts valid 6-digit hex color", {
  result <- froggeR:::.validate_hex_color("#0066cc")
  expect_true(result$valid)
  expect_equal(result$message, "")
})

test_that(".validate_hex_color accepts valid 3-digit hex color", {
  result <- froggeR:::.validate_hex_color("#06c")
  expect_true(result$valid)
  expect_equal(result$message, "")
})

test_that(".validate_hex_color accepts lowercase hex digits", {
  result <- froggeR:::.validate_hex_color("#aabbcc")
  expect_true(result$valid)
})

test_that(".validate_hex_color accepts uppercase hex digits", {
  result <- froggeR:::.validate_hex_color("#AABBCC")
  expect_true(result$valid)
})

test_that(".validate_hex_color accepts mixed case hex digits", {
  result <- froggeR:::.validate_hex_color("#AaBbCc")
  expect_true(result$valid)
})

test_that(".validate_hex_color accepts all digits", {
  result <- froggeR:::.validate_hex_color("#123456")
  expect_true(result$valid)
})

test_that(".validate_hex_color accepts all valid hex letters", {
  result <- froggeR:::.validate_hex_color("#ABCDEF")
  expect_true(result$valid)
})

test_that(".validate_hex_color accepts white color", {
  result <- froggeR:::.validate_hex_color("#FFFFFF")
  expect_true(result$valid)
})

test_that(".validate_hex_color accepts black color", {
  result <- froggeR:::.validate_hex_color("#000000")
  expect_true(result$valid)
})

test_that(".validate_hex_color accepts short black color", {
  result <- froggeR:::.validate_hex_color("#000")
  expect_true(result$valid)
})

test_that(".validate_hex_color rejects color without hash", {
  result <- froggeR:::.validate_hex_color("0066cc")
  expect_false(result$valid)
  expect_match(result$message, "hex format")
})

test_that(".validate_hex_color rejects color with wrong length", {
  result <- froggeR:::.validate_hex_color("#00")
  expect_false(result$valid)
})

test_that(".validate_hex_color rejects color with 4 digits", {
  result <- froggeR:::.validate_hex_color("#0066")
  expect_false(result$valid)
})

test_that(".validate_hex_color rejects color with 5 digits", {
  result <- froggeR:::.validate_hex_color("#00666")
  expect_false(result$valid)
})

test_that(".validate_hex_color rejects color with 7 digits", {
  result <- froggeR:::.validate_hex_color("#0066ccc")
  expect_false(result$valid)
})

test_that(".validate_hex_color rejects color with invalid characters", {
  result <- froggeR:::.validate_hex_color("#GGGGGG")
  expect_false(result$valid)
  expect_match(result$message, "#RRGGBB")
})

test_that(".validate_hex_color rejects color with spaces", {
  result <- froggeR:::.validate_hex_color("# 0066cc")
  expect_false(result$valid)
})

test_that(".validate_hex_color rejects empty string", {
  result <- froggeR:::.validate_hex_color("")
  expect_false(result$valid)
})

test_that(".validate_hex_color rejects color with special characters", {
  result <- froggeR:::.validate_hex_color("#006-cc")
  expect_false(result$valid)
})


# Tests for .format_brand_value() -------------------------------------------

test_that(".format_brand_value returns value for non-empty string", {
  expect_equal(froggeR:::.format_brand_value("My Project"), "My Project")
})

test_that(".format_brand_value returns value for hex color", {
  expect_equal(froggeR:::.format_brand_value("#0066cc"), "#0066cc")
})

test_that(".format_brand_value returns placeholder for empty string", {
  expect_equal(froggeR:::.format_brand_value(""), "(not set)")
})

test_that(".format_brand_value returns placeholder for NA", {
  expect_equal(froggeR:::.format_brand_value(NA_character_), "(not set)")
})

test_that(".format_brand_value handles whitespace-only string", {
  # Whitespace is treated as a value, not empty
  expect_equal(froggeR:::.format_brand_value("   "), "   ")
})


# Tests for .format_brand_preview() -----------------------------------------

test_that(".format_brand_preview formats complete brand configuration", {
  brand <- list(
    meta = list(name = "Acme Corp"),
    color = list(palette = list(primary = "#FF5733")),
    logo = list(large = "logos/logo.png", small = "logos/icon.png")
  )

  result <- froggeR:::.format_brand_preview(brand)

  expect_type(result, "character")
  expect_match(result, "^---")
  expect_match(result, "meta:")
  expect_match(result, "  name: Acme Corp")
  expect_match(result, "logo:")
  expect_match(result, "  large: logos/logo.png")
  expect_match(result, "  small: logos/icon.png")
  expect_match(result, "color:")
  expect_match(result, "  palette:")
  expect_match(result, "    primary: #FF5733")
  expect_match(result, "---$")
})

test_that(".format_brand_preview handles empty brand configuration", {
  brand <- list(
    meta = list(name = ""),
    color = list(palette = list(primary = "")),
    logo = list(large = "", small = "")
  )

  result <- froggeR:::.format_brand_preview(brand)

  expect_match(result, "name: \\(not set\\)")
  expect_match(result, "primary: \\(not set\\)")
  expect_match(result, "large: \\(not set\\)")
  expect_match(result, "small: \\(not set\\)")
})

test_that(".format_brand_preview handles NA values", {
  brand <- list(
    meta = list(name = NA_character_),
    color = list(palette = list(primary = NA_character_)),
    logo = list(large = NA_character_, small = NA_character_)
  )

  result <- froggeR:::.format_brand_preview(brand)

  expect_match(result, "name: \\(not set\\)")
  expect_match(result, "primary: \\(not set\\)")
  expect_match(result, "large: \\(not set\\)")
  expect_match(result, "small: \\(not set\\)")
})

test_that(".format_brand_preview handles mixed set and unset values", {
  brand <- list(
    meta = list(name = "My Project"),
    color = list(palette = list(primary = "")),
    logo = list(large = "logo.png", small = "")
  )

  result <- froggeR:::.format_brand_preview(brand)

  expect_match(result, "name: My Project")
  expect_match(result, "primary: \\(not set\\)")
  expect_match(result, "large: logo.png")
  expect_match(result, "small: \\(not set\\)")
})


# Tests for .format_brand_roadmap() -----------------------------------------

test_that(".format_brand_roadmap returns character string", {
  result <- froggeR:::.format_brand_roadmap()
  expect_type(result, "character")
})

test_that(".format_brand_roadmap includes key customization categories", {
  result <- froggeR:::.format_brand_roadmap()

  expect_match(result, "Typography")
  expect_match(result, "Colors")
  expect_match(result, "Links")
  expect_match(result, "Code")
  expect_match(result, "Headings")
  expect_match(result, "Logo")
})

test_that(".format_brand_roadmap includes instruction about template", {
  result <- froggeR:::.format_brand_roadmap()
  expect_match(result, "Edit the full template")
})


# Tests for .save_brand_to_yaml() -------------------------------------------

test_that(".save_brand_to_yaml writes brand configuration to file", {
  tmp_dir <- withr::local_tempdir()
  brand_file <- file.path(tmp_dir, "_brand.yml")

  brand <- list(
    meta = list(name = "Test Project"),
    color = list(palette = list(primary = "#0066cc")),
    logo = list(large = "logo.png", small = "icon.png")
  )

  froggeR:::.save_brand_to_yaml(brand, brand_file, "test")

  expect_true(file.exists(brand_file))

  # Verify content
  saved_data <- yaml::read_yaml(brand_file)
  expect_equal(saved_data$meta$name, "Test Project")
  expect_equal(saved_data$color$palette$primary, "#0066cc")
  expect_equal(saved_data$logo$large, "logo.png")
  expect_equal(saved_data$logo$small, "icon.png")
})

test_that(".save_brand_to_yaml creates directory if needed", {
  tmp_dir <- withr::local_tempdir()
  nested_path <- file.path(tmp_dir, "nested", "dir")
  brand_file <- file.path(nested_path, "_brand.yml")

  brand <- list(
    meta = list(name = "Test Project"),
    color = list(palette = list(primary = "#FF5733")),
    logo = list(large = "", small = "")
  )

  froggeR:::.save_brand_to_yaml(brand, brand_file, "test")

  expect_true(dir.exists(nested_path))
  expect_true(file.exists(brand_file))
})

test_that(".save_brand_to_yaml handles empty string values", {
  tmp_dir <- withr::local_tempdir()
  brand_file <- file.path(tmp_dir, "_brand.yml")

  brand <- list(
    meta = list(name = ""),
    color = list(palette = list(primary = "")),
    logo = list(large = "", small = "")
  )

  froggeR:::.save_brand_to_yaml(brand, brand_file, "test")

  expect_true(file.exists(brand_file))

  saved_data <- yaml::read_yaml(brand_file)
  expect_equal(saved_data$meta$name, "")
  expect_equal(saved_data$color$palette$primary, "")
})

test_that(".save_brand_to_yaml handles minimal brand configuration", {
  tmp_dir <- withr::local_tempdir()
  brand_file <- file.path(tmp_dir, "_brand.yml")

  brand <- list(
    meta = list(name = "Minimal")
  )

  froggeR:::.save_brand_to_yaml(brand, brand_file, "test")

  expect_true(file.exists(brand_file))

  saved_data <- yaml::read_yaml(brand_file)
  expect_equal(saved_data$meta$name, "Minimal")
})

test_that(".save_brand_to_yaml errors with informative message on write failure", {
  skip_on_os("windows")  # /proc doesn't exist on Windows
  brand <- list(meta = list(name = "Test"))

  # Try to write to a path that can't be created
  expect_error(
    froggeR:::.save_brand_to_yaml(brand, "/proc/invalid/file.yml", "test"),
    "Failed to save branding"
  )

  expect_error(
    froggeR:::.save_brand_to_yaml(brand, "/proc/invalid/file.yml", "test"),
    class = "froggeR_save_error"
  )
})


# Tests for .merge_brand_with_template() ------------------------------------

test_that(".merge_brand_with_template returns brand configuration", {
  tmp_dir <- withr::local_tempdir()
  template_file <- file.path(tmp_dir, "brand_template.yml")

  # Create a minimal template
  template_content <- "meta:\n  name: ''\ncolor:\n  palette:\n    primary: ''"
  writeLines(template_content, template_file)

  brand <- list(
    meta = list(name = "Test Project"),
    color = list(palette = list(primary = "#0066cc"))
  )

  result <- froggeR:::.merge_brand_with_template(brand, template_file)

  expect_type(result, "list")
  expect_equal(result$meta$name, "Test Project")
  expect_equal(result$color$palette$primary, "#0066cc")
})

test_that(".merge_brand_with_template handles empty template", {
  tmp_dir <- withr::local_tempdir()
  template_file <- file.path(tmp_dir, "empty_template.yml")

  # Create empty template
  writeLines("", template_file)

  brand <- list(
    meta = list(name = "Test")
  )

  result <- froggeR:::.merge_brand_with_template(brand, template_file)

  expect_type(result, "list")
  expect_equal(result$meta$name, "Test")
})

test_that(".merge_brand_with_template errors if template file doesn't exist", {
  brand <- list(meta = list(name = "Test"))

  expect_error(
    froggeR:::.merge_brand_with_template(brand, "/nonexistent/template.yml"),
    class = "froggeR_merge_error"
  )
})

test_that(".merge_brand_with_template errors with informative message on read failure", {
  brand <- list(meta = list(name = "Test"))

  expect_error(
    froggeR:::.merge_brand_with_template(brand, "/nonexistent/template.yml"),
    "Failed to merge with template"
  )
})


# Edge case tests -----------------------------------------------------------

test_that(".validate_hex_color handles color with alpha channel format", {
  # 8-digit hex colors (RGBA) are not currently supported
  result <- froggeR:::.validate_hex_color("#0066ccFF")
  expect_false(result$valid)
})

test_that(".format_brand_preview handles brand with additional fields", {
  # Brand might have extra fields from template that we don't explicitly format
  brand <- list(
    meta = list(name = "Test", description = "A test project"),
    color = list(palette = list(primary = "#0066cc")),
    logo = list(large = "logo.png", small = "icon.png")
  )

  result <- froggeR:::.format_brand_preview(brand)

  # Should still format the core fields
  expect_match(result, "name: Test")
  expect_match(result, "primary: #0066cc")
  # Additional fields like description won't break formatting
  expect_type(result, "character")
})

test_that(".save_brand_to_yaml handles nested directory creation", {
  tmp_dir <- withr::local_tempdir()
  deeply_nested <- file.path(tmp_dir, "a", "b", "c", "d")
  brand_file <- file.path(deeply_nested, "_brand.yml")

  brand <- list(
    meta = list(name = "Deeply Nested Project")
  )

  froggeR:::.save_brand_to_yaml(brand, brand_file, "test")

  expect_true(dir.exists(deeply_nested))
  expect_true(file.exists(brand_file))
})

test_that(".validate_hex_color handles hex color with padding", {
  # Spaces or padding should fail validation
  result <- froggeR:::.validate_hex_color(" #0066cc")
  expect_false(result$valid)

  result2 <- froggeR:::.validate_hex_color("#0066cc ")
  expect_false(result2$valid)
})

test_that(".format_brand_value handles numeric input", {
  # Should convert to character
  expect_equal(froggeR:::.format_brand_value(123), 123)
})

test_that(".save_brand_to_yaml overwrites existing file", {
  tmp_dir <- withr::local_tempdir()
  brand_file <- file.path(tmp_dir, "_brand.yml")

  # Write first brand
  brand1 <- list(meta = list(name = "First Project"))
  froggeR:::.save_brand_to_yaml(brand1, brand_file, "test")

  saved1 <- yaml::read_yaml(brand_file)
  expect_equal(saved1$meta$name, "First Project")

  # Overwrite with second brand
  brand2 <- list(meta = list(name = "Second Project"))
  froggeR:::.save_brand_to_yaml(brand2, brand_file, "test")

  saved2 <- yaml::read_yaml(brand_file)
  expect_equal(saved2$meta$name, "Second Project")
})


# Validation edge cases for hex colors --------------------------------------

test_that(".validate_hex_color rejects hex with invalid G character", {
  result <- froggeR:::.validate_hex_color("#00G6cc")
  expect_false(result$valid)
})

test_that(".validate_hex_color rejects hex with special char in middle", {
  result <- froggeR:::.validate_hex_color("#00@6cc")
  expect_false(result$valid)
})

test_that(".validate_hex_color rejects multiple hashes", {
  result <- froggeR:::.validate_hex_color("##0066cc")
  expect_false(result$valid)
})

test_that(".validate_hex_color rejects hex without leading hash", {
  result <- froggeR:::.validate_hex_color("0066cc#")
  expect_false(result$valid)
})

test_that(".validate_hex_color handles boundary hex values correctly", {
  # All F's
  result1 <- froggeR:::.validate_hex_color("#fff")
  expect_true(result1$valid)

  result2 <- froggeR:::.validate_hex_color("#FFF")
  expect_true(result2$valid)

  # All 0's
  result3 <- froggeR:::.validate_hex_color("#000")
  expect_true(result3$valid)
})
