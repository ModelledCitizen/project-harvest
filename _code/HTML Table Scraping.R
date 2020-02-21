#      __  __            __   _               __          __
#     / / / /___  ____  / /__(_)___  _____   / /   ____ _/ /_
#    / /_/ / __ \/ __ \/ //_/ / __ \/ ___/  / /   / __ `/ __ \
#   / __  / /_/ / /_/ / ,< / / / / (__  )  / /___/ /_/ / /_/ /
#  /_/ /_/\____/ .___/_/|_/_/_/ /_/____/  /_____/\__,_/_.___/
#             /_/
#


# Packages ----------------------------------------------------------------

library(magrittr)
library(rvest)
library(RCurl)
library(jsonlite)

# Working Directory -------------------------------------------------------

setwd("~/rcp-scraping")

# Functionss --------------------------------------------------------------

fetch_polls <- function(url_list) {
  lapply(url_list, function(x) {
    tableset <- read_html(x) %>%
      html_nodes(xpath = "//*[@id=\"polling-data-full\"]/table")
    tableset %>%
      html_nodes(".mobile_pollster_name") %>%
      xml_remove()
    tableset %>%
      html_table() %>%
      (function(y) {y[[1]]})
  })
}

write_save <- function(url_lst, filename) {
  data <- fetch_polls(url_list = url_lst)
  saveRDS(data, file = paste0("_data/html/", filename, ".rds"))
  for (i in 1:length(data)) {
    write.csv(
      data[[i]],
      file = paste0("_tables/html/", filename, "_", names(data)[i], ".csv"),
      row.names = F
    )
  }
}

assign_ids <- function(filename) {
  data <- readRDS(file = paste0("_data/html/", filename, ".rds"))
  unq <- unique(unlist(sapply(data, function(x) {paste(x$Poll, x$Date)})))
  ids <- data.frame(names = unq, id = sample(1000:9999, length(unq)))
  data <- lapply(data, function(x) {
    x[["names"]] <- paste(x$Poll, x$Date)
    return(x)
  })
  data <-
    lapply(data, function(x) {
      merge(x, ids, by = "names", all.x = T)
    })
  data <-
    lapply(data, function(x) {
      x[["names"]] <- NULL
      return(x)
    })
  saveRDS(data, file = paste0("_data/html/", filename, ".rds"))
  for (i in 1:length(data)) {
    write.csv(
      data[[i]],
      file = paste0("_tables/html/", filename, "_", names(data)[i], ".csv"),
      row.names = F
    )
    rm(i)
  }
}

find_spreads <-
  function(dta) {
    ind <-
      which(
        names(dta) %in% c(
          "Warren (D)",
          "Biden (D)",
          "Sanders (D)",
          "Buttigieg (D)",
          "Klobuchar (D)",
          "Bloomberg (D)"
        )
      )
    dta[dta$Poll != "RCP Average", "Trump (R)"] - dta[dta$Poll != "RCP Average", ind]
  }


find_medians <- function(pollname, url_list) {
  write_save(url_lst = url_list, filename = pollname)
  assign_ids(filename = pollname)
  dta <- readRDS(file = paste0("_data/html/", pollname, ".rds"))
  spreads <- lapply(dta, find_spreads)
  sapply(spreads, median)
}


# Run ---------------------------------------------------------------------

find_medians(
  "national",
  list(
    warren = "https://www.realclearpolitics.com/epolls/2020/president/us/general_election_trump_vs_warren-6251.html",
    biden = "https://www.realclearpolitics.com/epolls/2020/president/us/general_election_trump_vs_biden-6247.html",
    sanders = "https://www.realclearpolitics.com/epolls/2020/president/us/general_election_trump_vs_sanders-6250.html",
    buttigieg = "https://www.realclearpolitics.com/epolls/2020/president/us/general_election_trump_vs_buttigieg-6872.html",
    klobuchar = "https://www.realclearpolitics.com/epolls/2020/president/us/general_election_trump_vs_klobuchar-6803.html",
    bloomberg = "https://www.realclearpolitics.com/epolls/2020/president/us/general_election_trump_vs_bloomberg-6797.html"
  )
)





# General Election Poll Table ---------------------------------------------

url <- "https://www.realclearpolitics.com/epolls/2020/president/us/2020_democratic_presidential_nomination-6730.html"

all_polls <- read_html(url) %>%
  html_nodes(xpath = "//*[@id=\"polling-data-full\"]/table")
all_polls %>%
  html_nodes(".mobile_pollster_name") %>%
  xml_remove()
all_polls <- all_polls %>%
  html_table() %>%
  (function(y) {y[[1]]})

saveRDS(all_polls, file = "_data/html/all_polls.rds")
write.csv(
  all_polls,
  file = "_tables/html/all_polls.csv",
  row.names = F
)
