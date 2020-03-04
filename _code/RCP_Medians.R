#      __  __            __   _               __          __
#     / / / /___  ____  / /__(_)___  _____   / /   ____ _/ /_
#    / /_/ / __ \/ __ \/ //_/ / __ \/ ___/  / /   / __ `/ __ \
#   / __  / /_/ / /_/ / ,< / / / / (__  )  / /___/ /_/ / /_/ /
#  /_/ /_/\____/ .___/_/|_/_/_/ /_/____/  /_____/\__,_/_.___/
#             /_/
#
#   Title: RCP Medians
#  Author: UnlikelyVolcano
# Updated: 03 March 2020
#   Notes: Legacy code

# Working Directory -------------------------------------------------------

setwd("~/project-harvest")


# Function ----------------------------------------------------------------

get_medians <-
  function(poll_list,
           min.date = NULL,
           max.date = NULL) {

    get_median_from_pollno <-
      function(pollno, min.date, max.date) {
        require(magrittr)
        import_rcp <- function(pollno,
                               min.date = NULL,
                               max.date = NULL) {
          require(magrittr)
          require(RCurl)
          extract_poll <-
            function(rcp_json) {
              require(jsonlite)
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
        pollno %>%
          import_rcp(min.date, max.date) %>%
          find_spread_median()
      }
    medians <-
      sapply(poll_list, get_median_from_pollno, min.date, max.date)
    names(medians) <- names(poll_list)
    medians
  }


# Output ------------------------------------------------------------------

get_medians(
  list(
    Warren = 6251,
    Biden = 6247,
    Sanders = 6250,
    Buttigieg = 6872,
    Klobuchar = 6803,
    Bloomberg = 6797
  )
)

get_medians(
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

get_medians(
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



