#' Logistic regression report
#'
#' Generate detailed logistic regression report. 
#'
#' @param use_yaml Use YAML file to specify report details.
#'
#' @examples
#' \dontrun{
#' model_data <- blorr::bank_marketing
#' 
#' # interactive
#' report_blr()
#'
#' # use yaml file
#' report_blr(use_yaml = TRUE)
#' }
#'
#' @importFrom rstudioapi sendToConsole
#'
#' @export
#'
report_blr <- function(use_yaml = FALSE) {

  if (use_yaml) {
    copy_yaml("logistic")
    file.edit(glue(here(), "/_logistic.yml"))
    cat(glue('Please update the report details in the ', green('_logistic.yml'), ' file.'), "\n\n")
    sleep_time <- showPrompt("Update Time", "Specify the time required in seconds to update the YAML file?", 30)
    Sys.sleep(sleep_time)
    update_status <- showQuestion("File Status", "Have you updated the yaml file?", 
                         "Yes", "No")
    documentSaveAll()
    if (update_status) {
      logistic_yaml <- read_yaml(glue(here(), "/_logistic.yml"))  
    } else {
      stop("Please update the YAML file with the report details.", call. = FALSE)
    }
    
  }

  if (use_yaml) {
    folder_name   <- logistic_yaml$report_folder
    file_name     <- logistic_yaml$report_file
    report_title  <- logistic_yaml$report_title
    report_author <- logistic_yaml$report_author
    report_date   <- logistic_yaml$report_date
    data_name     <- logistic_yaml$data
    model_formula <- logistic_yaml$model
    document_type <- logistic_yaml$report_type

  } else {
    if (isAvailable()) {
    folder_name   <- ask_folder_name()
    file_name     <- ask_file_name()
    report_title  <- ask_title()
    report_author <- ask_author()
    report_date   <- ask_date()
    data_name     <- ask_data_name()
    model_formula <- ask_model()
    document_type <- ask_type() 
    } else {
      stop("RStudio must be installed.", call. = FALSE)
    }
    
  }

  # prep report folders and file
  cat(blue$bold(symbol$tick), glue('Creating ', green("'"), green(folder_name), 
                                 green("'"), ' folder'), '\n')
  dir_create(folder_name)
  if (use_yaml) {
    Sys.sleep(2)
    cat(blue$bold(symbol$tick), glue('Moving ', green("'_logistic.yml'"), ' file to ', folder_name), '\n')
    file_move(glue(here(), "/_logistic.yml"), glue(here(), "/", folder_name, "/_logistic.yml"))
  }

  # add .Rmd extension to file_name
  report_file <- add_ext(folder_name, file_name)
  Sys.sleep(2)
  cat(blue$bold(symbol$tick), glue('Creating ', green("'"), green(file_name), 
                                 green("'"), ' file'), '\n')
  file_create(report_file)

  # copy template from inst folder
  Sys.sleep(2)
  cat(blue$bold(symbol$tick), glue('Copying report template into ', green("'"), green(folder_name), 
                                 green("'"), ' folder'), '\n')
  copy_template(folder_name, "blorr_template")

  # add yaml
  Sys.sleep(2)
  cat(blue$bold(symbol$tick), glue('Adding YAML to ', green("'"), green(file_name), 
                                 green("'"), ' file'), '\n')
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

  # read data
  cat('```{r read, message=FALSE, echo=FALSE}', '\n', file = report_file, append =TRUE)
  cat(glue('load("', here(), '/', data_name, '.Rdata")'), '\n', file = report_file, append =TRUE)
  cat(glue('model_data <- ', data_name), '\n', file = report_file, append =TRUE)
  cat('```', '\n', file = report_file, append =TRUE)

  # add model
  use_model <- glue('model <- glm(', model_formula, ', data = ', data_name, ', family = binomial(link = "logit"))')
  cat('## Model', '\n\n', file = report_file, append =TRUE)
  cat('```{r model, echo=FALSE}', '\n', file = report_file, append =TRUE)
  cat(use_model, '\n', file = report_file, append =TRUE)
  cat('```', '\n', file = report_file, append =TRUE)

  # append template to report file
  path_temp <- glue(folder_name, "/", "blorr_template.Rmd")
  file.append(report_file, path_temp)

  # load data
  Sys.sleep(2)
  cat(blue$bold(symbol$tick), glue('Loading data ', green("'"), green(data_name), 
                                 green("'")), '\n')
  prep_data(data_name)

  # build and view report
  Sys.sleep(2)
  cat(blue$bold(symbol$tick), glue('Generating ', green("'"), green(report_title), 
                                 green("'")), '\n')
  render(report_file, quiet = TRUE)
  report_name <- glue(folder_name, "/", file_name, ".", document_type)
  Sys.sleep(2)
  cat(blue$bold(symbol$tick), glue('Opening ', green("'"), green(report_title), 
                                 green("'"), ' in default browser'), '\n')
  browseURL(report_name)

}

