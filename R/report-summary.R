#' Summary statistics report
#'
#' Generate detailed summary statistics for each variable/column in a data set.
#'
#' @param use_yaml Use YAML file to specify report details.
#'
#' @examples
#' \dontrun{
#' library(descriptr)
#' 
#' # interactive
#' report_descriptr()
#'
#' # use yaml file
#' report_descriptr(use_yaml = TRUE)
#'
#' }
#'
#' @importFrom fs dir_create file_create
#' @importFrom rmarkdown render
#' @importFrom utils browseURL
#'
#' @export
#'
report_descriptr <- function(use_yaml = FALSE) {

  if (use_yaml) {
    copy_yaml("descriptive")
    file.edit(glue(here(), "/_descriptive.yml"))
    cat(glue('Please update the report details in the ', green('_descriptive.yml'), ' file.'), "\n\n")
    sleep_time <- showPrompt("Update Time", "Specify the time required in seconds to update the YAML file?", 30)
    Sys.sleep(sleep_time)
    update_status <- showQuestion("File Status", "Have you updated the yaml file?", 
                         "Yes", "No")
    documentSaveAll()
    if (update_status) {
      descriptive_yaml <- read_yaml(glue(here(), "/_descriptive.yml"))  
    } else {
      stop("Please update the YAML file with the report details.", call. = FALSE)
    }
    
  }

  if (use_yaml) {
    folder_name   <- descriptive_yaml$report_folder
    file_name     <- descriptive_yaml$report_file
    report_title  <- descriptive_yaml$report_title
    report_author <- descriptive_yaml$report_author
    report_date   <- descriptive_yaml$report_date
    data_name     <- descriptive_yaml$data
    document_type <- descriptive_yaml$report_type

  } else {
    if (isAvailable()) {
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
    cat(blue$bold(symbol$tick), glue('Moving ', green("'_descriptive.yml'"), ' file to ', folder_name), '\n')
    file_move(glue(here(), "/_descriptive.yml"), glue(here(), "/", folder_name, "/_descriptive.yml"))
  }

  # add .Rmd extension to file_name
  report_file <- add_ext(folder_name, file_name)
  Sys.sleep(5)
  cat(blue$bold(symbol$tick), glue('Creating ', green("'"), green(file_name), 
                                 green("'"), ' file'), '\n')
  file_create(report_file)

  # copy template from inst folder
  Sys.sleep(5)
  cat(blue$bold(symbol$tick), glue('Copying report template into ', green("'"), green(folder_name), 
                                 green("'"), ' folder'), '\n')
  copy_template(folder_name, "descriptr_template")

  # add yaml
  Sys.sleep(5)
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
  cat(glue('report_data <- ', data_name), '\n', file = report_file, append =TRUE)
  cat('```', '\n', file = report_file, append =TRUE)

  # append template to report file
  path_temp <- glue(folder_name, "/", "descriptr_template.Rmd")
  file.append(report_file, path_temp)

  # load data
  Sys.sleep(5)
  cat(blue$bold(symbol$tick), glue('Loading data ', green("'"), green(data_name), 
                                 green("'")), '\n')
  prep_data(data_name)

  # build and view report
  Sys.sleep(5)
  cat(blue$bold(symbol$tick), glue('Generating ', green("'"), green(report_title), 
                                 green("'")), '\n')
  render(report_file, quiet = TRUE)
  report_name <- glue(folder_name, "/", file_name, ".", document_type)
  Sys.sleep(5)
  cat(blue$bold(symbol$tick), glue('Opening ', green("'"), green(report_title), 
                                 green("'"), ' in default browser'), '\n')
  browseURL(report_name)

}

