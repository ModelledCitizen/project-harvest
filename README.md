# Project Harvest (Election Scraping)
Scrape polls and election result data from various news sites and aggregators. 

## Sites
- [New York Times](https://www.nytimes.com) (NYT)
- [FiveThirtyEight](https://fivethirtyeight.com) (FTE or 538)
- [RealClearPolitics](https://www.realclearpolitics.com) (RCP)

## Structure
- `_tables` has CSV files for `polls` and `results`.
- `_data` has RDS files  for `polls` and `results`. (`obj <- readRDS("file")`)
- `_code` has R scripts:
    * `NYT_Results.R` scrapes election results from NYT given a state.
    * `RCP_Polls.R` scrapes polling results (and computes median spread) from RCP given an ID.
- `fte_rcp_crosswalk.csv` matches the RCP pollster names to the FTE ratings in `polster-ratings.csv`.

## To-Do
- Systematically identify poll IDs from RCP
- Add more sources
- Gather polls in a central database
- Gather results in a central databse

