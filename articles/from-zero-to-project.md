# From Zero to Project in Seconds

## The case for convention

Most programming languages agree on where files belong. Python has its
package layout. Node has `src/`, `public/`, `package.json`. Others give
you a directory tree on day one.

R has strong conventions for packages (`R/`, `man/`, `inst/`), but
analytical projects have not always had the same structure. Marwick,
Boettiger, and Mullen (2018) proposed the *research compendium* as a
standard way to organize the digital materials of a project so that
others can inspect, reproduce, and extend the work. Their layout uses
familiar R package conventions and adds an `analysis/` directory for the
project’s computational work.

[froggeR](https://kylegrealis.github.io/froggeR/) builds on this idea,
adapting it for Quarto-based projects:

- `R/` for scripts
- `analysis/` for Quarto (and .Rmd) documents
- `www/` for stylesheets and assets
- `data/` for data files
- `logos/` for brand images

The same convention maps to R package structure, to Shiny frameworks
like [rhino](https://appsilon.github.io/rhino/), and to web frameworks
in other languages.

## `init()`

One command builds the full scaffold:

``` r

froggeR::init(path = "my_project")
```

    my_project/
    ├── .agents/                  # AI agent skills (workflow, brand, devlog, commit)
    ├── R/
    │   ├── _data_dictionary.R    # Variable labels and metadata
    │   ├── _libraries.R          # Centralized package loading
    │   └── _load.R               # Sources everything. Your entry point.
    ├── analysis/
    │   ├── index.qmd             # Main Quarto document
    │   └── references.bib        # Bibliography
    ├── www/
    │   ├── custom.scss           # Custom styling
    │   └── tables.js             # Table enhancements
    ├── logos/                    # Brand logos
    ├── data/                     # Data files (gitignored)
    ├── AGENTS.md                 # Project conventions for AI coding assistants
    ├── CLAUDE.md                 # Pointer to AGENTS.md and .agents/skills/
    ├── GEMINI.md                 # Pointer to AGENTS.md and .agents/skills/
    ├── _brand.yml                # Quarto brand configuration
    ├── _quarto.yml               # Quarto project configuration
    ├── _variables.yml            # Author metadata
    ├── .gitignore                # Opinionated git protection
    └── README.md

[`init()`](https://kylegrealis.github.io/froggeR/reference/init.md)
creates the target directory if it does not exist, downloads the latest
template from
[frogger-templates](https://github.com/kyleGrealis/frogger-templates),
and copies only files that are not already present. Existing files are
never overwritten. If you have previously saved global config with
[`save_variables()`](https://kylegrealis.github.io/froggeR/reference/save_variables.md)
or
[`save_brand()`](https://kylegrealis.github.io/froggeR/reference/save_brand.md),
your metadata and branding are applied automatically.

### What each directory is for

**`R/`** contains R scripts. `_load.R` is the entry point: it sources
`_libraries.R` (package loading) and `_data_dictionary.R` (variable
labels and metadata). Add your own scripts here.

**`analysis/`** contains Quarto documents. `index.qmd` is the default
landing page. `references.bib` holds your bibliography. Add new analysis
files with
[`write_quarto()`](https://kylegrealis.github.io/froggeR/reference/write_quarto.md).

**`www/`** contains web assets. `custom.scss` controls document styling.
`tables.js` provides table enhancements. Keep stylesheets, images, and
scripts here.

**`data/`** is for data files. It is gitignored by default, so you can
keep raw and processed data here without worrying about accidentally
committing it.

**`logos/`** holds brand images referenced by `_brand.yml`.

### Root-level configuration

The files in the project root are configuration:

- **`_quarto.yml`** defines project-level rendering options. See [Quarto
  Project
  Basics](https://quarto.org/docs/projects/quarto-projects.html).
- **`_brand.yml`** defines your visual identity: colors, logos,
  typography. See [Quarto
  Brand](https://quarto.org/docs/authoring/brand.html).
- **`_variables.yml`** stores author metadata: name, email, etc.
- **`.gitignore`** keeps R artifacts, rendered output, and data files
  out of version control.
- **`AGENTS.md`** (`CLAUDE.md`, `GEMINI.md`) and **`.agents/skills/`**
  provide project architecture instructions and workflow skills for AI
  coding assistants.

## Built-in AI agent skills

The template includes `AGENTS.md` (along with `CLAUDE.md` and
`GEMINI.md` pointers) and four project skills inside `.agents/skills/`
so AI coding assistants understand
[froggeR](https://kylegrealis.github.io/froggeR/) conventions without
manual prompting:

- **`frogger-workflow`**: Scaffolds new Quarto documents in `analysis/`,
  keeps [`library()`](https://rdrr.io/r/base/library.html) calls
  centralized in `R/_libraries.R`, updates variable labels in
  `R/_data_dictionary.R`, and manages styles in `www/`.
- **`frogger-brand`**: Walks through setting up `_variables.yml` and
  `_brand.yml`, wires metadata and brand logo shortcodes into documents,
  and persists defaults to your global
  [froggeR](https://kylegrealis.github.io/froggeR/) config.
- **`frogger-devlog`**: Audits R and Quarto code comments, records
  analytical and methodological choices in `DECISIONS.md`, and maintains
  `CHANGELOG.md`.
- **`frogger-commit`**: Drafts structured `type(scope): summary` git
  commit messages with 2-space indented bullets explaining what changed
  and why.

## Your settings follow you

[froggeR](https://kylegrealis.github.io/froggeR/) stores configuration
in two places:

1.  **Project-level**: `_variables.yml` and `_brand.yml` in your project
    directory. These are committed to version control and used by the
    current project.
2.  **Global**: Your system’s configuration directory, managed by the
    `rappdirs` package.
    - Linux/macOS: `~/.config/froggeR/`
    - Windows: `C:\Users\<username>\AppData\Local\froggeR\`

Global config is set once and applied to every future project created
with
[`init()`](https://kylegrealis.github.io/froggeR/reference/init.md).
Edit the project copy directly when you need something specific.

If you have configured global settings before running
[`init()`](https://kylegrealis.github.io/froggeR/reference/init.md),
your new project inherits them automatically:

- **`_variables.yml`**: Global config overwrites the template version
- **`_brand.yml`**: Global config overwrites the template version
- **`logos/`**: Global logos supplement the template (adds missing logos
  without removing existing ones)

Use
[`write_variables()`](https://kylegrealis.github.io/froggeR/reference/write_variables.md)
and
[`write_brand()`](https://kylegrealis.github.io/froggeR/reference/write_brand.md)
to create and edit your configuration files, then
[`save_variables()`](https://kylegrealis.github.io/froggeR/reference/save_variables.md)
and
[`save_brand()`](https://kylegrealis.github.io/froggeR/reference/save_brand.md)
to persist them globally. Every future
[`init()`](https://kylegrealis.github.io/froggeR/reference/init.md) call
starts with your configuration in place.

## References

Marwick, B., Boettiger, C., & Mullen, L. (2018). Packaging data
analytical work reproducibly using R (and friends). *The American
Statistician*, 72(1), 80-88.
[doi:10.1080/00031305.2017.1375986](https://doi.org/10.1080/00031305.2017.1375986)
