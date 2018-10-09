#' RFM report
#'
#' Generate recency, frequency and monetary value analysis report.
#'
#' @param use_yaml Use YAML file to specify report details.
#'
#' @examples
#' \dontrun{
#' rfm_data <- rfm::rfm_data_orders
#' 
#' # interactive
#' report_rfm()
#'
#' # use yaml file
#' report_rfm(use_yaml = TRUE)
#'
#' }
#'
#' @importFrom yaml read_yaml
#' @importFrom fs file_move
#' @importFrom rstudioapi showQuestion documentSaveAll
#'
#' @export
#'
report_rfm <- function(use_yaml = FALSE) {

  if (use_yaml) {
    copy_yaml("rfm")
    file.edit(glue(here(), "/_rfm.yml"))
    cat(glue('Please update the report details in the ', green('_rfm.yml'), ' file.'), "\n\n")
    sleep_time <- showPrompt("Update Time", "Specify the time required in seconds to update the YAML file?", 30)
    Sys.sleep(sleep_time)
    update_status <- showQuestion("File Status", "Have you updated the yaml file?", 
                         "Yes", "No")
    documentSaveAll()
    if (update_status) {
      rfm_yaml <- read_yaml(glue(here(), "/_rfm.yml"))  
    } else {
      stop("Please update the YAML file with the report details.", call. = FALSE)
    }
    
  }

  if (use_yaml) {
    folder_name   <- rfm_yaml$report_folder
    file_name     <- rfm_yaml$report_file
    report_title  <- rfm_yaml$report_title
    report_author <- rfm_yaml$report_author
    report_date   <- rfm_yaml$report_date
    data_name     <- rfm_yaml$data
    document_type <- rfm_yaml$report_type

  } else {
    if (isAvailable) {
      folder_name   <- ask_folder_name()
      file_name     <- ask_file_name()
      report_title  <- ask_title()
      report_author <- ask_author()
      report_date   <- ask_date()
      data_name     <- ask_data_name()
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
    cat(blue$bold(symbol$tick), glue('Moving ', green("'_rfm.yml'"), ' file to ', folder_name), '\n')
    file_move(glue(here(), "/_rfm.yml"), glue(here(), "/", folder_name, "/_rfm.yml"))
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
  copy_template(folder_name, "rfm_template")

  if (use_yaml) {
      analysis_date <- rfm_yaml$analysis_date
      customer_id   <- rfm_yaml$customer_id
      order_date    <- rfm_yaml$order_date
      revenue       <- rfm_yaml$revenue
    } else {
      analysis_date <- ask_analysis_date()
      customer_id   <- ask_customer_id()
      order_date    <- ask_order_date()
      revenue       <- ask_revenue()
    }
  
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
  cat(glue('rfm_data_orders <- ', data_name), '\n', file = report_file, append =TRUE)
  cat('suppressWarnings(suppressMessages(library(rfm, quietly = TRUE)))', '\n', file = report_file, append =TRUE)
  cat('suppressWarnings(suppressMessages(library(lubridate, quietly = TRUE)))', '\n', file = report_file, append =TRUE)
  cat(glue('analysis_date <- as_date("', analysis_date, '", tz = "UTC")'), '\n', file = report_file, append =TRUE)
  cat('rfm_result <- rfm_table_order(rfm_data_orders, customer_id, order_date, revenue, analysis_date)', '\n', file = report_file, append =TRUE)	
  cat('```', '\n', file = report_file, append =TRUE)

  # append template to report file
  path_temp <- glue(folder_name, "/", "rfm_template.Rmd")
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
