# Download New York Times state COVID-19 data

# Source: https://github.com/nytimes/covid-19-data/blob/master/us-states.csv

# Author: Bill Behrman
# Version: 2020-03-30

# Libraries
library(tidyverse)
library(vroom)

# Parameters
  # URL for source data
url <- 
  "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv"
  # Download location
file_out <- here::here("data/nytimes_states.rds")

#===============================================================================

# url %>% 
#   vroom(
#     col_types = 
#       cols(
#         date = col_date(format = ""),
#         state = col_character(),
#         fips = col_integer(),
#         cases = col_double(),
#         deaths = col_double()
#       )
#   ) %>% 
#   write_rds(file_out)

# tibble(x = 1) %>% write_rds(file_out)
