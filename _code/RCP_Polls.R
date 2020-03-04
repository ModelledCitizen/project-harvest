#      __  __            __   _               __          __
#     / / / /___  ____  / /__(_)___  _____   / /   ____ _/ /_
#    / /_/ / __ \/ __ \/ //_/ / __ \/ ___/  / /   / __ `/ __ \
#   / __  / /_/ / /_/ / ,< / / / / (__  )  / /___/ /_/ / /_/ /
#  /_/ /_/\____/ .___/_/|_/_/_/ /_/____/  /_____/\__,_/_.___/
#             /_/
#
#   Title: RCP Polls
#  Author: UnlikelyVolcano
# Updated: 04 March 2020
#   Notes: Simplified and streamlined to match NYT,
#          but need to improve ID retrieval.

# Working Directory -------------------------------------------------------

setwd("~/project-harvest")


# Functions ---------------------------------------------------------------

rcp_retrieve <- function(state,
                         contest = "president",
                         party = "democrat") {
  require(magrittr)
  require(RCurl)
  make_url <- function(state, contest, party) {
    lkp <- read.csv("rcp_lookup.csv")
    pollno <- lkp$pollno[lkp$state == state &
                           lkp$contest == contest &
                           lkp$party == party]
    sprintf("https://www.realclearpolitics.com/poll/race/%d/polling_data.json",
            pollno)
  }
  extract_poll <-
    function(rcp_json) {
      require(jsonlite)
      jsonlite::fromJSON(rcp_json)[["poll"]]
    }
  clean_poll <- function(rcp_extract) {
    bind_spreads <- function(pll) {
      spreads <- pll[["spread"]]
      pll[["spreads"]] <- NULL
      pll <- cbind(pll, spreads)
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
      pll <- cbind(pll, candidates)
    }
    rcp_extract[["data_start_date"]] <-
      as.Date(rcp_extract[["data_start_date"]], "%Y/%m/%d")
    rcp_extract[["data_end_date"]] <-
      as.Date(rcp_extract[["data_end_date"]], "%Y/%m/%d")
    rcp_extract[["updated"]] <-
      strptime(rcp_extract[["updated"]], "%a, %d %b %Y %T %z")
    rcp_extract[["undecided"]] <- NULL
    rcp_extract[order(rcp_extract$data_end_date, decreasing = T),]
    rcp_extract %>% bind_spreads() %>% bind_candidate()
  }
  make_url(state, contest, party) %>%
    getURL() %>%
    extract_poll() %>%
    clean_poll()
}

rcp_write <- function(state,
                      contest = "president",
                      party = "democrat") {
  merge_ratings <- function(pll) {
    cross <- read.csv("pollster_crosswalk.csv")
    rtngs <- read.csv("pollster-ratings.csv")
    m1 <-
      merge(pll,
            cross,
            by.x = "pollster",
            by.y = "rcp_pollster_name",
            all.x = T)
    m2 <- merge(m1,
                rtngs,
                by.x = "fte_pollster_name",
                by.y = "Pollster",
                all.x = T)
    m2 <- m2[order(m2$data_end_date, decreasing = T), ]
    rbind(m2[m2$pollster == "rcp_average", ],
          m2[m2$pollster != "rcp_average", ])
  }
  dta <- rcp_retrieve(state, contest, party)
  saveRDS(dta, sprintf("_data/polls/RCP_%s_%s.RDS", state, contest))
  dta <- merge_ratings(dta)
  write.csv(dta, sprintf("_tables/polls/RCP_%s_%s.csv", state, contest))
}


# Output ------------------------------------------------------------------

poll_list <- read.csv("rcp_lookup.csv", stringsAsFactors = F)

for (i in 1:nrow(poll_list)) {
  rcp_write(poll_list$state[i], poll_list$contest[i], poll_list$party[i])
}

rm(i, poll_list)

