library(testthat)
library(froggeR)

test_that("quarto_project errors with deprecation message", {
  expect_error(
    quarto_project(name = "test"),
    "quarto_project\\(\\) has been removed",
    class = "froggeR_deprecated"
  )
})
