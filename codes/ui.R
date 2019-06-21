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
      helpText("Distribution")
    )
  )
)