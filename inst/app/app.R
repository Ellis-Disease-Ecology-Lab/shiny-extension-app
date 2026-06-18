
## ggradar2
# devtools::install_github("xl0418/ggradar2", dependencies = TRUE)

library(shiny)
library(bslib)
library(shinythemes) # optional; using bslib bootswatch instead
library(shinyWidgets)
library(tidyverse)
library(ggradar2)
library(DT)

# ---- Theme (Lumen aesthetic + brand colors) ----
brand_theme <- bs_theme(
  version   = 5,
  bootswatch = "lumen",
  primary   = "#001E44",  # deep blue
  secondary = "#3EA39E",  # teal
  info      = "#1E407C"   # mid-blue
)

# ---- 1-4 scale choices ----
choices_1_4 <- c("Poor" = 1, "Fair" = 2, "Acceptable" = 3, "Excellent" = 4)


# ---- CSV loader (prefers data/ over app root over www/) ----
sugg_csv_candidates <- c(
  file.path("data", "improvement suggestions for shiny report_AMT.csv"),
  "improvement suggestions for shiny report_AMT.csv",
  file.path("www", "improvement suggestions for shiny report_AMT.csv")
)
sugg_csv_path <- sugg_csv_candidates[file.exists(sugg_csv_candidates)][1]

read_suggestions_csv <- function(path) {
  readr::read_csv(path, show_col_types = FALSE, progress = FALSE) |>
    dplyr::rename(qnum = statement_number) |>
    dplyr::mutate(qnum = as.integer(qnum)) |>
    dplyr::select(qnum, category, statement, suggestion) |>
    dplyr::arrange(qnum)
}


