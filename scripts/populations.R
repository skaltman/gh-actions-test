# Download population data from the U.S. Census Bureau

# Author: Sara Altman, Bill Behrman
# Version: 2020-03-30

# Libraries
library(tidyverse)

# Parameters
  # Base request for 2019 Population Estimates API
request <- 
  "https://api.census.gov/data/2019/pep/population?get=NAME,POP,DATE_CODE,DATE_DESC&for="
  # US population request
request_us <- str_glue("{request}us")
  # State population request
request_states <- str_glue("{request}state:*")
  # California counties population request
request_ca_counties <- str_glue("{request}county:*&in=state:06")
  # Year of population estimates
YEAR <- 2019
  # Output file path
file_out <- here::here("data/populations.csv")

#===============================================================================

get_population <- function(request, year) {
  request %>% 
    jsonlite::fromJSON() %>%
    as_tibble() %>%
    janitor::row_to_names(row_number = 1) %>%
    filter(str_detect(DATE_DESC, str_glue("^7/1/{year}"))) %>%
    mutate(POP = as.integer(POP))
}

us <- 
  request_us %>% 
  get_population(YEAR) %>% 
  transmute(
    region = NAME,
    fips = 0L,
    population = POP
  )

states <-
  request_states %>% 
  get_population(YEAR) %>% 
  transmute(
    region = NAME,
    fips = state %>% as.integer(),
    population = POP
  )
  
ca_counties <-
  request_ca_counties %>% 
  get_population(YEAR) %>% 
  transmute(
    region = str_remove(NAME, ",.*"),
    fips = str_glue("{state}{county}") %>% as.integer(),
    population = POP
  )

us %>% 
  bind_rows(states, ca_counties) %>% 
  write_csv(file_out)
