library(shiny)
library(tidyverse)
library(shinythemes)
library(thematic)

# Load data --------------------------------------------------------------------
air_quality <- read_csv("data/CA1_avg.csv", show_col_types = FALSE)

pollutant_choices <- c("PM2.5", "Acceptable PM2.5 AQI & Speciation Mass", "PM10", 
                       "CO", "Ozone", "NO2", "SO2")

# Define UI --------------------------------------------------------------------
ui <- fluidPage(
  theme = shinytheme("united"),
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
            selected = "California",
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
    paste("You've selected ", length(input$state), " state(s). Showing their air 
          quality measured by ", input$pollutant, "across years...")
  })
 
  output$map <- renderPlot({
        
  })
  
  state_filtered <- reactive({
    
    air_quality %>%
      filter(state %in% input$state) %>%
      select(year, quarter, state, year_qtr, input$pollutant) %>%
      unique() %>%
      group_by(year, state) %>%
      summarize(air_qual_year = mean(PM2.5, na.rm = TRUE)) # need to make PM2.5 reproducible
    
  })
  
  output$state_plot <- renderPlot({
    
    # verify only 8 or fewer states selected for optimal interpretation
    validate(
      need(
        expr = length(input$state) <= 8,
        message = "Please do not select more than 8 states."
      )
    )
    
    state_filtered() %>%
      ggplot(aes(year, air_qual_year, color = state)) +
      geom_line() +
      theme_light() +
      labs(title = paste("Air Quality Across Years"),
           subtitle = paste("measured by PM2.5"),
           x = "Year", y = "Air Quality", color = "State")
    
  })
    
  output$data <- DT::renderDataTable({
    state_filtered()
  })
  
}

# Create the Shiny app object ---------------------------------------
thematic_shiny()
shinyApp(ui = ui, server = server)
