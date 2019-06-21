bin_numeric <- function(ds, nvar) {
  nvar_v <- ds[, nvar]
  nvar_v <- nvar_v[!is.na(nvar_v)]
  nvar_q <- quantile(nvar_v, probs = seq(.1, 1, .1))
  nvar_q <- unique(c(min(nvar_v), nvar_q))
  nvar_g <- cut(nvar_v, breaks = nvar_q)
  nvar_d <- data.frame(table(nvar_g))
  names(nvar_d) <- c("Bin", "Frequency")
  nvar_d
}

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
    validate(need(data_ds_vars, message = FALSE))
    req(input$varlist_distribution)
    binned_vars[[input$varlist_distribution]] <<-
      bin_numeric(data_ds_vars$data_ds(), input$varlist_distribution)
    
    output$binned_distribution <- renderTable({
      binned_vars[[input$varlist_distribution]]
    })
  })
  
  binned_vars
  
}