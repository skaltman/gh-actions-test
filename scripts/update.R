# Download data if it has been updated

# Author: Sara Altman
# Version: 2020-03-30

# Libraries
library(tidyverse)
library(httr)
library(yaml)

# Parameters
  # File with data about each dataset
file_datasets <- here::here("data-raw/datasets.yaml")
#   # API query for commits
# query <- 
#   "https://api.github.com/repos/{owner}/{repo}/commits?path={file}"

#===============================================================================

latest_commit <- function(owner, repo, file) {
  GET(
    "https://api.github.com/repos/nytimes/covid-19-data/commits?path=us-states.csv"
  ) %>% 
    content() %>%
    first()
}

latest_data <- function(dataset) {
  v <- datasets[[dataset]]
  #new_sha <- latest_commit(v$owner, v$repo, v$file)$sha
  # x <- str_c(v$owner, v$repo, v$file)
  GET(
    str_glue("https://api.github.com/repos/{v$owner}/{v$repo}/commits?path={v$file}")
  ) %>% 
    content() %>%
    first()

  # if (new_sha != v$sha) {
  #   # source(v$script)
  #   v$sha <- new_sha
  # }
  # 
  # return(v)
}

datasets <-
  file_datasets %>%
  read_yaml()

datasets %>%
  names() %>%
  set_names() %>%
  walk(latest_data)
  # map(latest_data) %>%
  # write_yaml(file_datasets)




