server <- function(input, output, session) {
  data_ds_vars <- callModule(data_server, "data_module")
  distributions <- callModule(distribution_server, "distribution_module",
                              data_ds_vars)
}