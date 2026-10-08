# Seasonal Distribution of Australian Parrot Observations

An interactive R Shiny dashboard exploring 39,486 observation records of four Australian parrot and lorikeet species from 2004 to 2024, with a Leaflet map and a seasonal comparison chart. Built for *Data Exploration and Visualisation* (FIT5147) at Monash University Malaysia, Apr-May 2026.

## Question

How do observations of each species vary by season and by location, and do the records show the seasonal movement that ecological literature describes for migratory species?

## Data

[Atlas of Living Australia](https://www.ala.org.au) occurrence records supplied for the course (retrieved 24 March 2026, CC BY 4.0), included in `data/`.

| Species | Records |
|---|---|
| Swift Parrot | 13,805 |
| Little Lorikeet | 12,801 |
| Purple-crowned Lorikeet | 12,646 |
| Orange-bellied Parrot | 234 |

Fields used: observation date, state, latitude, longitude, common name. The supplied extract had no missing dates or coordinates and one blank state; the app still drops any row with a missing date or coordinate and labels blank states "Unknown".

## Dashboard

- **Seasonal chart:** grouped bars of each species' share of observations in Australian summer, autumn, winter and spring.
- **Map:** one circle per rounded location, coloured by species, with radius scaled to the number of observations there and a hover tooltip showing species, count and state.
- **Filters:** species checkboxes and a season selector update the map together.

## Findings

1. **Swift Parrot movement between Tasmania and the mainland.** Tasmania accounts for 94% of its summer records and 76% of its spring records, while 97-98% of its autumn and winter records come from mainland states.
2. **Orange-bellied Parrot is rare and autumn-heavy.** Only 234 records (0.6% of the data), 47% of them in autumn, mostly from Tasmania (144) and Victoria (71).
3. **The two lorikeet species are recorded across all seasons**, peaking in spring (31%) and lowest in summer (18-21%).

## Run Locally

Install the packages once, then start the app from the repository root:

```r
install.packages(c("shiny", "leaflet", "dplyr", "ggplot2", "scales"))
shiny::runApp()
```

## Repository Contents

```
app.R                          Shiny application (UI, server, data preparation)
data/ALA_PE2S12026.csv         observation records
```

## Tech Stack

R, Shiny, Leaflet, ggplot2, dplyr

## Author

Xiaowei Xu | Master of Data Science, Monash University Malaysia
