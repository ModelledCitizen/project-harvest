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

import_rcp <- function(pollno,
                       min.date = NULL,
                       max.date = NULL) {
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
  filter_by_date <- function(pll,
                             min.date = NULL,
                             max.date = NULL) {
    if (!is.null(min.date)) {
      min.date <- as.Date(min.date)
      pll <- pll[pll$data_end_date >= min.date,]
    }
    if (!is.null(max.date)) {
      max.date <- as.Date(max.date)
      pll <- pll[pll$data_end_date <= max.date,]
    }
    pll
  }
  poll_url <-
    paste0("https://www.realclearpolitics.com/poll/race/",
           pollno,
           "/polling_data.json")
  poll_url %>%
    getURL() %>%
    extract_poll() %>%
    clean_poll() %>%
    filter_by_date(min.date, max.date)
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
    rcp_poll[grep("poll", rcp_poll[["type"]], fixed = T), ]
  spreads <- extract_spreads(rcp_poll)
  median(spreads)
}

get_all_medians <-
  function(poll_list,
           min.date = NULL,
           max.date = NULL) {
    get_median_from_pollno <-
      function(pollno,
               min.date = NULL,
               max.date = NULL) {
        require(magrittr)
        pollno %>%
          import_rcp(min.date, max.date) %>%
          find_spread_median()
      }
    medians <-
      sapply(poll_list, get_median_from_pollno, min.date, max.date)
    names(medians) <- names(poll_list)
    medians
  }

export_tables <- function(flnm, poll_list) {
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
  merge_ratings <- function(pll) {
    cross <- read.csv("fte_rcp_crosswalk.csv")
    rtngs <- read.csv("pollster-ratings.csv")
    m1 <-
      merge(pll,
            cross,
            by.x = "pollster",
            by.y = "rcp_pollster_name",
            all.x = T)
    merge(m1,
          rtngs,
          by.x = "fte_pollster_ratings_id",
          by.y = "Pollster.Rating.ID",
          all.x = T)
  }
  for (name in names(poll_list)) {
    dta <- import_rcp(poll_list[[name]])
    saveRDS(dta, paste0("_data/json/", flnm, "_", name, ".RDS"))
    dta[["undecided"]] <- NULL
    dta <- bind_spreads(dta)
    dta <- bind_candidate(dta)
    dta <- merge_ratings(dta)
    dta <- dta[order(dta$data_end_date, decreasing = T),]
    dta <-
      rbind(dta[dta$pollster == "rcp_average", ],
            dta[dta$pollster != "rcp_average", ])
    write.csv(dta, paste0("_tables/json/", flnm, "_", name, ".csv"))
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

get_all_medians(
  list(
    Warren = 6251,
    Biden = 6247,
    Sanders = 6250,
    Buttigieg = 6872,
    Klobuchar = 6803,
    Bloomberg = 6797
  ),
  min.date = "2020-01-01"
)

get_all_medians(
  list(
    Warren = 6251,
    Biden = 6247,
    Sanders = 6250,
    Buttigieg = 6872,
    Klobuchar = 6803,
    Bloomberg = 6797
  ),
  min.date = "2020-02-01"
)


export_tables(
  "National",
  list(
    All = 6730,
    Warren = 6251,
    Biden = 6247,
    Sanders = 6250,
    Buttigieg = 6872,
    Klobuchar = 6803,
    Bloomberg = 6797
  )
)


### Wisconsin
export_tables(
  "Wisconsin",
  list(
    All = 6848,
    Warren = 6852,
    Biden = 6849,
    Sanders = 6850,
    Buttigieg = 6970,
    Klobuchar = 6854,
    Bloomberg = 7032
  )
)

### Pennsylvania
export_tables(
  "Pennsylvania",
  list(
    All = 6860,
    Warren = 6865,
    Biden = 6861,
    Sanders = 6862,
    Buttigieg = 6899,
    Klobuchar = 7031,
    Bloomberg = 7030
  )
)

### Michigan
export_tables(
  "Michigan",
  list(
    All = 6835,
    Warren = 6769,
    Biden = 6761,
    Sanders = 6768,
    Buttigieg = 6909,
    Klobuchar = 6836,
    Bloomberg = 6997
  )
)

