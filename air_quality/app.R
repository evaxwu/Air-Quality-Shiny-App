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
# by county
air_quality_summary_county <- air_quality %>%
  group_by(year, state, county, fips, pollutant, units_of_measure) %>%
  summarize(air_qual_year = mean(arithmetic_mean, na.rm = TRUE)) %>%
  unique()

#by state
air_quality_summary_state <- air_quality %>%
  group_by(year, state, pollutant, units_of_measure) %>%
  summarize(air_qual_year = mean(arithmetic_mean, na.rm = TRUE)) %>%
  unique()

# import sf for the county-level map
counties_sf <- get_urbn_map(map = "counties", sf = TRUE)
# only if plotting state-level map:
states_sf <- get_urbn_map(map = "states", sf = TRUE)

# empty map of california
CA.SF <- counties_sf %>% filter(state_name=="California"|
                                  state_name=="Arizona"|
                                  state_name=="Idaho"|
                                  state_name=="Colorado"|
                                  state_name=="Montana"|
                                  state_name=="Nevada"|
                                  state_name=="New Mexico"|
                                  state_name=="Oregona"|
                                  state_name=="Utah"|
                                  state_name=="Washington"|
                                  state_name=="Wyoming")

ggplot(data = CA.SF) +
  geom_sf()

counties_air <- left_join(counties_sf, air_quality_summary_county,
                          by = c("county_fips" = "fips")) %>% unique()



# merge air_quality data and sf using fips code
counties_air <- left_join(counties_sf, air_quality_summary_county,
                           by = c("county_fips" = "fips")) %>%
  unique()
# maybe can change this to fill counties with no values grey rather than blank

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
        selected = "PM2.5" # placeholder pollutant
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
            value = 2010, # placeholder year
            animate = TRUE, # add animation button beside slider
            sep = "" # remove the comma separating thousands
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
          "measured by ", rlang::as_name(input$pollutant))
  })

  output$map <- renderPlot({

    unit <- air_quality_summary_county %>%
      filter(pollutant == input$pollutant) %>%
      ungroup() %>%
      select(units_of_measure) %>%
      unique()

    counties_air %>%
      filter(year == input$year & pollutant == input$pollutant) %>%
      unique() %>%
      ggplot() +
      geom_sf(data = CA.SF) +
      geom_sf(mapping = aes(fill = air_qual_year), color = NA) +
      coord_sf(datum = NA) +
      scale_fill_gradient(name = paste0("Pollution level \n(", unit, ")"),
                          low = "pink", high = "navyblue",
                          na.value = "grey") +
      # grey doesn't show up for some reason
      theme_void() +
      theme(plot.title = element_text(paste0("Map showing county-level
                                             air quality measured by ",
                                             rlang::as_name(input$pollutant))),
            legend.position = "bottom")

  })

  # [tab 2: the line graph]===================

  output$state_text <- reactive({
    paste0("You've selected ", length(input$state), " state(s). Showing their air
          quality measured by ", rlang::as_name(input$pollutant), " across years...")
  })

  output$state_plot <- renderPlot({

    # verify only 8 or fewer states selected for optimal interpretation
    validate(
      need(
        expr = length(input$state) <= 8,
        message = "Please do not select more than 8 states."
      )
    )

    unit <- air_quality_summary_state %>%
      filter(pollutant == input$pollutant) %>%
      ungroup() %>%
      select(units_of_measure) %>%
      unique()

    air_quality_summary_state %>%
      filter(state %in% input$state & pollutant == input$pollutant) %>%
      ggplot(aes(year, air_qual_year, color = state)) +
      geom_line() +
      theme_light() +
      labs(title = paste0("Air Quality Across Years in ", paste(input$state, collapse = ",")),
           subtitle = paste0("measured by ", rlang::as_name(input$pollutant)),
           x = "Year", y = paste0("Polution level (", unit, ")"),
           color = "State")

  })

  # [tab 3: the table]==========================

  output$data <- DT::renderDataTable({
    air_quality_summary_county %>%
      mutate(unit = units_of_measure,
             `pollution level` = air_qual_year,
             .keep = "unused") %>%
      arrange(year, state, fips, pollutant)
  })

}

# Create the Shiny app object ---------------------------------------
thematic_shiny()
shinyApp(ui = ui, server = server)
