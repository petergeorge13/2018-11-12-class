library(shiny)
library(tidyverse)

build_file <- function(x){
  x <- str_trim(x)
  q <- str_split(x, "-")[[1]]
  paste("../data/data/elections-poll-", tolower(q[1]), q[2], "-", q[3], ".csv", sep = "")
}

build_file_http <- function(x, y){
  x <- str_trim(x)
  y <- str_trim(y)
  q1 <- str_split(x, "-")[[1]]
  q2 <- str_split(y, "-")[[1]]
  paste("https://raw.githubusercontent.com/TheUpshot/2018-live-poll-results/master/data/elections-poll-", tolower(q1[1]), q1[2], "-", q2[1], ".csv", sep = "")
}

# Define UI for data upload app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Show Files"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select a file ----
      textInput("file1", "Location", "CA-49"),
      textInput("file2", "District", "1")
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Data file ----
      tableOutput("contents")
    )
    
  )
)

# Define server logic to read selected file ----
server <- function(input, output) {
  
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$file1)
    
    df <- read.csv(build_file_http(input$file1, input$file2))
    
    return(df)
  })
  
}

# Create Shiny app ----
shinyApp(ui, server)
