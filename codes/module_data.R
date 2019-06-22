data_ui <- function(id) {
  
  ns <- NS(id)
  tagList(
    fileInput(ns("in_data"), "Upload data", accept = "text/csv",
              placeholder = "CSV file"),
    tableOutput(ns("out_data"))
  )
  
}

data_server <- function(input, output, session, restored_ds) {
  
  # Reactive uploaded file
  data_file <- reactive({
    validate(need(input$in_data, message = FALSE))
    input$in_data
  })
  
  # Reactive to store data if uploaded or restored
  data_ds <- reactive({
    if (!is.null(restored_ds())) {
      ds <- restored_ds()
    } else {
      ds <- read_csv(data_file()$datapath, guess_max = 50000)
      ds <- as.data.frame(ds)
    }
    ds
  })
  
  # Name and data types of variables for uploaded or restored data
  data_vars <- reactive({
    ds <- data_ds()
    vnames <- gsub("\\.", "_", make.names(colnames(ds), unique = TRUE))
    vtypes <- vapply(ds, class, character(1))
    data.frame(vnames = vnames, vtypes = vtypes, stringsAsFactors = FALSE)
  })
  
  # Display name and data types
  output$out_data <- renderTable({
    data_vars()
  })
  
  # Return
  list(
    data_ds = data_ds,
    data_vars = data_vars
  )
  
}