#      __  __            __   _               __          __
#     / / / /___  ____  / /__(_)___  _____   / /   ____ _/ /_
#    / /_/ / __ \/ __ \/ //_/ / __ \/ ___/  / /   / __ `/ __ \
#   / __  / /_/ / /_/ / ,< / / / / (__  )  / /___/ /_/ / /_/ /
#  /_/ /_/\____/ .___/_/|_/_/_/ /_/____/  /_____/\__,_/_.___/
#             /_/
#

setwd("~/rcp-scraping")

national_data <- readRDS(file = "_data/national.rds")


find_spread <-
  function(dta) {
    ind <-
      which(
        names(dta) %in% c(
          "Warren (D)",
          "Biden (D)",
          "Sanders (D)",
          "Buttigieg (D)",
          "Klobuchar (D)"
        )
      )
    dta[dta$Poll != "RCP Average", "Trump (R)"] - dta[dta$Poll != "RCP Average", ind]
  }

spreads <- lapply(national_data, find_spread)

medians <- sapply(spreads, median)
