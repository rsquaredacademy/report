#' Sample reports
#'
#' View sample reports.
#'
#' @examples
#' \dontrun{
#' view_report_ols()
#' view_report_blr()
#' view_report_rfm()
#' view_report_descriptr()
#' }
#'
#' @export
#'
view_report_ols <- function() {
  pkg_loc <- find.package("report")
  file_name <- glue(pkg_loc, "/samples/olsrr_report.html")
  browseURL(file_name)
}

#' @rdname view_report_ols
#' @export
#'
view_report_blr <- function() {
  pkg_loc <- find.package("report")
  file_name <- glue(pkg_loc, "/samples/blorr_report.html")
  browseURL(file_name)
}

#' @rdname view_report_ols
#' @export
#'
view_report_rfm <- function() {
  pkg_loc <- find.package("report")
  file_name <- glue(pkg_loc, "/samples/rfm_report.html")
  browseURL(file_name)
}

#' @rdname view_report_ols
#' @export
#'
view_report_descriptr <- function() {
  pkg_loc <- find.package("report")
  file_name <- glue(pkg_loc, "/samples/summary_report.html")
  browseURL(file_name)
}
