# Download Los Angeles Times county COVID-19 data

# Author: Bill Behrman
# Version: 2020-04-01

# Libraries
library(tidyverse)
library(vroom)

# Parameters
  # URL for source data
url <- 
  "https://raw.githubusercontent.com/datadesk/california-coronavirus-data/master/local-agency-survey.csv?token=ADZRQ2OVA2PGJDJXWQVQ7TK6RYSN6"
  # Population data
file_populations <- here::here("data/populations.csv")
  # Who to email in case of error
email <- "behrman@stanford.edu"
  # Send email for read error
error_read <- 'mail -s "{Sys.time()}: LA Times read error" {email} < /dev/null'
  # Send email for FIPS error
error_fips <- 'mail -s "{Sys.time()}: LA Times fips error" {email} < /dev/null'
  # Download location
file_out <- here::here("data/latimes.rds")

#===============================================================================

populations <-
  read_csv(
    file_populations,
    col_types = 
      cols(
        region = col_character(),
        fips = col_integer(),
        population = col_double()
      )
  ) %>% 
  mutate(region = str_remove(region, "\\s+County$"))

v <- 
  tryCatch(
    url %>% 
      vroom(
        col_types = 
          cols(
            agency = col_character(),
            county = col_character(),
            date = col_date(format = ""),
            confirmed_cases = col_double(),
            deaths = col_double()
          )
      ),
    error = function(condition) {
      system(str_glue(error_read))
      stop()
    }
  )

if (!all(unique(v$county) %in% populations$region)) {
  system(str_glue(error_fips))
  stop()
}

v %>% 
  left_join(
    populations %>% select(region, fips),
    by = c("county" = "region")
  ) %>% 
  filter(county != "Nevada") %>% 
  select(date, agency, county, fips, cases = confirmed_cases, deaths) %>% 
  write_rds(file_out)
