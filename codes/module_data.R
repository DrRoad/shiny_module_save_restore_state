data_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fileInput(ns("in_data"), "Upload data", accept = "text/csv",
              placeholder = "CSV file"),
    tableOutput(ns("out_data"))
  )
}

data_server <- function(input, output, session) {
  data_file <- reactive({
    validate(need(input$in_data, message = FALSE))
    input$in_data
  })
  
  data_ds <- reactive({
    ds <- read_csv(data_file()$datapath, guess_max = 50000)
    as.data.frame(ds)
  })
  
  data_vars <- reactive({
    ds <- data_ds()
    vnames <- gsub("\\.", "_", make.names(colnames(ds), unique = TRUE))
    vtypes <- vapply(ds, class, character(1))
    data.frame(vnames = vnames, vtypes = vtypes, stringsAsFactors = FALSE)
  })
  
  output$out_data <- renderTable({
    data_vars()
  })
  
  list(
    data_ds = data_ds,
    data_vars = data_vars
  )
}