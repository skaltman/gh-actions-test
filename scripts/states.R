# State abbreviations and FIPS codes

# Author: Name
# Version: 2020-03-30

# Libraries
library(tidyverse)

# Parameters
file_states <- here::here("data/states.csv")

#===============================================================================

tidycensus::fips_codes %>% 
  distinct(state, state_code, state_name) %>% 
  rename(state_abbr = state, state_fips = state_code, state = state_name) %>% 
  transmute(
    state,
    state_abbr,
    state_fips = as.integer(state_fips)
  ) %>% 
  filter(state_fips <= 56) %>% 
  write_csv(file_states)
