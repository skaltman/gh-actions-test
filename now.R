library(magrittr)

tibble::tibble(date = format(Sys.time(), "%b %d %X")) %>% 
  readr::write_csv(x, "now2.txt")

