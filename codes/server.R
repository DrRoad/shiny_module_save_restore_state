server <- function(input, output, session) {
  data_vars <- callModule(data_server, "data_module")
}