#      __  __            __   _               __          __
#     / / / /___  ____  / /__(_)___  _____   / /   ____ _/ /_
#    / /_/ / __ \/ __ \/ //_/ / __ \/ ___/  / /   / __ `/ __ \
#   / __  / /_/ / /_/ / ,< / / / / (__  )  / /___/ /_/ / /_/ /
#  /_/ /_/\____/ .___/_/|_/_/_/ /_/____/  /_____/\__,_/_.___/
#             /_/
#
#   Title: NYT Results
#  Author: UnlikelyVolcano
# Updated: 04 March 2020
#   Notes: Revised to gather county level results

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
      get_election_date <- function(state) {
        get_calendar <- function() {
          if ("primary_calendar.csv" %in% list.files()) {
            cal <- read.csv("primary_calendar.csv")
          } else {
            require(rvest)
            cal <-
              read_html(
                "https://en.wikipedia.org/w/index.php?title=2020_Democratic_Party_presidential_primaries&oldid=943803552"
              ) %>%
              html_nodes("#mw-content-text > div > table:nth-child(124)") %>%
              html_table(fill = T)
            cal <- cal[[1]]
            names(cal)[names(cal) == "Primaries/caucuses"] <-
              "State"
            cal <-
              cal[cal$State != "Total", c("Date", "State")]
            cal$Date <- as.Date(strptime(cal$Date, "%B %e"))
            cal$State <- gsub("\\(|\\)", "", cal$State)
            cal$State <- gsub(" caucuses| primary", "", cal$State)
            cal$State <-
              gsub(" firehouse| voting period ends", "", cal$State)
            cal$State <- gsub(" party-run", "", cal$State)
            write.csv(cal, "primary_calendar.csv", row.names = F)
          }
          cal
        }
        cal <- get_calendar()
        cal$Date[cal$State == state]
      }
      date <- get_election_date(state)
      state <- gsub(" ", "-", tolower(state))
      sprintf(
        "https://int.nyt.com/applications/elections/2020/data/api/%s/%s/%s/%s.json",
        date,
        state,
        contest,
        party
      )
    }
    extract_localities <- function(jsn) {
      require(jsonlite)
      fromJSON(jsn)[["data"]][["races"]][["counties"]][[1]]
    }
    extract_toplines <- function(jsn) {
      require(jsonlite)
      fromJSON(jsn)[["data"]][["races"]][["candidates"]][[1]]
    }
    jsn <- make_url(state, contest, party) %>% getURL()
    list(localities = extract_localities(jsn), toplines = extract_toplines(jsn))
  }

nyt_write <- function(state, contest = "president", party = "democrat") {
  dta <- nyt_retrieve(state, contest, party)[["localities"]]
  saveRDS(dta, file = sprintf("_data/results/NYT_%s.RDS", state))
  write.csv(dta, file = sprintf("_tables/results/NYT_%s.csv", state))
}


# Output ------------------------------------------------------------------

# 2020-02-03
nyt_write("Iowa")

# 2020-02-11
nyt_write("New Hampshire")

# 2020-02-22
nyt_write("Nevada")

# 2020-02-29
nyt_write("South Carolina")

# 2020-03-03
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

# 2020-03-10
nyt_write("Michigan")
nyt_write("Washington")
nyt_write("Missouri")
nyt_write("Mississippi")
nyt_write("Idaho")
nyt_write("North Dakota")

