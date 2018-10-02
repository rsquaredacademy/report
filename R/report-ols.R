#' Linear regression report
#'
#' Generate detailed linear regression report.
#'
#' @importFrom fs dir_create file_create
#' @importFrom rmarkdown render
#' @importFrom utils browseURL
#'
#' @export
#'
report_ols <- function() {

  # prompt report details
  folder_name   <- ask_folder_name()
  file_name     <- ask_file_name()
  report_title  <- ask_title()
  report_author <- ask_author()
  report_date   <- ask_date()
  model_formula <- ask_model()
  document_type <- ask_type()

  # prep report folders and file
  dir_create(folder_name)

  # add .Rmd extension to file_name
  report_file <- add_ext(folder_name, file_name)
  file_create(report_file)

  # copy template from inst folder
  copy_template(folder_name)

  # add yaml
  cat('---\n', file = report_file, append =FALSE)
  cat(glue('title: "', {report_title}, '"', '\n\n'), file = report_file,
      append =TRUE)
  cat(glue('author: "', {report_author}, '"', '\n\n'), file = report_file,
      append =TRUE)
  cat(glue('date: "', {report_date}, '"', '\n\n'), file = report_file,
      append =TRUE)
  cat(glue('output: ', {document_type}, '_document', '\n\n'), file = report_file,
      append =TRUE)
  cat('---\n\n\n', file = report_file, append =TRUE)

  # add model
  use_model <- glue('model <- ', model_formula)
  cat('## Model', '\n\n', file = report_file, append =TRUE)
  cat('```{r model, echo=FALSE}', '\n', file = report_file, append =TRUE)
  cat(use_model, '\n', file = report_file, append =TRUE)
  cat('```', '\n', file = report_file, append =TRUE)

  # append template to report file
  path_temp <- glue(folder_name, "/", "olsrr_template.Rmd")
  file.append(report_file, path_temp)

  # build and view report
  render(report_file)
  report_name <- glue(folder_name, "/", file_name, ".", document_type)
  browseURL(report_name)

}

