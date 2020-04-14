#      __  __            __   _               __          __
#     / / / /___  ____  / /__(_)___  _____   / /   ____ _/ /_
#    / /_/ / __ \/ __ \/ //_/ / __ \/ ___/  / /   / __ `/ __ \
#   / __  / /_/ / /_/ / ,< / / / / (__  )  / /___/ /_/ / /_/ /
#  /_/ /_/\____/ .___/_/|_/_/_/ /_/____/  /_____/\__,_/_.___/
#             /_/
#
#   Title: NYT Results
#  Author: UnlikelyVolcano
# Updated: 14 April 2020
#   Notes: Updated primary calendar source due to COVID delays

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
      get_election_date <- function(state, party) {
        get_calendar <- function(party) {
          if (paste0(party, "_primary_calendar.csv") %in% list.files()) {
            cal <- read.csv(paste0(party, "_primary_calendar.csv"))
          } else {
            require(rvest)
            require(stringr)
            cal <-
              read_html(
                "https://www.uspresidentialelectionnews.com/2020-presidential-primary-schedule-calendar/"
              ) %>%
              html_nodes("#footable_34731") %>%
              html_table(fill = T)
            cal <- cal[[1]]
            cal <-
              cal[cal$Type %in% c("Open", "Closed", "Mixed"), c("Date", "State")]
            switch(party,
                   republican = {
                     cal <- cal[str_detect(cal$State, "Democratic", negate = T), ]
                   },
                   democrat = {
                     cal <- cal[str_detect(cal$State, "Republican", negate = T),]
                   })
            cal$Date <- as.Date(strptime(cal$Date, "%a, %b %e"))
            cal$State <- gsub(" \\|", "", cal$State)
            cal$State <-
              gsub(
                " Democratic| Republican| caucus| caucuses| primary| convention| Results",
                "",
                cal$State
              )
            cal$State <- gsub("\\(|\\)", "", cal$State)
            cal$State <- gsub(" delayed", "", cal$State)
            cal$State <- gsub(" to 3/10", "", cal$State)
            cal$State <-
              gsub(
                " Update| Rescheduled| Mail only",
                "",
                cal$State
              )
            write.csv(cal, paste0(party, "_primary_calendar.csv"), row.names = F)
          }
          cal
        }
        cal <- get_calendar(party)
        as.Date(cal$Date[cal$State == state])
      }
      date <- get_election_date(state, party)
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

nyt_write <-
  function(state,
           contest = "president",
           party = "democrat") {
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


# 2020-03-17
nyt_write("Arizona")
nyt_write("Florida")
nyt_write("Illinois")


# 2020-04-07
nyt_write("Wisconsin")