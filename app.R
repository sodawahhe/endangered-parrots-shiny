# FIT5147 PE2 - R Shiny Application
# Author: Xiaowei Xu | Monash University Malaysia

library(shiny)
library(ggplot2)
library(leaflet)
library(dplyr)

# Load data
bird_data <- read.csv("data/ALA_PE2S12026.csv", stringsAsFactors = FALSE)

# Parse dates and extract month/year
bird_data$observationDate <- as.Date(bird_data$observationDate)
bird_data$month <- as.integer(format(bird_data$observationDate, "%m"))
bird_data$year <- as.integer(format(bird_data$observationDate, "%Y"))

# Remove rows with missing dates or coordinates
bird_data <- bird_data[!is.na(bird_data$month), ]
bird_data <- bird_data[!is.na(bird_data$decimalLatitude) & !is.na(bird_data$decimalLongitude), ]

# Assign Australian seasons
bird_data$season <- dplyr::case_when(
  bird_data$month %in% c(12, 1, 2) ~ "Summer",
  bird_data$month %in% c(3, 4, 5)  ~ "Autumn",
  bird_data$month %in% c(6, 7, 8)  ~ "Winter",
  bird_data$month %in% c(9, 10, 11) ~ "Spring"
)

bird_data$species <- bird_data$vernacularName
bird_data$stateProvince[bird_data$stateProvince == ""] <- "Unknown"

# Round coordinates to reduce overplotting on the map
bird_data$lat_round <- round(bird_data$decimalLatitude, 2)
bird_data$lon_round <- round(bird_data$decimalLongitude, 2)

species_list <- sort(unique(bird_data$species))

# Species colour palette (as list to avoid jsonlite warning)
sp_colours <- list(
  "Little Lorikeet"           = "#E69F00",
  "Orange-bellied Parrot"     = "#D55E00",
  "Purple-crowned Lorikeet"   = "#CC79A7",
  "Swift Parrot"              = "#009E73"
)

