# Antenna Tool

This is a shiny app for evaluating and improving extension materials. Here you can download it as an R package to run it on your own computer.

**The app is also hosted at:** [https://811l41-vincenzo-ellis.shinyapps.io/Extension/](https://811l41-vincenzo-ellis.shinyapps.io/Extension/)

This is a product of the [VectorED Network](https://www.vectorednetwork.org/).

## Overview

The app is designed to allow users to:
- Score statements about extension materials on a 1-4 scale (Poor to Excellent).
- Generate radar charts and tables to summarize the scores.
- Offer suggestions for improvement for statements that receive low scores.
- Download an HTML summary report with a time stamp.

## Installation

You can install the application from GitHub using the `devtools` package. Run the following commands in R.

```r
# Install devtools if you do not have it already
if (!require("devtools")) install.packages("devtools")

# Install the package
devtools::install_github("Ellis-Disease-Ecology-Lab/shiny-extension-app")
```

## Running the App

Once installed, you can launch the shiny app with the following command.

```r
shinyExtensionApp::run_app()
```

## Dependencies

This app relies on several R packages, which are installed automatically during the steps above. Those additional R packages are:
- `shiny`
- `bslib`
- `tidyverse`
- `ggradar2`
- `DT`
