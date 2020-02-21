# RCP Scrape Functions
Scrape RCP polling data, either by URL for HTML tables or by ID number for JSON data. Focus on match-ups between Trump and Democrats in a hypothetical general election.

## Structure
- `_tables` has CSV files.
- `_data` has RDS files. (`obj <- readRDS("file")`)
- `_code` has R scripts:
    * `HTML Table Scraping.R` uses tables published on RCP's website.
    * `JSON Scraping.R` uses raw data used to make the tables.
- `fte_rcp_crosswalk.csv` matches the RCP pollster names to the 538 ratings in `polster-ratings.csv`.

## To-Do
- ~~Procedurally retrieve table URLs given a list of states~~
- ~~JSON transition obviates need for URLs, just need Poll IDs~~
- Retrieve more poll types
