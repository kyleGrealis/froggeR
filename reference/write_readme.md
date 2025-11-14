# Create a Project README File

This function streamlines project documentation by creating a
`README.md` file and opening it for editing.

## Usage

``` r
write_readme(path = here::here())
```

## Arguments

- path:

  Character. Path to the project directory. Default is current project
  root via [`here`](https://here.r-lib.org/reference/here.html).

## Value

Invisibly returns the path to the created file.

## Details

The `README.md` template includes structured sections for:

- Project description (study name, principal investigator, author)

- Project setup steps for reproducibility

- File and directory descriptions

- Miscellaneous project notes

## See also

[`quarto_project`](https://www.kyleGrealis.com/froggeR/reference/quarto_project.md),
[`write_notes`](https://www.kyleGrealis.com/froggeR/reference/write_notes.md)

## Examples

``` r
# Create a temporary directory for testing
tmp_dir <- tempdir()

# Write the README file
write_readme(path = tmp_dir)
#> ✔ Created README.md

# Confirm the file was created
file.exists(file.path(tmp_dir, "README.md"))
#> [1] TRUE

# Clean up
unlink(file.path(tmp_dir, "README.md"))
```
