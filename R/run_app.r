#' Run the Extension Materials Analysis Tool
#'
#' @export
run_app <- function() {
  # Find the app directory inside the installed package
  app_dir <- system.file("app", package = "shiny-extension-app")
  
  if (app_dir == "") {
    stop("Could not find app directory. Try re-installing `shiny-extension-app`.", call. = FALSE)
  }
  
  # Launch the app
  shiny::runApp(app_dir, display.mode = "normal")
}