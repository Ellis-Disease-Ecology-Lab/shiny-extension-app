
#' Run the Extension Shiny App
#'
#' Launches the Shiny app from the installed package.
#' @export
run_app <- function(...) {
  app_dir <- system.file("app", package = "shinyExtensionApp")
  if (nzchar(app_dir) && dir.exists(app_dir)) {
    shiny::runApp(appDir = app_dir, launch.browser = TRUE, ...)
  } else {
    stop("Could not find app directory. Ensure the app is in 'inst/app' and reinstall the package.")
  }
}

