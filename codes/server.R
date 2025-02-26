server <- function(input, output, session) {
  
  restored_ds <- reactiveVal()
  restored_decile <- reactiveVal()
  
  # Call modules
  data_ds_vars <- callModule(data_server, "data_module", restored_ds)
  distributions <- callModule(distribution_server, "distribution_module",
                              data_ds_vars, restored_decile)
  
  # Save state
  output$save_state <- downloadHandler(
    filename = function() {
      paste0("dd-", Sys.Date(), ".rds")
    },
    content = function(file) {
      data_ds <- isolate(data_ds_vars$data_ds())
      data_vars <- isolate(data_ds_vars$data_vars())
      deciles <- isolate(distributions())
      save_list <- list(
        data_ds = data_ds,
        data_vars = data_vars,
        deciles = deciles
      )
      saveRDS(save_list, file)
    } 
  )
  
  # Reactive restore file
  restore_file <- reactive({
    validate(need(input$restore_state, message = FALSE))
    input$restore_state
  })
  
  # Reactive to store restored information
  restored_state <- reactive({
    rs <- readRDS(restore_file()$datapath)
    rs
  })
  
  # Restore state
  observeEvent(restored_state(), {
    rs <- restored_state()
    restored_ds(rs$data_ds)
    restored_decile(rs$deciles)
  })

}