# =========================
# UI
# =========================
ui <- fluidPage(
  theme = brand_theme,
  
  tags$head(tags$style(HTML("
    .app-header { display:flex; align-items:center; gap:12px; margin-bottom:8px; }
    .app-header img { height:140px; width:auto; }
    .app-header .title { font-size:1.5rem; font-weight:600; color:#0d6efd; }
  "))),
  
  # Custom header row with logo + link
#  div(class = "app-header",
      # Logo as clickable link
#      tags$a(
#        href = "https://www.vectorednetwork.org/#",
#        target = "_blank",
#        tags$img(
#          src = "img/VectorED Logo with Print.png",
#          alt = "Organization logo",
#          style = "height: 140px;"
#        )
#      ),
      # Spacer
#      div(style = "flex:1;")
#  ),
  
  # App title
  titlePanel("Antenna Tool"),
  
  # Link to the Word document (normal case, not all caps)
  fluidRow(
    column(
      width = 12,
      div(style = "margin-bottom: 10px;",
          tags$a(
            "Scoring Guide Document",
            href   = "Extension_Materials_Scoring_Guide_Brand.pdf",  # place in /www
            target = "_blank",
            class  = "btn btn-link p-0 fw-bold",
            style  = "font-size: 1.4rem; text-transform: none;"
          )
      )
    )
  ),
  
  # Generate report toggle + (optional) link to last generated report
  fluidRow(
    column(
      width = 12,
      div(class = "d-flex align-items-center gap-3",
          shinyWidgets::switchInput(
            inputId  = "gen_report",
            label    = "Generate report", # label shown to the left of the switch
            value    = FALSE,             # default OFF
            onLabel  = "Yes",
            offLabel = "No",
            size     = "small",           # "mini", "small", "normal", "large"
            inline   = TRUE
          ),
          uiOutput("lastReportLink")      # optional link to the last generated report
      )
    )
  ),
  
  # Layout
  sidebarLayout(
    sidebarPanel(
      width = 4,
      h3("Rate your extension material."),
      p(HTML(
        paste0(
          "Please rate each of the following 27 statements (grouped into five categories) using the dropdown menus. ",
          "<b>Ratings are on a 4-point scale</b>: ",
          "(Poor = 1, Fair = 2, Acceptable = 3, Excellent = 4)."
        )
      )),
      
      # Free response: document name
      textInput(
        inputId = "doc_name",
        label   = "Name of the document being evaluated",
        value   = "Example Extension Document",
        width   = "100%"
      ),
      
      # --- Category 1 ---
      tags$hr(),
      h4("Standards"),
      selectInput("c1_q1", "1. The document is free of grammatical errors.", choices = choices_1_4, selected = 3),
      selectInput("c1_q2", "2. The document is free of spelling errors.", choices = choices_1_4, selected = 3),
      selectInput("c1_q3", "3. The document is presented at a 6th grade reading level.", choices = choices_1_4, selected = 3),
      selectInput("c1_q4", "4. The document identifies a target audience or area.", choices = choices_1_4, selected = 3),
      selectInput("c1_q5", "5. The document uses appropriate language and graphics.", choices = choices_1_4, selected = 3),
      selectInput("c1_q6", "6. The document was created by a trusted source.", choices = choices_1_4, selected = 3),
      selectInput("c1_q7", "7. The document identifies a problem.", choices = choices_1_4, selected = 3),
      selectInput("c1_q8", "8. The document provides opportunity for more information.", choices = choices_1_4, selected = 3),
      
      # --- Category 2 ---
      tags$hr(),
      h4("Content Development"),
      selectInput("c2_q1", "9. Content is accurate.", choices = choices_1_4, selected = 3),
      selectInput("c2_q2", "10. Content is the appropriate amount of information.", choices = choices_1_4, selected = 3),
      selectInput("c2_q3", "11. The document provides a simple solution to a problem.", choices = choices_1_4, selected = 3),
      selectInput("c2_q4", "12. The document provides content on HOW to use the solution.", choices = choices_1_4, selected = 3),
      selectInput("c2_q5", "13. The document provides content on WHEN to use the solution.", choices = choices_1_4, selected = 3),
      selectInput("c2_q6", "14. The document provides content on WHERE to use the solution.", choices = choices_1_4, selected = 3),
      selectInput("c2_q7", "15. The document provides reason or cause for using the solution.", choices = choices_1_4, selected = 3),
      
      # --- Category 3 ---
      tags$hr(),
      h4("Targeted Messaging"),
      selectInput("c3_q1", "16. The document is accessible.", choices = choices_1_4, selected = 3),
      selectInput("c3_q2", "17. The document is culturally relevant.", choices = choices_1_4, selected = 3),
      selectInput("c3_q3", "18. The document uses graphics/models in illustrations that reflect target audience(s) or area(s).", choices = choices_1_4, selected = 3),
      
      # --- Category 4 ---
      tags$hr(),
      h4("Visual Design"),
      selectInput("c4_q1", "19. The document is clear and organized.", choices = choices_1_4, selected = 3),
      selectInput("c4_q2", "20. The document is visually appealing including design, font, and layout.", choices = choices_1_4, selected = 3),
      selectInput("c4_q3", "21. The document uses graphics and icons.", choices = choices_1_4, selected = 3),
      selectInput("c4_q5", "22. The document is creative and original.", choices = choices_1_4, selected = 3),
      
      # --- Category 5 ---
      tags$hr(),
      h4("Action Based"),
      selectInput("c5_q1", "23. The document provides a specific solution that is based on an action or behavior.", choices = choices_1_4, selected = 3),
      selectInput("c5_q2", "24. The solution is achievable and promotes self-efficacy.", choices = choices_1_4, selected = 3),
      selectInput("c5_q3", "25. The solution does not cause potential harm, fear, and/or stress.", choices = choices_1_4, selected = 3),
      selectInput("c5_q4", "26. The solution does not require hard to obtain materials.", choices = choices_1_4, selected = 3),
      selectInput("c5_q5", "27. The solution can be quantified, evaluated, and/or assessed.", choices = choices_1_4, selected = 3),
      
      # Action button
      tags$hr(),
      actionButton("submit", "Generate Plot", class = "btn-primary btn-lg")
    ),
    mainPanel(
      width = 8,
      uiOutput("evalTitle"),
      p("The plot below shows your mean ratings for each statement, grouped by category."),
      plotOutput("scorePlot", height = "600px"),
      tags$hr(),
      h4("Category Summary"),
      p("Mean and SD are based on your ratings for each statement, grouped by category. Statements that you scored a 1 (i.e., Poor) are indicated."),
      DT::dataTableOutput("summaryTable"),
      tags$hr(),
      h4("Suggestions for Improvement (items rated Poor or Fair)"),
      uiOutput("suggestionsEmptyMsg"),         # shows a friendly message when none
      DT::dataTableOutput("suggestionsTable")  # the table itself
      
    )
  )
)

# =========================
# SERVER
# =========================
server <- function(input, output, session) {
  
  # --- helper: sanitize filenames ---
  sanitize_filename <- function(x) {
    x <- gsub("[^A-Za-z0-9._-]+", "_", x)
    x <- gsub("_+", "_", x)
    x <- sub("^_+", "", x)
    x <- sub("_+$", "", x)
    if (nchar(x) == 0) x <- "report"
    x
  }
  
  # --- Ensure a place to save reports that Shiny can serve ---
  local({
    dir.create("www", showWarnings = FALSE)
    dir.create(file.path("www", "reports"), recursive = TRUE, showWarnings = FALSE)
  })
 
  
  
  # --- load (and auto-reload) the CSV ---
  if (is.na(sugg_csv_path)) {
    stop("Cannot find 'improvement suggestions for shiny report.csv' in data/, app root, or www/.")
  }
  suggestions_tbl <- shiny::reactiveFileReader(
    intervalMillis = 5000, session = session,
    filePath = sugg_csv_path, readFunc = read_suggestions_csv
  )
  
   
  # ---------- Collect scores long-form ----------
  get_scores_long <- reactive({
    tibble(
      qnum = 1:27,
      Category = c(
        rep("Standards", 8),
        rep("Content\nDevelopment", 7),
        rep("Targeted\nMessaging", 3),
        rep("Visual Design", 4),
        rep("Action Based", 5)
      ),
      Score = as.numeric(c(
        input$c1_q1, input$c1_q2, input$c1_q3, input$c1_q4, input$c1_q5, input$c1_q6, input$c1_q7, input$c1_q8,
        input$c2_q1, input$c2_q2, input$c2_q3, input$c2_q4, input$c2_q5, input$c2_q6, input$c2_q7,
        input$c3_q1, input$c3_q2, input$c3_q3,
        input$c4_q1, input$c4_q2, input$c4_q3, input$c4_q5,
        input$c5_q1, input$c5_q2, input$c5_q3, input$c5_q4, input$c5_q5
      ))
    )
  })
  
  # ---------- Means per category (WIDE) for ggradar2 ----------
  plotData <- eventReactive(input$submit, {
    long <- get_scores_long()
    
    means_wide <- long %>%
      dplyr::group_by(Category) %>%
      dplyr::summarise(Average = mean(Score), .groups = "drop") %>%
      tidyr::pivot_wider(names_from = Category, values_from = Average)
    
    pd <- means_wide %>%
      dplyr::mutate(group = "Your Ratings") %>%
      dplyr::relocate(group)
    
    pd
  })
  
  # ---------- Radar plot ----------
  output$scorePlot <- renderPlot({
    req(plotData())
    ggradar2::ggradar2(
      plot.data              = plotData(),
      gridline.label         = c(1, 2, 3, 4),
      grid.min               = 1,
      grid.max               = 4,
      fullscore              = c(4, 4, 4, 4, 4),
      gridline.label.type    = "numeric",
      group.line.width       = 1,
      group.point.size       = 3,
      polygonfill            = TRUE,
      background.circle.colour = "white",
      axis.line.colour       = "grey55",
      gridline.min.colour    = "grey80",
      gridline.max.colour    = "grey80",
      gridline.mid.colour    = "grey",
      plot.legend            = FALSE
    )
  })
  
  # ---------- Personalized line above/below plot ----------
  
  output$evalTitle <- renderUI({
    nm <- input$doc_name
    if (is.null(nm) || trimws(nm) == "") nm <- "Example Extension Document"
    htmltools::tags$h3(
      htmltools::HTML(
        paste0('Evaluation results for <strong>', htmltools::htmlEscape(nm), '</strong>')
      ),
      style = "margin-top: 0;"  # keeps it snug at the top
    )
  })
  
  
  # ---------- Summary table ----------
  summaryData <- eventReactive(input$submit, {
    long <- get_scores_long()
    
    long %>%
      dplyr::group_by(Category) %>%
      dplyr::summarise(
        Mean = round(mean(Score), 2),
        SD   = round(sd(Score), 2),
        `Statements scored 1 (i.e., Poor)` =
          paste(qnum[Score == 1], collapse = ifelse(any(Score == 1), ", ", "")),
        .groups = "drop"
      ) %>%
      dplyr::arrange(Category)
  })
  
  output$summaryTable <- DT::renderDataTable({
    req(summaryData())
    dat <- summaryData()
    
    DT::datatable(
      dat,
      rownames = FALSE,
      options = list(
        dom = "t",
        paging = FALSE,
        ordering = FALSE,
        pageLength = nrow(dat),
        columnDefs = list(
          list(className = "dt-center", targets = "_all") # center all columns
        )
      ),
      escape = FALSE
    ) %>%
      DT::formatStyle(
        'Statements scored 1 (i.e., Poor)',
        color = DT::styleEqual(
          c("", unique(dat$`Statements scored 1 (i.e., Poor)`[dat$`Statements scored 1 (i.e., Poor)` != ""])),
          c("black", rep("red", sum(dat$`Statements scored 1 (i.e., Poor)` != "")))
        ),
        fontWeight = DT::styleEqual(
          c("", unique(dat$`Statements scored 1 (i.e., Poor)`[dat$`Statements scored 1 (i.e., Poor)` != ""])),
          c("normal", rep("bold", sum(dat$`Statements scored 1 (i.e., Poor)` != "")))
        )
      )
  })
  
  
  suggestionsData <- eventReactive(input$submit, {
    # use the CSV-backed table you already created:
    # suggestions_tbl() has columns: qnum, category, statement, suggestion
    req(suggestions_tbl)
    req(get_scores_long())
    
    get_scores_long() |>
      dplyr::select(qnum, Score) |>
      dplyr::filter(Score %in% c(1, 2)) |>
      dplyr::mutate(Rating = ifelse(Score == 1, "Poor", "Fair")) |>
      dplyr::left_join(suggestions_tbl(), by = "qnum") |>
      dplyr::arrange(qnum) |>
      dplyr::select(
        Category = category,
        `Statement#` = qnum,
        Statement = statement,
        Rating,
        Suggestion = suggestion
      )
  })
  
  
  # Message when there are no Poor/Fair items
  output$suggestionsEmptyMsg <- renderUI({
    dat <- suggestionsData()
    if (is.null(dat) || nrow(dat) == 0) {
      tags$p(
        "No suggestions to display. You did not rate any statements as Poor (1) or Fair (2).",
        class = "text-muted",
        style = "margin-top: 0.5rem;"
      )
    } else {
      NULL
    }
  })
  
  # DT table with nice defaults and wrapped text for long columns
  output$suggestionsTable <- DT::renderDataTable({
    dat <- suggestionsData()
    req(dat)  # ensures non-NULL
    
    # If empty, return an empty table with the right headers
    if (nrow(dat) == 0) {
      dat <- dat[0, , drop = FALSE]
    }
    
    DT::datatable(
      dat,
      rownames = FALSE,
      options = list(
        dom = "tip",             # table + info + pagination (no length menu)
        paging = FALSE,
        pageLength = 10,
        autoWidth = TRUE,
        columnDefs = list(
          list(className = "dt-center", targets = c(0, 1, 3)), # Category, Statement #, Rating
          list(width = "40%", targets = 2),  # Statement
          list(width = "40%", targets = 4)   # Suggestion
        )
      ),
      escape = TRUE
    ) %>%
      DT::formatStyle(
        columns = c("Statement", "Suggestion"),
        whiteSpace = "normal",
        wordWrap = "break-word",
        `text-align` = "left"
      )
  })
  
  
  # ---------- Generate HTML report when toggle == Yes ----------
  observeEvent(input$submit, {
    # Respect the toggle (switchInput returns TRUE/FALSE)
    gen_yes <- isTRUE(input$gen_report)
    if (!gen_yes) return(invisible())
    
    # Gather items to include
    name <- input$doc_name
    if (is.null(name) || trimws(name) == "") name <- "Example Extension Document"
    
    # Use existing data (ensure they exist)
    req(plotData(), summaryData())
    pd  <- isolate(plotData())
    tbl <- isolate(summaryData())
    
    # Rebuild plot (or use cached object if desired)
    p <- ggradar2::ggradar2(
      plot.data              = pd,
      gridline.label         = c(1, 2, 3, 4),
      grid.min               = 1,
      grid.max               = 4,
      fullscore              = c(4, 4, 4, 4, 4),
      gridline.label.type    = "numeric",
      group.line.width       = 1,
      group.point.size       = 3,
      polygonfill            = TRUE,
      background.circle.colour = "white",
      axis.line.colour       = "grey55",
      gridline.min.colour    = "grey80",
      gridline.max.colour    = "grey80",
      gridline.mid.colour    = "grey",
      plot.legend            = FALSE
    ) + ggplot2::coord_equal(clip = "off") +
      ggplot2::theme(
        plot.margin = ggplot2::unit(c(24, 48, 24, 48), "pt")  # extra room right/left
      )
    
    
    # Filenames
    safe_name <- sanitize_filename(name)
    stamp     <- format(Sys.time(), "%Y%m%d-%H%M%S")
    base      <- paste0("evaluation_", safe_name, "_", stamp)
    
    report_dir  <- file.path("www", "reports")
    plot_file   <- file.path(report_dir, paste0(base, "_plot.png"))
    html_file   <- file.path(report_dir, paste0(base, ".html"))
    
    # Save plot image (PNG) to the same folder as the HTML
    ggplot2::ggsave(
      filename = plot_file,
      plot     = p,
      width    = 6, height = 5, dpi = 300, bg = "white"
    )
    
    # When HTML and PNG are in the same dir, the <img> src should be the basename
    img_src <- basename(plot_file)   # e.g., "evaluation_XYZ_plot.png"
    
    # ---------- Build the summary table HTML (centered; red/bold when 'scored 1') ----------
    scored1_col <- "Statements scored 1 (i.e., Poor)"  # exact column name
    
    table_head <- htmltools::tags$thead(
      htmltools::tags$tr(
        lapply(names(tbl), function(nm) htmltools::tags$th(nm))
      )
    )
    
    table_body <- htmltools::tags$tbody(
      lapply(seq_len(nrow(tbl)), function(i) {
        htmltools::tags$tr(
          lapply(names(tbl), function(nm) {
            cell <- tbl[i, nm][[1]]
            if (is.na(cell)) cell <- ""
            if (identical(nm, scored1_col) && nzchar(trimws(cell)) && !identical(trimws(cell), "—")) {
              htmltools::tags$td(
                htmltools::tags$span(class = "poor-list", htmltools::htmlEscape(as.character(cell)))
              )
            } else {
              htmltools::tags$td(htmltools::htmlEscape(as.character(cell)))
            }
          })
        )
      })
    )
    
    summary_table <- htmltools::tags$table(
      class = "table table-sm table-striped",
      table_head, table_body
    )
    
    # ---------- Build 'Suggestions for Improvement' for items scored 1 or 2 ----------
    low_scores <- isolate(get_scores_long()) |>
      dplyr::select(qnum, Score) |>
      dplyr::filter(Score %in% c(1, 2)) |>
      dplyr::mutate(Rating = ifelse(Score == 1, "Poor", "Fair")) |>
      dplyr::left_join(suggestions_tbl(), by = "qnum") |>
      dplyr::arrange(qnum)
    
    
    suggest_table <- NULL
    if (nrow(low_scores) > 0) {
      suggest_head <- htmltools::tags$thead(
        htmltools::tags$tr(
          htmltools::tags$th("Category"),
          htmltools::tags$th("Statement #"),
          htmltools::tags$th("Statement"),
          htmltools::tags$th("Rating"),
          htmltools::tags$th("Suggestion")
        )
      )
      suggest_body <- htmltools::tags$tbody(
        lapply(seq_len(nrow(low_scores)), function(i) {
          htmltools::tags$tr(
            htmltools::tags$td(low_scores$category[i]),
            htmltools::tags$td(low_scores$qnum[i]),
            htmltools::tags$td(class = "statement-cell", htmltools::htmlEscape(low_scores$statement[i])),
            htmltools::tags$td(low_scores$Rating[i]),
            htmltools::tags$td(class = "suggest", htmltools::htmlEscape(low_scores$suggestion[i]))
          )
        })
      )
      suggest_table <- htmltools::tags$table(
        class = "table table-sm table-striped",
        suggest_head, suggest_body
      )
    }
    
    # ---------- Page content (includes suggestions section when present) ----------
    title_tag <- htmltools::tags$h2("Extension Materials Analysis – Evaluation Report")
    sub_tag   <- htmltools::tags$p(
      htmltools::HTML(
        paste0('Evaluation results for <strong>', htmltools::htmlEscape(name), '</strong>')
      )
    )
    time_tag  <- htmltools::tags$p(
      class = "text-muted",
      paste("Generated:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))
    )
    
    body_tags <- htmltools::tagList(
      title_tag, sub_tag, time_tag,
      htmltools::tags$hr(),
      
      htmltools::tags$p(
        "Statements are scored Poor (1), Fair (2), Acceptable (3), or Excellent (4).",
        style = "font-size: 0.9rem; margin-bottom: 1em;  color: #555;"
      ),
      
      htmltools::tags$img(
        src   = img_src,  # basename; same folder as HTML
        style = "max-width: 100%; width: 600px; height: auto; border: 1px solid #e9ecef;"
      ),
      htmltools::tags$hr(),
      htmltools::tags$h3("Category Summary"),
      summary_table,
      if (!is.null(suggest_table)) htmltools::tagList(
        htmltools::tags$hr(),
        htmltools::tags$h3("Suggestions for Improvement (items rated Poor or Fair)"),
        suggest_table
      ),
      htmltools::tags$hr(),
      htmltools::tags$p(
        class = "text-muted",
        "Report created automatically by the Extension Materials Analysis Tool."
      )
    )
    
    # ---- Include CSS in <head> (center cells; red/bold for 'scored 1'; left-align long text cols) ----
    page <- htmltools::tagList(
      htmltools::tags$html(
        htmltools::tags$head(
          htmltools::tags$meta(charset = "utf-8"),
          htmltools::tags$meta(name = "viewport", content = "width=device-width, initial-scale=1"),
          htmltools::tags$style(HTML("
            body { font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif;
                   margin: 1.25rem; line-height: 1.55; }
            h2, h3 { color: #001E44; }
            .text-muted { color: #6c757d; }
            table { border-collapse: collapse; width: 100%; }
            th, td { border: 1px solid #e9ecef; padding: 6px 8px; text-align: center; }
            th { background: #f8f9fa; }
            .poor-list { color: red; font-weight: 700; }           /* summary table 'scored 1' values */
            td.suggest, td.statement-cell { text-align: left; }    /* readability for long text */
          "))
        ),
        htmltools::tags$body(body_tags)
      )
    )
    
    # Save HTML in the same folder as the image
    htmltools::save_html(page, file = html_file, background = "white")
    
    # Expose link in app
    rel_html <- sub("^www/", "", html_file)  # "reports/<base>.html"
    output$lastReportLink <- renderUI({
      htmltools::tags$a(
        href   = rel_html,
        target = "_blank",
        class  = "btn btn-link p-0",
        style  = "text-transform: none;",
        htmltools::HTML(paste0("Open last report (", htmltools::htmlEscape(name), ")"))
      )
    })
    
    showNotification("Report generated.", type = "message", duration = 4)
  })
}

# Run the application
shinyApp(ui = ui, server = server)