tibble::tibble(date = format(Sys.time(), "%b %d %X")) %>% 
  readr::write_csv("now.txt")
