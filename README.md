
<!-- README.md is generated from README.Rmd. Please edit that file -->
report
======

> Generate automated reports from Rsquared Academy packages

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/reports)](https://cran.r-project.org/package=rfm) [![Travis-CI Build Status](https://travis-ci.org/rsquaredacademy/reports.svg?branch=master)](https://travis-ci.org/rsquaredacademy/reports) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/rsquaredacademy/reports?branch=master&svg=true)](https://ci.appveyor.com/project/rsquaredacademy/reports) ![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)

The goal of report is to generate automated reports for summary statistics, RFM analysis, linear and logistic regression using the following packages:

-   [descriptr](https://descriptr.rsquaredacademy.com)
-   [rfm](https://rfm.rsquaredacademy.com)
-   [olsrr](https://olsrr.rsquaredacademy.com)
-   [blorr](https://blorr.rsquaredacademy.com)

Installation
------------

report is not available on CRAN yet. You can install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("rsquaredacademy/reports")
```

Usage
-----

Before generating the reports, it is important to ensure that the data used in the report is defined in the current session i.e. when you run `ls()` in the console, the data must be listed by R.

### Summary Statistics

``` r
library(descriptr)
report_descriptr()
```

### RFM Analysis

``` r
rfm_data <- rfm::rfm_data_orders
report_rfm()
```

### Linear Regression

``` r
model_data <- descriptr::mtcarz
report_ols()
```

### Logistic Regression

``` r
model_data <- blorr::bank_marketing
report_blr()
```

Community Guidelines
--------------------

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
