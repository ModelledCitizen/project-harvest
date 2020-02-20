# RCP Scrape Functions
Get data on match-ups between Trump and Democrats.

Currently scrapes visible HTML tables to find median spread in all polls but I have started to switch over to just grabbing the raw JSON and using that.

## Structure
- `_tables` has CSV files.
- `_data` has RDS files (`obj <- readRDS("file")`)
- `_code` has an R script that can generate all of the data and tables if fed the proper URLs

## Potential future improvements
- ~~Procedurally retrieve table URLs given a list of states~~
- JSON transition obviates need for URLs, just need Poll IDs
- Retrieve more poll types
