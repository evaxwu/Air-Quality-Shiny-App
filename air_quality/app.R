library(shiny)
library(tidyverse)
library(shinythemes)
library(thematic)
library(urbnmapr)

# Load data --------------------------------------------------------------------
air_quality <- read_csv("data/CA_overall2.csv", show_col_types = FALSE) %>%
  select(year, state, state_code, county, county_code, latitude, longitude, pollutant, 
         arithmetic_mean, units_of_measure) %>%
  mutate(fips = paste0(state_code, county_code)) %>% # add fips code
  arrange(year, state, county, pollutant) %>%
  distinct()

pollutant_choices <- air_quality$pollutant %>% unique()

# summarize air quality
air_quality_summary <- air_quality %>%
  group_by(year, state, pollutant, units_of_measure) %>%
  summarize(air_qual_year = mean(arithmetic_mean, na.rm = TRUE))

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
          br(),
          plotOutput("state_plot")
          ), 
        tabPanel("Data", DT::dataTableOutput(outputId = "data"))
      )
    )
  )
)

# Define server function --------------------------------------------
server <- function(input, output) {

  # [tab 1: the map] ========================
  
  output$map_text <- reactive({
    paste("This map shows the air quality across the U.S. in", input$year, 
          "measured by ", input$pollutant)
  })
  
  year_filtered <- reactive({
    
    air_quality %>%
      filter(year == input$year & pollutant == input$pollutant) %>%
      unique()
    
  })
  
  output$map <- renderPlot({
    
    counties_sf <- get_urbn_map(map = "counties", sf = TRUE)
    states_sf <- get_urbn_map(map = "states", sf = TRUE)
    
    # merge using fips
    counties_air <- inner_join(counties_sf, year_filtered(), 
                               by=c("county_fips"="fips"), copy = TRUE) %>%
      # wrangle to get mean value for multiple values in a county
      group_by(county_fips, .drop = FALSE) %>%
      summarise(avg = mean(input$pollutant))
    
    counties_air %>%
      ggplot() +
      geom_sf(mapping = aes(fill = avg), color = NA) +
      coord_sf(datum = NA) +   
      scale_fill_gradient(name = "Pollutants", low='pink', high='navyblue', 
                          na.value="white") +
      theme_bw() + theme(legend.position="bottom", panel.border = element_blank())
    
  })
  
  # [tab 2: the line graph]=================== 
  
  output$state_text <- reactive({
    paste("You've selected ", length(input$state), " state(s). Showing their air 
          quality measured by ", input$pollutant, "across years...")
  })
  
  output$state_plot <- renderPlot({
    
    # verify only 8 or fewer states selected for optimal interpretation
    validate(
      need(
        expr = length(input$state) <= 8,
        message = "Please do not select more than 8 states."
      )
    )
    
    air_quality_summary %>%
      filter(state %in% input$state & pollutant == input$pollutant) %>%
      ggplot(aes(year, air_qual_year, color = state)) +
      geom_line() +
      theme_light() +
      labs(title = paste("Air Quality Across Years in ", paste(input$state, collapse = ",")),
           subtitle = paste("measured by ", rlang::as_name(input$pollutant)),
           x = "Year", y = paste("Air Quality ()"), 
           color = "State")
    
  })
  
  # [tab 3: the table]==========================
  
  output$data <- DT::renderDataTable({
    air_quality
  })
  
}

# Create the Shiny app object ---------------------------------------
thematic_shiny()
shinyApp(ui = ui, server = server)
