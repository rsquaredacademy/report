#' @importFrom rstudioapi showPrompt
ask_folder_name <- function() {
  showPrompt(title = "Folder Title",
                           message = "Title of the Folder",
                           default = "report")
}

ask_file_name <- function() {
  showPrompt(title = "File Title",
             message = "Title of the File",
             default = "report")
}

#' @importFrom glue glue
add_ext <- function(folder_name, file_name) {
  glue(folder_name, "/", file_name, ".Rmd")
}

#' @importFrom fs file_copy file_exists
#' @importFrom here here
copy_template <- function(folder_name, template_name) {
  pkg_loc <- find.package("report")
  template_path <- glue(pkg_loc, '/templates/', template_name, '.Rmd')
  report_path <- glue(here(), "/", folder_name, "/", template_name, ".Rmd")
  if (!file_exists(report_path)) {
    file_copy(template_path, report_path)
  }
}

copy_yaml <- function(yaml_name) {
  pkg_loc <- find.package("report")
  template_path <- glue(pkg_loc, '/yaml/_', yaml_name, '.yml')
  report_path <- glue(here(), "/_", yaml_name, ".yml")
  if (!file_exists(report_path)) {
    file_copy(template_path, report_path)
  }
}

ask_title <- function() {
  showPrompt(title = "Report Title",
             message = "Title of the Report",
             default = "report")
}

ask_author <- function() {
  showPrompt(title = "Report Author",
             message = "Author of the Report",
             default = NULL)
}

#' @importFrom lubridate today
ask_date <- function() {
  showPrompt(title = "Report Date",
             message = "Date of the Report",
             default = as.character(today()))
}

ask_model <- function() {
  showPrompt(title = "Define Model",
             message = "Write the model formula",
             default = NULL)
}

ask_type <- function() {
  showPrompt(title = "Document Type",
             message = "Specify the document type (pdf or html)",
             default = "html")
}

add_yaml <- function(report_file) {

}

ask_data_name <- function() {
  showPrompt(title = "Data Name",
             message = "Specify the name of the data set",
             default = NULL)
}

ask_analysis_date <- function() {
  showPrompt(title = "Analysis Date",
             message = "Specify the date of analysis",
             default = as.character(today()))
}

ask_customer_id <- function() {
  showPrompt(title = "Customer ID",
             message = "Specify the name of the column to identify customer id",
             default = "customer_id")  
}

ask_order_date <- function() {
  showPrompt(title = "Order Date",
             message = "Specify the name of the column to identify order date",
             default = "order_date")  
}

ask_revenue <- function() {
  showPrompt(title = "Revenue",
             message = "Specify the name of the column to identify revenue",
             default = "revenue")  
}


prep_data <- function(mydata) {
  save(mydata, file = glue(mydata, ".RData"))
  load(glue(here(), '/', mydata, '.RData'))
}