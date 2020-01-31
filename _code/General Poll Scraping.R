#      __  __            __   _               __          __
#     / / / /___  ____  / /__(_)___  _____   / /   ____ _/ /_
#    / /_/ / __ \/ __ \/ //_/ / __ \/ ___/  / /   / __ `/ __ \
#   / __  / /_/ / /_/ / ,< / / / / (__  )  / /___/ /_/ / /_/ /
#  /_/ /_/\____/ .___/_/|_/_/_/ /_/____/  /_____/\__,_/_.___/
#             /_/
#

library(rvest)

setwd("~/rcp-scraping")

url <- "https://www.realclearpolitics.com/epolls/2020/president/us/2020_democratic_presidential_nomination-6730.html"

all_polls <- read_html(url) %>%
  html_nodes(xpath = "//*[@id=\"polling-data-full\"]/table") %>%
  html_table() %>%
  (function(y) {y[[1]]})

saveRDS(all_polls, file = "_data/all_polls.rds")
write.csv(
  all_polls,
  file = "_tables/all_polls.csv",
  row.names = F
)
