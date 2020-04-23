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
query <-
  "https://api.github.com/repos/{owner}/{repo}/commits?path={file}"

#===============================================================================

latest_commit <- function(owner, repo, file) {
  GET(str_glue(query), authenticate(Sys.getenv("GITHUB_PAT"), "")) %>% 
    content() %>%
    first()
}

latest_data <- function(dataset) {
  new_sha <- 
    latest_commit(dataset$owner, dataset$repo, dataset$file)$sha
  
  if (new_sha != dataset$sha) {
    source(dataset$script)
    dataset$sha <- new_sha
  }

  return(dataset)
}

datasets <-
  file_datasets %>%
  read_yaml()

datasets %>%
  names() %>%
  set_names() %>%
  map(~ latest_data(dataset = datasets[[.]])) %>%
  write_yaml(file_datasets)



