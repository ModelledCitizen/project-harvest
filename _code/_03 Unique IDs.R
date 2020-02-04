#      __  __            __   _               __          __
#     / / / /___  ____  / /__(_)___  _____   / /   ____ _/ /_
#    / /_/ / __ \/ __ \/ //_/ / __ \/ ___/  / /   / __ `/ __ \
#   / __  / /_/ / /_/ / ,< / / / / (__  )  / /___/ /_/ / /_/ /
#  /_/ /_/\____/ .___/_/|_/_/_/ /_/____/  /_____/\__,_/_.___/
#             /_/
#

setwd("~/rcp-scraping")



national_data <- readRDS(file = "_data/national.rds")
national_ids <-
  unique(unlist(sapply(national_data, function(x) {
    paste(x$Poll, x$Date)
  })))
national_ids <-
  data.frame(names = national_ids, id = sample(1000:9999, length(national_ids)))
national_data <-
  lapply(national_data, function(x) {
    x[["names"]] <- paste(x$Poll, x$Date)
    return(x)
  })
national_data <-
  lapply(national_data, function(x) {
    merge(x, national_ids, by = "names", all.x = T)
  })
national_data <-
  lapply(national_data, function(x) {
    x[["names"]] <- NULL
    return(x)
  })
saveRDS(national_data, file = "_data/national.rds")
for (i in 1:length(national_data)) {
  write.csv(
    national_data[[i]],
    file = paste0("_tables/national_", names(national_data)[i], ".csv"),
    row.names = F
  )
  rm(i)
}



iowa_data <- readRDS(file = "_data/iowa.rds")
iowa_ids <-
  unique(unlist(sapply(iowa_data, function(x) {
    paste(x$Poll, x$Date)
  })))
iowa_ids <-
  data.frame(names = iowa_ids, id = sample(1000:9999, length(iowa_ids)))
iowa_data <-
  lapply(iowa_data, function(x) {
    x[["names"]] <- paste(x$Poll, x$Date)
    return(x)
  })
iowa_data <-
  lapply(iowa_data, function(x) {
    merge(x, iowa_ids, by = "names", all.x = T)
  })
iowa_data <-
  lapply(iowa_data, function(x) {
    x[["names"]] <- NULL
    return(x)
  })
saveRDS(iowa_data, file = "_data/iowa.rds")
for (i in 1:length(iowa_data)) {
  write.csv(
    iowa_data[[i]],
    file = paste0("_tables/iowa_", names(iowa_data)[i], ".csv"),
    row.names = F
  )
  rm(i)
}



newhampshire_data <- readRDS(file = "_data/newhampshire.rds")
newhampshire_ids <-
  unique(unlist(sapply(newhampshire_data, function(x) {
    paste(x$Poll, x$Date)
  })))
newhampshire_ids <-
  data.frame(names = newhampshire_ids, id = sample(1000:9999, length(newhampshire_ids)))
newhampshire_data <-
  lapply(newhampshire_data, function(x) {
    x[["names"]] <- paste(x$Poll, x$Date)
    return(x)
  })
newhampshire_data <-
  lapply(newhampshire_data, function(x) {
    merge(x, newhampshire_ids, by = "names", all.x = T)
  })
newhampshire_data <-
  lapply(newhampshire_data, function(x) {
    x[["names"]] <- NULL
    return(x)
  })
saveRDS(newhampshire_data, file = "_data/newhampshire.rds")
for (i in 1:length(newhampshire_data)) {
  write.csv(
    newhampshire_data[[i]],
    file = paste0("_tables/newhampshire_", names(newhampshire_data)[i], ".csv"),
    row.names = F
  )
  rm(i)
}



southcarolina_data <- readRDS(file = "_data/southcarolina.rds")
southcarolina_ids <-
  unique(unlist(sapply(southcarolina_data, function(x) {
    paste(x$Poll, x$Date)
  })))
southcarolina_ids <-
  data.frame(names = southcarolina_ids, id = sample(1000:9999, length(southcarolina_ids)))
southcarolina_data <-
  lapply(southcarolina_data, function(x) {
    x[["names"]] <- paste(x$Poll, x$Date)
    return(x)
  })
southcarolina_data <-
  lapply(southcarolina_data, function(x) {
    merge(x, southcarolina_ids, by = "names", all.x = T)
  })
southcarolina_data <-
  lapply(southcarolina_data, function(x) {
    x[["names"]] <- NULL
    return(x)
  })
saveRDS(southcarolina_data, file = "_data/newhampshire.rds")
for (i in 1:length(southcarolina_data)) {
  write.csv(
    southcarolina_data[[i]],
    file = paste0("_tables/southcarolina_", names(southcarolina_data)[i], ".csv"),
    row.names = F
  )
  rm(i)
}




nevada_data <- readRDS(file = "_data/nevada.rds")
nevada_ids <-
  unique(unlist(sapply(nevada_data, function(x) {
    paste(x$Poll, x$Date)
  })))
nevada_ids <-
  data.frame(names = nevada_ids, id = sample(1000:9999, length(nevada_ids)))
nevada_data <-
  lapply(nevada_data, function(x) {
    x[["names"]] <- paste(x$Poll, x$Date)
    return(x)
  })
nevada_data <-
  lapply(nevada_data, function(x) {
    merge(x, nevada_ids, by = "names", all.x = T)
  })
nevada_data <-
  lapply(nevada_data, function(x) {
    x[["names"]] <- NULL
    return(x)
  })
saveRDS(nevada_data, file = "_data/nevada.rds")
for (i in 1:length(nevada_data)) {
  write.csv(
    nevada_data[[i]],
    file = paste0("_tables/nevada_", names(nevada_data)[i], ".csv"),
    row.names = F
  )
  rm(i)
}
