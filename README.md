```
      __  __            __   _               __          __  
     / / / /___  ____  / /__(_)___  _____   / /   ____ _/ /_ 
    / /_/ / __ \/ __ \/ //_/ / __ \/ ___/  / /   / __ `/ __ \
   / __  / /_/ / /_/ / ,< / / / / (__  )  / /___/ /_/ / /_/ /
  /_/ /_/\____/ .___/_/|_/_/_/ /_/____/  /_____/\__,_/_.___/ 
             /_/                                             
```
# Project Harvest (Election Scraping)
Scrape polls and election result data from various news sites and aggregators. 

[Click here for the GitHub repo.](https://github.com/UnlikelyVolcano/project-harvest)

## Sites
- [New York Times](https://www.nytimes.com) (NYT)
- [FiveThirtyEight](https://fivethirtyeight.com) (FTE or 538)
- [RealClearPolitics](https://www.realclearpolitics.com) (RCP)

## Structure
- `_tables` has CSV files for `polls` and `results`.
- `_data` has RDS files  for `polls` and `results`. (Usage: `obj <- readRDS("file")`)
- `_code` has R scripts:
    * `NYT_Results.R` scrapes election results from NYT given a state.
    * `RCP_Polls.R` scrapes polling results (and computes median spread) from RCP given an ID.
- `pollster_crosswalk.csv` matches the RCP pollster names to the FTE ratings in `polster-ratings.csv`.

## To-Do
- Systematically identify poll IDs from RCP
- Add more sources
- Gather polls in a central database
- Gather results in a central databse

<p><img alt="Clicky" width="1" height="1" src="//in.getclicky.com/101237072ns.gif" /></p>
