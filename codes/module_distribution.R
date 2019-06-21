distribution_ui <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("varlist_distribution"), "Select variable", choices = NULL),
    tableOutput(ns("binned_distribution"))
  )
}

distribution_server <- function(input, output, session, data_ds_vars) {
  
  binned_vars <- list()
  
  numeric_vars <- reactive({
    validate(need(data_ds_vars, message = FALSE))
    data_vars <- data_ds_vars$data_vars()
    data_vars <- data_vars[data_vars$vtypes == "numeric" |
                             data_vars$vtypes == "integer", ]
    data_vars$vnames
  })
  
  observe({
    updateSelectInput(session, "varlist_distribution", "Select variable",
                      choices = numeric_vars())
  })
  
  observeEvent(numeric_vars(), {
    for (name in names(binned_vars)) {
      binned_vars[name] <<- NULL
    }
  }, priority = 10)
  
  observeEvent(input$varlist_distribution, {
    req(input$varlist_distribution)
  })
  
  binned_vars
  
}