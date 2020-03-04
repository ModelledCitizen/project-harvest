#      __  __            __   _               __          __
#     / / / /___  ____  / /__(_)___  _____   / /   ____ _/ /_
#    / /_/ / __ \/ __ \/ //_/ / __ \/ ___/  / /   / __ `/ __ \
#   / __  / /_/ / /_/ / ,< / / / / (__  )  / /___/ /_/ / /_/ /
#  /_/ /_/\____/ .___/_/|_/_/_/ /_/____/  /_____/\__,_/_.___/
#             /_/
#
# Title: NYT Results
# Author: UnlikelyVolcano
# Date Updated: 03 March 2020
# Notes: First version

# Working Directory -------------------------------------------------------

setwd("~/project-harvest")

# Functions ---------------------------------------------------------------

nyt_retrieve <-
  function(state,
           contest = "president",
           party = "democrat") {
    require(magrittr)
    require(RCurl)
    make_url <- function(state, contest, party) {
      get_primary_date <- function(state) {
        get_calendar <- function() {
          require(rvest)
          cal <-
            read_html(
              "https://en.wikipedia.org/wiki/2020_Democratic_Party_presidential_primaries"
            ) %>%
            html_nodes("#mw-content-text > div > table:nth-child(123)") %>%
            html_table(fill = T)
          cal <- cal[[1]]
          cal <-
            cal[cal$`Primaries/caucuses` != "Total", c("Date", "Primaries/caucuses")]
          cal$Date <- as.Date(strptime(cal$Date, "%B %e"))
          cal$`Primaries/caucuses` <-
            gsub(" caucuses| primary", "", cal$`Primaries/caucuses`)
          cal
        }
        cal <- get_calendar()
        cal$Date[cal$`Primaries/caucuses` == state]
      }
      date <- get_primary_date(state)
      state <- gsub(" ", "-", tolower(state))
      sprintf(
        "https://int.nyt.com/applications/elections/2020/data/api/%s/%s/%s/%s.json",
        date,
        state,
        contest,
        party
      )
    }
    extract_result <- function(jsn) {
      require(jsonlite)
      fromJSON(jsn)[["data"]][["races"]][["candidates"]][[1]]
    }
    make_url(state, contest, party) %>% getURL() %>% extract_result()
  }

nyt_write <- function(state, contest = "president", party = "democrat") {
  dta <- nyt_retrieve(state, contest, party)
  saveRDS(dta, file = sprintf("_data/results/NYT_%s.RDS", state))
  write.csv(dta, file = sprintf("_tables/results/NYT_%s.csv", state))
}


# Output ------------------------------------------------------------------

nyt_write("Iowa")
nyt_write("New Hampshire")
nyt_write("Nevada")
nyt_write("South Carolina")

#nyt_write("American Samoa")
nyt_write("Alabama")
nyt_write("Arkansas")
nyt_write("California")
nyt_write("Colorado")
nyt_write("Maine")
nyt_write("Massachusetts")
nyt_write("Minnesota")
nyt_write("North Carolina")
nyt_write("Oklahoma")
nyt_write("Tennessee")
nyt_write("Texas")
nyt_write("Utah")
nyt_write("Vermont")
nyt_write("Virginia")

