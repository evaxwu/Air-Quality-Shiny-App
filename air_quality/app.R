library(shiny)
library(tidyverse)
library(shinythemes)
library(thematic)

# Load data --------------------------------------------------------------------
# df <- read_csv("data/air_quality.csv", show_col_types = FALSE)

pollutant_choices <- c("PM2.5", "PM2.5 - Local Conditions", 
                       "PM10 Total 0-10um STP", "Carbon monoxide (CO)", 
                       "Ozone (O3)", "Sulfur dioxide (SO2)", "Nitrogen dioxide (NO2)")

# Define UI --------------------------------------------------------------------
ui <- fluidPage(
  theme = shinytheme("yeti"),
  titlePanel("Air Quality of U.S. Counties in 1971-2021"),
  "A Shiny app built by Caleb Weis, Eva Wu, and Jimin Han",
  br(), br(),
  sidebarLayout(
    sidebarPanel(
      radioButtons(
        inputId = "pollutant",
        label = "Select a pollutant by which air quality is measured:", 
        choices = pollutant_choices,
        selected = "PM2.5"
      )
    ),
    mainPanel(
      hr(),
      "Hi hi! Interested in checking out air quality trends in the US? 
      Hope the following graphs help!",
      br(), br(),
      tabsetPanel(
        tabPanel(
          "Nationwide", 
          br(),
          sliderInput(
            inputId = "year",
            label = "Select a year:",
            min = 1971,
            max = 2021,
            value = 2010 # placeholder year
          ),
          textOutput(outputId = "map_text"),
          plotOutput("map")
        ), 
        tabPanel(
          "State",
          br(),
          selectInput(
            inputId = "state", 
            label = "Select up to 8 states:", 
            choices = state.name,
            selected = "Illinois",
            multiple = TRUE
          ),
          textOutput(outputId = "state_text"),
          plotOutput("state_plot")
          ), 
        tabPanel("Data", DT::dataTableOutput(outputId = "data"))
      )
    )
  )
)

# Define server function --------------------------------------------
server <- function(input, output) {

  output$map_text <- reactive({
    paste("This map shows the air quality across the U.S. in ", input$year, 
          "measured by ", input$pollutant)
  })
  
  output$state_text <- reactive({
    paste("You've selected ", length(input$state), " states. Showing their air 
          quality measured by ", input$pollutant, "across years...")
  })
 
  output$map <- renderPlot({
        
  })
    
  output$state_plot <- renderPlot({
    
    # verify only 8 or fewer states selected for optimal interpretation
    validate(
      need(
        expr = length(input$state) <= 8,
        message = "Please do not select more than 8 states."
      )
    )
    
  })
    
  output$data <- DT::renderDataTable({
      
  })
  
}

# Create the Shiny app object ---------------------------------------
thematic_shiny()
shinyApp(ui = ui, server = server)
