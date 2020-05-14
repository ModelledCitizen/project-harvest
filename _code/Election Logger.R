nyt_retrieve <-
  function(state,
           contest = "president",
           party = "democrat") {
    require(magrittr)
    require(RCurl)
    make_url <- function(state, contest, party) {
      get_election_date <- function(state, party) {
        get_calendar <- function(party) {
          if ("primary_calendar.csv" %in% list.files()) {
            cal <- read.csv("primary_calendar.csv")
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
            write.csv(cal, "primary_calendar.csv", row.names = F)
          }
          cal
        }
        cal <- get_calendar(party)
        cal$Date[cal$State == state]
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


leaders <- function(state) {
  dta <- nyt_retrieve(state)[["toplines"]]
  dta <-
    dta[order(dta$percent, decreasing = T), c("last_name", "votes", "percent", "winner")]
  #cat("===================================\n");
  cat("=========", stringr::str_pad(toupper(state), 14, "both"), "=========\n")
  if (any(dta$winner)) {
    cat(stringr::str_pad(paste0("CALL: ", toupper(dta$last_name[dta$winner])), 34, "both"), "\n\n")
  } else {
    cat(stringr::str_pad("NO CALL", 34, "both"), "\n\n")
  }
  cat(format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z"), "\n")
  print(dta[dta$last_name %in% c("Biden", "Sanders"),])
  cat("==================================\n\n");
}

# setwd("~/project-harvest")

sink("~/Desktop/election.txt")

while (TRUE) {

  # 2020-02-03
  leaders("Iowa")
  # 2020-02-11
  leaders("New Hampshire")
  # 2020-02-22
  leaders("Nevada")
  # 2020-02-29
  leaders("South Carolina")
  # 2020-03-03
  leaders("Alabama")
  leaders("Arkansas")
  leaders("California")
  leaders("Colorado")
  leaders("Maine")
  leaders("Massachusetts")
  leaders("Minnesota")
  leaders("North Carolina")
  leaders("Oklahoma")
  leaders("Tennessee")
  leaders("Texas")
  leaders("Utah")
  leaders("Vermont")
  leaders("Virginia")
  # 2020-03-10
  leaders("Michigan")
  leaders("Washington")
  leaders("Missouri")
  leaders("Mississippi")
  leaders("Idaho")
  leaders("North Dakota")
  # 2020-03-17
  leaders("Arizona")
  leaders("Florida")
  leaders("Illinois")
  # 2020-04-07
  leaders("Wisconsin")
  # 2020-04-10
  leaders("Alaska")
  # 2020-04-28
  leaders("Ohio")
  # 2020-05-02
  leaders("Kansas")
  # 2020-05-12
  leaders("Nebraska")
  Sys.sleep(30)
}


sink()

