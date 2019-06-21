# Modules
source("codes/libs.R")
source("codes/module_data.R")
source("codes/module_distribution.R")
source("codes/server.R")
source("codes/ui.R")

# Run app
shinyApp(ui, server)
