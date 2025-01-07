test_that("write_readme creates README file without overwriting", {
  tmp_dir <- tempdir()
  readme_path <- file.path(tmp_dir, "README.md")
  
  # Ensure the file doesn't exist
  if (file.exists(readme_path)) file.remove(readme_path)
  if (file.exists(readme_path)) print('yes') #file.remove(readme_path)
  
  # Create the file
  write_readme(path = tmp_dir)
  expect_true(file.exists(readme_path))
  
  # Test no overwrite
  expect_error(write_readme(path = tmp_dir), "has been found")
})

