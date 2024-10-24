% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/quarto_project.R
\name{quarto_project}
\alias{quarto_project}
\title{Create a custom Quarto project}
\usage{
quarto_project(name, default = TRUE)
}
\arguments{
\item{name}{The name of the Quarto project directory and initial \code{.qmd} file.}

\item{default}{Set to TRUE. This will use the custom YAML within the initial 
\code{.qmd} file. See \code{?froggeR::write_quarto()} for more details on
the default setting.}
}
\value{
A Quarto project with \code{.qmd}, \code{.gitignore}, & \code{README.md} files.
}
\description{
This function is a wrapper for \code{quarto::quarto_create_project()} and adds some
other \code{froggeR} goodies. First, new Quarto project is created in the provided
\code{name} directory. Then, the original \code{.qmd} file created from the 
\code{quarto::quarto_create_project()} is replaced with \code{froggeR::write_quarto()}.
}
\details{
Since this will most likely be a new project directory, \code{froggeR} searches for 
the existence of three other files:

   - \code{_variables.yml}

   - \code{.gitignore}

   - \code{README.md}

If these files do not exist, \code{froggeR} will write them to the new project 
directory.
}
\examples{
\dontrun{
# Create a new Quarto project that uses a custom formatted YAML header and
# all other listed files:
quarto_project('new_project', default = TRUE)

# Create a new Quarto project with generic YAML and all other listed files:
quarto_project('new_project_2', default = FALSE)
}
}
