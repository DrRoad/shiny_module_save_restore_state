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

distribution_server <- function(input, output, session, data_ds_vars,
                                restored_data_vars, restored_deciles) {
  
  # Global reactive values to store deciles
  deciles_g <- reactiveValues()
  
  # Numeric variables
  numeric_vars <- reactive({
    validate(need(data_ds_vars, message = FALSE))
    if (!is.null(restored_data_vars())) {
      vnames <- restored_data_vars()$vnames
    } else {
      data_vars <- data_ds_vars$data_vars()
      data_vars <- data_vars[data_vars$vtypes == "numeric" |
                               data_vars$vtypes == "integer", ]
      vnames <- data_vars$vnames
    }
    vnames
  })
  
  # Update choice of variables for which deciles can be created
  observe({
    updateSelectInput(session, "varlist_distribution", "Select variable",
                      choices = numeric_vars())
  })
  
  # If the list of variables change, reset everything to NULL
  observeEvent(numeric_vars(), {
    for (name in names(deciles_g)) {
      deciles_g[[name]] <<- NULL
    }
  }, priority = 10)
  
  # Calculate deciles whenever a new variable selection is made and display
  observeEvent(input$varlist_distribution, {
    validate(need(data_ds_vars, message = FALSE))
    req(input$varlist_distribution)
    if (is.null(deciles_g[[input$varlist_distribution]])) {
      deciles_g[[input$varlist_distribution]] <<-
        bin_numeric(data_ds_vars$data_ds(), input$varlist_distribution)
    }
    
    output$binned_distribution <- renderTable({
      deciles_g[[input$varlist_distribution]]
    })
  })
  
  # Store deciles as a list
  deciles <- reactive({
    Filter(Negate(is.null), reactiveValuesToList(deciles_g))
  })
  
  # Return
  deciles
  
}