# ---- UI ----
ui <- fixedPage(

  tags$head(
    tags$style(HTML("
      body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; background-color: #fafafa; }
      .main-title { text-align: center; font-size: 22px; font-weight: bold; color: #2c3e50;
                     padding: 18px 0 8px 0; border-bottom: 2px solid #2c3e50; margin-bottom: 15px; }
      .section-box { background: #fff; border: 1px solid #ddd; border-radius: 4px;
                      padding: 14px; margin-bottom: 12px; }
      .desc-text { font-size: 13px; line-height: 1.55; color: #333; }
      .desc-title { font-weight: bold; font-size: 14px; margin-bottom: 6px; color: #2c3e50; }
      .data-source { font-size: 11px; color: #666; border-top: 1px solid #ddd;
                      padding-top: 8px; margin-top: 10px; }
      .filter-panel { background: #f5f5f5; border: 1px solid #ddd; border-radius: 4px;
                       padding: 10px; margin-bottom: 8px; }
    "))
  ),

  # Title
  div(class = "main-title",
      "Seasonal Distribution of Australian Parrot Observations (2004\u20132024)"),

  # VIS 1 row: chart left, description right
  fixedRow(
    column(7,
      div(class = "section-box",
          plotOutput("vis1_plot", height = "380px"))
    ),
    column(5,
      div(class = "section-box",
          div(class = "desc-title", "VIS 1: Seasonal Observation Proportions"),
          div(class = "desc-text",
              "This grouped bar chart shows the proportion of observations in each
               Australian season (Summer: Dec\u2013Feb, Autumn: Mar\u2013May,
               Winter: Jun\u2013Aug, Spring: Sep\u2013Nov) for the four parrot species.
               Bar height represents seasonal proportion, and colour hue distinguishes
               the four seasons. The Swift Parrot is recorded at similar levels in spring, autumn
               and winter but rarely in summer (9.9%), consistent with its seasonal
               movement between Tasmania and the mainland. The Little Lorikeet
               and Purple-crowned Lorikeet show relatively even distributions across seasons,
               suggesting year-round residency. The Orange-bellied Parrot is most observed
               in autumn, consistent with its migration to mainland coastal areas."))
    )
  ),

  # MAP row with filters
  fixedRow(
    column(12,
      div(class = "section-box",
          fixedRow(
            column(5,
              div(class = "filter-panel",
                  tags$strong("Filter by Species:"),
                  checkboxGroupInput("species_filter", label = NULL,
                    choices = species_list, selected = species_list, inline = TRUE))
            ),
            column(7,
              div(class = "filter-panel",
                  tags$strong("Filter by Season:"),
                  radioButtons("season_filter", label = NULL,
                    choices = c("All Year", "Summer", "Autumn", "Winter", "Spring"),
                    selected = "All Year", inline = TRUE))
            )
          ),
          leafletOutput("map_plot", height = "480px"))
    )
  ),

  # MAP description
  fixedRow(
    column(12,
      div(class = "section-box",
          div(class = "desc-title", "MAP: Geographic Distribution of Parrot Observations"),
          div(class = "desc-text",
              "This interactive map shows each observation location as a circle marker.
               Colour represents the species and radius reflects the number of observations
               at that location. Use the checkboxes to filter by species and the radio
               buttons to filter by season. Hover over a marker for details. The map
               highlights clear migration patterns: the Swift Parrot clusters in
               Tasmania during spring (breeding) and shifts to Victoria and NSW in
               autumn and winter. The Orange-bellied Parrot appears only along a narrow
               coastal strip in Tasmania, Victoria and South Australia. The two lorikeet species
               are more widely spread across eastern and southern Australia year-round."))
    )
  ),

  # Data source info
  fixedRow(
    column(12,
      div(class = "data-source",
          tags$strong("Data Source: "),
          "Atlas of Living Australia (ALA). ",
          tags$em("ALA_PE2S12026.csv"), ". ",
          "Retrieved 24 March 2026 from ",
          tags$a(href = "https://www.ala.org.au", "https://www.ala.org.au",
                 target = "_blank"), ". ",
          "Licensed under ",
          tags$a(href = "https://creativecommons.org/licenses/by/4.0/",
                 "CC BY 4.0", target = "_blank"), "."))
  ),

  div(style = "height: 20px;")
)

# ---- Server ----
server <- function(input, output, session) {

  # VIS 1: static grouped bar chart
  output$vis1_plot <- renderPlot({

    season_props <- bird_data %>%
      group_by(species, season) %>%
      summarise(count = n(), .groups = "drop") %>%
      group_by(species) %>%
      mutate(proportion = count / sum(count)) %>%
      ungroup()

    season_props$season <- factor(season_props$season,
      levels = c("Summer", "Autumn", "Winter", "Spring"))

    season_cols <- c("Summer" = "#E63946", "Autumn" = "#F4A261",
                     "Winter" = "#457B9D", "Spring" = "#2A9D8F")

    y_max <- max(season_props$proportion, na.rm = TRUE) * 1.15

    ggplot(season_props, aes(x = species, y = proportion, fill = season)) +
      geom_bar(stat = "identity", position = position_dodge(width = 0.8),
               width = 0.7, colour = "white", linewidth = 0.3) +
      geom_text(aes(label = paste0(round(proportion * 100, 1), "%")),
                position = position_dodge(width = 0.8),
                vjust = -0.5, size = 2.8, colour = "#333333") +
      scale_fill_manual(values = season_cols, name = "Season") +
      scale_y_continuous(labels = scales::percent_format(),
                         limits = c(0, y_max), expand = c(0, 0)) +
      labs(title = "Proportion of Observations by Season for Each Species",
           x = NULL, y = "Proportion of Observations") +
      theme_minimal(base_size = 13) +
      theme(
        plot.title = element_text(face = "bold", size = 14, hjust = 0.5, colour = "#2c3e50"),
        axis.text.x = element_text(size = 10, angle = 15, hjust = 0.8),
        legend.position = "top",
        legend.title = element_text(face = "bold"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank(),
        plot.margin = margin(10, 15, 10, 10))
  }, res = 110)

  # MAP: filter and aggregate data reactively
  map_data <- reactive({
    filtered <- bird_data

    if (length(input$species_filter) > 0) {
      filtered <- filtered %>% filter(species %in% input$species_filter)
    } else {
      return(data.frame())
    }

    if (input$season_filter != "All Year") {
      filtered <- filtered %>% filter(season == input$season_filter)
    }

    filtered %>%
      group_by(lat_round, lon_round, species, stateProvince) %>%
      summarise(obs_count = n(), .groups = "drop")
  })

  # Render base map once
  output$map_plot <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      setView(lng = 133.9453, lat = -30.4486, zoom = 4) %>%
      addLegend(position = "bottomright",
        colors = c("#E69F00", "#D55E00", "#CC79A7", "#009E73"),
        labels = c("Little Lorikeet", "Orange-bellied Parrot",
                    "Purple-crowned Lorikeet", "Swift Parrot"),
        title = "Species", opacity = 0.8)
  })

  # Update circle markers when filters change
  observe({
    df <- map_data()
    proxy <- leafletProxy("map_plot") %>% clearMarkers()

    if (is.data.frame(df) && nrow(df) > 0) {
      df$radius <- pmin(pmax(sqrt(df$obs_count) * 1.8, 3), 15)
      df$colour <- as.character(sp_colours[df$species])

      df$tooltip <- paste0(
        "<b>", df$species, "</b><br>",
        "Observations: ", df$obs_count, "<br>",
        "State: ", df$stateProvince)

      proxy %>%
        addCircleMarkers(
          data = df, lng = ~lon_round, lat = ~lat_round,
          radius = ~radius, color = ~colour, fillColor = ~colour,
          fillOpacity = 0.6, stroke = TRUE, weight = 0.8, opacity = 0.8,
          label = lapply(df$tooltip, HTML))
    }
  })
}

shinyApp(ui = ui, server = server)
