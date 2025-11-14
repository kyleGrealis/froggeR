## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----echo=FALSE, fig.align='center', fig.cap='Example output of custom_yaml document', out.width='85%'----
knitr::include_graphics("../man/figures/custom-yaml-rendered.png")

## ----eval=FALSE---------------------------------------------------------------
# # Create new project
# froggeR::quarto_project(name = "frogs")

## ----eval=FALSE---------------------------------------------------------------
# # Add analysis documents
# froggeR::write_quarto(
#   filename = "data_prep"
# )
# 
# froggeR::write_quarto(
#   filename = "analysis"
# )

## ----eval=FALSE---------------------------------------------------------------
# froggeR::quarto_project(name = "my_project")

## ----eval=FALSE---------------------------------------------------------------
# # Data preparation
# froggeR::write_quarto(filename = "01_data_prep")
# 
# # Analysis
# froggeR::write_quarto(filename = "02_analysis")
# 
# # Results
# froggeR::write_quarto(filename = "03_results")

