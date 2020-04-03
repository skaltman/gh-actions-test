# Download data if it has been updated

# Author: Sara Altman
# Version: 2020-03-30

# Libraries
library(tidyverse)
library(httr)
library(yaml)

# Parameters
# File with data about each dataset
file_datasets <- here::here("data/datasets.yaml")
# API query for commits
query <- 
  "https://api.github.com/repos/{owner}/{repo}/commits?path={file}"
# LA Times data token

#===============================================================================

if (1 == 1) {
  tibble::tibble(date = format(Sys.time(), "%b %d %X")) %>% 
    readr::write_csv("now.txt")
}

# latest_commit <- function(owner, repo, file) {
#   GET(str_glue(query)) %>% 
#     content() %>% 
#     first() 
# } 
# 
# latest_data <- function(dataset) {
#   v <- datasets[[dataset]]
#   
#   new_sha <- latest_commit(v$owner, v$repo, v$file)$sha
#   
#   if (new_sha != v$sha) {
#     source(v$script)
#     v$sha <- new_sha
#   }
#   
#   return(v)
# }
# 
# datasets <-
#   file_datasets %>% 
#   read_yaml()
# 
# datasets %>% 
#   names() %>% 
#   set_names() %>% 
#   map(latest_data) %>% 
#   write_yaml(file_datasets)
