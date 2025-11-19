# Extension Materials Analysis Tool

**The app is also hosted at:** [https://811l41-vincenzo-ellis.shinyapps.io/Extension/](https://811l41-vincenzo-ellis.shinyapps.io/Extension/)

It was created by the [VectorED Network](https://www.vectorednetwork.org/).

This repository contains an R Shiny application for evaluating and improving extension materials. It is packaged as an R package to simplify installation and local execution (i.e., so you can more easily run it on your own computer).

## Overview

This tool allows users to:
- Score statements about extension materials on a 1-4 scale (Poor to Excellent).
- Generate visual radar charts of the scoring and tables identifying statements that scored poorly and provide suggestions for improvement.
- Download HTML reports with the outputs and time stamp for record keeping.

## Installation

You can install the application directly from GitHub using the `devtools` package. This will automatically install required dependencies.

1. Open R or RStudio.
2. Run the following commands:

```r
# Install devtools if you do not have it already
if (!require("devtools")) install.packages("devtools")

# Install the shiny-extension-app package
devtools::install_github("Ellis-Disease-Ecology-Lab/shiny-extension-app")
```

## Running the App

Once installed, you can launch the application with:

```r
shiny-extension-app::run_app()
```

## Dependencies

This app relies on several R packages, which are installed automatically during the step above. Notable dependencies include:
- `shiny` & `bslib` (UI/Server)
- `tidyverse`
- `ggradar2` (Radar charts - *installed from GitHub*)
- `DT` (Interactive tables)