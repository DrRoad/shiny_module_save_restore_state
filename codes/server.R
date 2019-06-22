server <- function(input, output, session) {
  data_ds_vars <- callModule(data_server, "data_module")
  distributions <- callModule(distribution_server, "distribution_module",
                              data_ds_vars)
  
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
}