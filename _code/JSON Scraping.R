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


# Functions ---------------------------------------------------------------

import_rcp <- function(pollno) {
  require(magrittr)
  require(RCurl)
  require(jsonlite)
  extract_poll <-
    function(rcp_json) {
      jsonlite::fromJSON(rcp_json)[["poll"]]
    }
  clean_poll <- function(rcp_extract) {
    rcp_extract[["data_start_date"]] <-
      as.Date(rcp_extract[["data_start_date"]], "%Y/%m/%d")
    rcp_extract[["data_end_date"]] <-
      as.Date(rcp_extract[["data_end_date"]], "%Y/%m/%d")
    rcp_extract[["updated"]] <-
      strptime(rcp_extract[["updated"]], "%a, %d %b %Y %T %z")
    rcp_extract
  }
  poll_url <-
    paste0("https://www.realclearpolitics.com/poll/race/",
           pollno,
           "/polling_data.json")
  poll_url %>% getURL() %>% extract_poll() %>% clean_poll()
}

find_spread_median <- function(rcp_poll) {
  extract_spreads <- function(pll) {
    sign_spread <- function(sprds) {
      ot <-
        switch(
          sprds[["affiliation"]],
          Democrat = as.numeric(sprds[["value"]]),
          Republican = -as.numeric(sprds[["value"]])
        )
      if (is.null(ot) & sprds[["name"]] == "Tie") {
        ot <- 0
      }
      ot
    }
    spreads <- pll[["spread"]]
    unlist(apply(spreads, 1, sign_spread))
  }
  rcp_poll <-
    rcp_poll[grep("poll", rcp_poll[["type"]], fixed = T),]
  spreads <- extract_spreads(rcp_poll)
  median(spreads)
}

get_all_medians <- function(poll_list) {
  get_median_from_pollno <- function(pollno) {
    require(magrittr)
    pollno %>%
      import_rcp() %>%
      find_spread_median()
  }
  medians <- sapply(poll_list, get_median_from_pollno)
  names(medians) <- names(poll_list)
  medians
}

export_tables <- function(poll_list) {
  bind_spreads <- function(pll) {
    spreads <- pll[["spread"]]
    pll[["spreads"]] <- NULL
    cbind(pll, spreads)
  }
  bind_candidate <- function(pll) {
    pivot_candidate <- function(cndt) {
      values <- as.numeric(cndt$value)
      names(values) <- cndt$name
      values
    }
    candidates <- lapply(pll[["candidate"]], pivot_candidate)
    candidates <- Reduce(rbind, candidates)
    pll[["candidate"]] <- NULL
    cbind(pll, candidates)
  }
  for (name in names(poll_list)) {
    dta <- import_rcp(poll_list[[name]])
    saveRDS(dta, paste0("_data/json/", name, ".RDS"))
    dta[["undecided"]] <- NULL
    dta <- bind_spreads(dta)
    dta <- bind_candidate(dta)
    write.csv(dta, paste0("_tables/json/", name, ".csv"))
  }
}

# General Election Head to Head -------------------------------------------

get_all_medians(
  list(
    Warren = 6251,
    Biden = 6247,
    Sanders = 6250,
    Buttigieg = 6872,
    Klobuchar = 6803,
    Bloomberg = 6797
  )
)

export_tables(list(
  All = 6730,
  Warren = 6251,
  Biden = 6247,
  Sanders = 6250,
  Buttigieg = 6872,
  Klobuchar = 6803,
  Bloomberg = 6797
))
