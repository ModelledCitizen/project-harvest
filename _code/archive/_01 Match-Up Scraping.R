#      __  __            __   _               __          __
#     / / / /___  ____  / /__(_)___  _____   / /   ____ _/ /_
#    / /_/ / __ \/ __ \/ //_/ / __ \/ ___/  / /   / __ `/ __ \
#   / __  / /_/ / /_/ / ,< / / / / (__  )  / /___/ /_/ / /_/ /
#  /_/ /_/\____/ .___/_/|_/_/_/ /_/____/  /_____/\__,_/_.___/
#             /_/
#

library(rvest)



setwd("~/rcp-scraping")


# Functions ---------------------------------------------------------------

fetch_polls <- function(url_list) {
  lapply(url_list, function(x) {
    read_html(x) %>%
    html_nodes(xpath = "//*[@id=\"polling-data-full\"]/table") %>%
    html_table() %>%
    (function(y) {y[[1]]})
  })
}

write_save <- function(url_lst, filename) {
  data <- fetch_polls(url_list = url_lst)
  saveRDS(data, file = paste0("_data/", filename, ".rds"))
  for (i in 1:length(data)) {
    write.csv(
      data[[i]],
      file = paste0("_tables/", filename, "_", names(data)[i], ".csv"),
      row.names = F
    )
  }
}


# Run ---------------------------------------------------------------------

write_save(
  list(
    warren = "https://www.realclearpolitics.com/epolls/2020/president/us/general_election_trump_vs_warren-6251.html",
    biden = "https://www.realclearpolitics.com/epolls/2020/president/us/general_election_trump_vs_biden-6247.html",
    sanders = "https://www.realclearpolitics.com/epolls/2020/president/us/general_election_trump_vs_sanders-6250.html",
    buttigieg = "https://www.realclearpolitics.com/epolls/2020/president/us/general_election_trump_vs_buttigieg-6872.html",
    klobuchar = "https://www.realclearpolitics.com/epolls/2020/president/us/general_election_trump_vs_klobuchar-6803.html",
    bloomberg = "https://www.realclearpolitics.com/epolls/2020/president/us/general_election_trump_vs_bloomberg-6797.html"
  ),
  "national"
)

write_save(
  list(
    warren = "https://www.realclearpolitics.com/epolls/2020/president/ia/iowa_trump_vs_warren-6789.html",
    biden = "https://www.realclearpolitics.com/epolls/2020/president/ia/iowa_trump_vs_biden-6787.html",
    sanders = "https://www.realclearpolitics.com/epolls/2020/president/ia/iowa_trump_vs_sanders-6788.html"
  ),
  "iowa"
)


write_save(
  list(
    warren = "https://www.realclearpolitics.com/epolls/2020/president/nh/new_hampshire_trump_vs_warren-6781.html",
    biden = "https://www.realclearpolitics.com/epolls/2020/president/nh/new_hampshire_trump_vs_biden-6779.html",
    sanders = "https://www.realclearpolitics.com/epolls/2020/president/nh/new_hampshire_trump_vs_sanders-6780.html",
    buttigieg = "https://www.realclearpolitics.com/epolls/2020/president/nh/new_hampshire_trump_vs_buttigieg-6981.html"
  ),
  "newhampshire"
)


write_save(
  list(
    warren = "https://www.realclearpolitics.com/epolls/2020/president/sc/south_carolina_trump_vs_warren-6828.html",
    biden = "https://www.realclearpolitics.com/epolls/2020/president/sc/south_carolina_trump_vs_biden-6825.html",
    sanders = "https://www.realclearpolitics.com/epolls/2020/president/sc/south_carolina_trump_vs_sanders-6826.html",
    klobuchar = "https://www.realclearpolitics.com/epolls/2020/president/sc/south_carolina_trump_vs_klobuchar-6831.html"
  ),
  "southcarolina"
)


write_save(
  list(
    warren = "https://www.realclearpolitics.com/epolls/2020/president/nv/nevada_trump_vs_warren-6870.html",
    biden = "https://www.realclearpolitics.com/epolls/2020/president/nv/nevada_trump_vs_biden-6867.html",
    sanders = "https://www.realclearpolitics.com/epolls/2020/president/nv/nevada_trump_vs_sanders-6868.html",
    buttigieg = "https://www.realclearpolitics.com/epolls/2020/president/nv/nevada_trump_vs_buttigieg-6871.html"
  ),
  "nevada"
)
