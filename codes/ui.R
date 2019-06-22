ui <- shinyUI(
  navbarPage(
    "Data Distribution",
    id = "nav_top",
    tabPanel(
      "Data",
      data_ui("data_module")
    ),
    tabPanel(
      "Distribution",
      distribution_ui("distribution_module")
    ),
    tabPanel(
      "Save/Restore",
      downloadButton("save_state", "Save to file"),
      br(),
      fileInput("restore_state", "Restore from file",
                placeholder = ".rds file")
    )
  )
)