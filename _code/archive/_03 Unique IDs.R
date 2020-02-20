#      __  __            __   _               __          __
#     / / / /___  ____  / /__(_)___  _____   / /   ____ _/ /_
#    / /_/ / __ \/ __ \/ //_/ / __ \/ ___/  / /   / __ `/ __ \
#   / __  / /_/ / /_/ / ,< / / / / (__  )  / /___/ /_/ / /_/ /
#  /_/ /_/\____/ .___/_/|_/_/_/ /_/____/  /_____/\__,_/_.___/
#             /_/
#

setwd("~/rcp-scraping")


assign_ids <- function(filename) {
  data <- readRDS(file = paste0("_data/", filename, ".rds"))
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
  saveRDS(data, file = paste0("_data/", filename, ".rds"))
  for (i in 1:length(data)) {
    write.csv(
      data[[i]],
      file = paste0("_tables/", filename, "_", names(data)[i], ".csv"),
      row.names = F
    )
    rm(i)
  }
}


assign_ids("national")

assign_ids("iowa")

assign_ids("newhampshire")

assign_ids("southcarolina")

assign_ids("nevada")

