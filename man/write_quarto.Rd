% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write_quarto.R
\name{write_quarto}
\alias{write_quarto}
\title{Start a Quarto file with a formatted template header}
\usage{
write_quarto(
  filename = "frogs",
  path = getwd(),
  default = TRUE,
  is_project = FALSE
)
}
\arguments{
\item{filename}{The name of the file without the '.qmd' extension. Only letters,
numbers, hyphens, and underscores are allowed.}

\item{path}{The path to the main project level. Defaults to the
current working directory.}

\item{default}{The default is set to TRUE and will create a Quarto template file
that pulls information from the folder/_variables.yml file.}

\item{is_project}{Set to \code{TRUE} when used within a Quarto project (internal use).}
}
\value{
Creates a new Quarto document with formatted YAML and two blank starter
sections. Returns \code{invisible(NULL)}.
}
\description{
This function creates a new Quarto document with a pre-formatted YAML header. The
default template requires a \code{_variables.yml} file. If none exists in the project,
it will be created. The \code{_variables.yml} allows for a reusable custom header that
will be applied to all \code{froggeR} default-style Quarto documents.
}
\details{
When \code{default = TRUE}, the function will create or verify the existence of:\cr
* \code{_variables.yml} - For document metadata\cr
* \code{custom.scss} - For document styling\cr
* \code{_quarto.yml} - For project configuration

If any of these files already exist, they will not be modified. For styling options,
visit \url{https://quarto.org/docs/output-formats/html-themes.html}.
}
\examples{
\dontrun{
# Create a new Quarto document with default settings
write_quarto(filename = "frogs", path = "path/to/project")

# Create a basic Quarto document without custom formatting
write_quarto(filename = "simple_doc", default = FALSE)
}
}
