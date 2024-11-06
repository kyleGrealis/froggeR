# Repository Name

**PI**: add contact info if the repo is private.

**Code Authors**: 

**Description**: Follow the name with a *brief* description of what the project does.  Say the source of the data. If the data is public add reference here.

**Notes**: The progress notes are here [DATED_PROGRESS_NOTES.md](dated_progress_notes.md).

## Run Me First

Include the packages needed.  Consider using either `remotes` or `pak`

```r
install.packages("remotes")

remotes::install_cran(
  c("conflicted", "tidyverse", "tidymodels", "knitr", "tidyREDCap")
)
# remotes::install_github()
```

## Raw Data

The names of each raw file with a brief descriptions 

`file_name`:  what the is file

## Directories

`path`: what goes in the directory

## Ordered Analysis Pipeline/ Workflow

Run these file in order from raw processing to publication.

1.
2.
3.

## Other Files

**Data**: Include enough information to trace the data to its origin.  This may be URLs or emails (with who sent it and who received it on what date).

**Preprocessing/Anonymization**: 
If the project began with confidential data, include the **paths** to the code that processed the sensitive data here.

**Miscellaneous**: Things like .ccs, .csl, .bib, .js, .sass files.
