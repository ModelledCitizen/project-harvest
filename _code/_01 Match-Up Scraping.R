#      __  __            __   _               __          __
#     / / / /___  ____  / /__(_)___  _____   / /   ____ _/ /_
#    / /_/ / __ \/ __ \/ //_/ / __ \/ ___/  / /   / __ `/ __ \
#   / __  / /_/ / /_/ / ,< / / / / (__  )  / /___/ /_/ / /_/ /
#  /_/ /_/\____/ .___/_/|_/_/_/ /_/____/  /_____/\__,_/_.___/
#             /_/
#

library(rvest)

setwd("~/rcp-scraping")

fetch_polls <- function(url_list) {
  lapply(url_list, function(x) {
    read_html(x) %>%
    html_nodes(xpath = "//*[@id=\"polling-data-full\"]/table") %>%
    html_table() %>%
    (function(y) {y[[1]]})
  })
}


national_urls <- list(
  warren = "https://www.realclearpolitics.com/epolls/2020/president/us/general_election_trump_vs_warren-6251.html",
  biden = "https://www.realclearpolitics.com/epolls/2020/president/us/general_election_trump_vs_biden-6247.html",
  sanders = "https://www.realclearpolitics.com/epolls/2020/president/us/general_election_trump_vs_sanders-6250.html",
  buttigieg = "https://www.realclearpolitics.com/epolls/2020/president/us/general_election_trump_vs_buttigieg-6872.html",
  klobuchar = "https://www.realclearpolitics.com/epolls/2020/president/us/general_election_trump_vs_klobuchar-6803.html"
)
national_data <- fetch_polls(national_urls)
saveRDS(national_data, file = "_data/national.rds")
for (i in 1:length(national_data)) {
  write.csv(
    national_data[[i]],
    file = paste0("_tables/national_", names(national_data)[i], ".csv"),
    row.names = F
  )
  rm(i)
}

iowa_urls <- list(
  warren = "https://www.realclearpolitics.com/epolls/2020/president/ia/iowa_trump_vs_warren-6789.html",
  biden = "https://www.realclearpolitics.com/epolls/2020/president/ia/iowa_trump_vs_biden-6787.html",
  sanders = "https://www.realclearpolitics.com/epolls/2020/president/ia/iowa_trump_vs_sanders-6788.html"
)
iowa_data <- fetch_polls(iowa_urls)
saveRDS(iowa_data, file = "_data/iowa.rds")
for (i in 1:length(iowa_data)) {
  write.csv(
    iowa_data[[i]],
    file = paste0("_tables/iowa_", names(iowa_data)[i], ".csv"),
    row.names = F
  )
  rm(i)
}


newhampshire_urls <- list(
  warren = "https://www.realclearpolitics.com/epolls/2020/president/nh/new_hampshire_trump_vs_warren-6781.html",
  biden = "https://www.realclearpolitics.com/epolls/2020/president/nh/new_hampshire_trump_vs_biden-6779.html",
  sanders = "https://www.realclearpolitics.com/epolls/2020/president/nh/new_hampshire_trump_vs_sanders-6780.html",
  buttigieg = "https://www.realclearpolitics.com/epolls/2020/president/nh/new_hampshire_trump_vs_buttigieg-6981.html"
)
newhampshire_data <- fetch_polls(newhampshire_urls)
saveRDS(newhampshire_data, file = "_data/newhampshire.rds")
for (i in 1:length(newhampshire_data)) {
  write.csv(
    newhampshire_data[[i]],
    file = paste0("_tables/newhampshire_", names(newhampshire_data)[i], ".csv"),
    row.names = F
  )
  rm(i)
}


southcarolina_urls <- list(
  warren = "https://www.realclearpolitics.com/epolls/2020/president/sc/south_carolina_trump_vs_warren-6828.html",
  biden = "https://www.realclearpolitics.com/epolls/2020/president/sc/south_carolina_trump_vs_biden-6825.html",
  sanders = "https://www.realclearpolitics.com/epolls/2020/president/sc/south_carolina_trump_vs_sanders-6826.html",
  klobuchar = "https://www.realclearpolitics.com/epolls/2020/president/sc/south_carolina_trump_vs_klobuchar-6831.html"
)
southcarolina_data <- fetch_polls(southcarolina_urls)
saveRDS(southcarolina_data, file = "_data/southcarolina.rds")
for (i in 1:length(southcarolina_data)) {
  write.csv(
    southcarolina_data[[i]],
    file = paste0("_tables/southcarolina_", names(southcarolina_data)[i], ".csv"),
    row.names = F
  )
  rm(i)
}

nevada_urls <- list(
  warren = "https://www.realclearpolitics.com/epolls/2020/president/nv/nevada_trump_vs_warren-6870.html",
  biden = "https://www.realclearpolitics.com/epolls/2020/president/nv/nevada_trump_vs_biden-6867.html",
  sanders = "https://www.realclearpolitics.com/epolls/2020/president/nv/nevada_trump_vs_sanders-6868.html",
  buttigieg = "https://www.realclearpolitics.com/epolls/2020/president/nv/nevada_trump_vs_buttigieg-6871.html"
)
nevada_data <- fetch_polls(nevada_urls)
saveRDS(nevada_data, file = "_data/nevada.rds")
for (i in 1:length(nevada_data)) {
  write.csv(
    nevada_data[[i]],
    file = paste0("_tables/nevada_", names(nevada_data)[i], ".csv"),
    row.names = F
  )
  rm(i)
}
