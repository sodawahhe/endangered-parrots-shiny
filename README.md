# Interactive Visualisation of Endangered Australian Parrot Species

An interactive R Shiny web application analysing 39,500+ observation records of four endangered Australian parrot species spanning 2004-2024. Built for the Data Exploration and Visualisation course (FIT5147) at Monash University Malaysia. **High Distinction**.

## Problem Statement

Australia is home to several critically endangered parrot species whose populations are declining due to habitat loss, climate change and predation. This project builds an interactive dashboard to explore spatial and temporal patterns in species observations, helping researchers and conservationists understand distribution shifts and seasonal migration behaviours.

**Species analysed:**
- Swift Parrot (*Lathamus discolor*)
- - Orange-bellied Parrot (*Neophema chrysogaster*)
  - - Night Parrot (*Pezoporus occidentalis*)
    - - Superb Parrot (*Polytelis swainsonii*)
     
      - ## Data Source
     
      - - **Source**: Atlas of Living Australia (ALA) - Australia's national biodiversity database
        - - **Records**: 39,500+ verified observations
          - - **Time span**: 2004 - 2024
            - - **Fields**: Species, coordinates, observation date, geographic region, data quality indicators
             
              - ## Interactive Features
             
              - | Feature | Description |
              - |---------|-------------|
              - | Leaflet Map | Species colour-encoded markers with observation-count scaling |
              - | Hover Tooltips | Location details and observation metadata on hover |
              - | Multi-select Filter | Filter by one or more species simultaneously |
              - | Seasonal Controls | Radio buttons to explore observations by season |
              - | ggplot2 Charts | Seasonal distribution analysis with migration pattern visualisation |
             
              - ## Key Findings
             
              - 1. **Swift Parrot migration pattern**: Seasonal analysis revealed the Swift Parrot migrates from Tasmanian breeding grounds to mainland coastal regions (Victoria, NSW) during autumn and winter - a finding consistent with ecological literature but made visually intuitive through the dashboard
                2. 2. **Spatial clustering**: Observations of the Orange-bellied Parrot are heavily concentrated in a narrow coastal corridor, highlighting the species' extremely restricted range
                   3. 3. **Temporal trends**: Observation frequency varies significantly by season and species, with implications for survey timing and conservation resource allocation
                     
                      4. ## Tech Stack
                     
                      5. | Tool | Purpose |
                      6. |------|---------|
                      7. | R Shiny | Interactive web application framework |
                      8. | Leaflet | Interactive map with markers, tooltips and filters |
                      9. | ggplot2 | Statistical visualisation and seasonal analysis |
                      10. | dplyr | Data manipulation and pipeline construction |
                      11. | R | Data cleaning, transformation and analysis |
                     
                      12. ## Data Cleaning Pipeline
                     
                      13. The raw ALA dataset required substantial preprocessing:
                      14. - Resolved missing latitude/longitude coordinates via spatial lookup
                          - - Removed invalid dates and standardised date formats
                            - - Handled null geographic fields and inconsistent region names
                              - - Standardised species naming conventions across data sources
                               
                                - ## Project Structure
                               
                                - ```
                                  endangered-parrots-shiny/
                                  |-- README.md
                                  |-- app.R                 # Main Shiny application
                                  |-- data_cleaning.R       # Data preprocessing pipeline
                                  |-- data/                 # Cleaned dataset
                                  |-- screenshots/          # App screenshots for portfolio
                                  ```

                                  ## About This Project

                                  This was an individual project for FIT5147 Data Exploration and Visualisation at Monash University Malaysia (Apr-May 2026). The project received a **High Distinction** grade.

                                  **Author**: Xiaowei Xu | Master of Data Science, Monash University Malaysia

                                  > Note: App screenshots and R source code will be uploaded shortly. Deployment to shinyapps.io is planned so the dashboard can be viewed live.
