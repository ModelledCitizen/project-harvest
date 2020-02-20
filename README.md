# RCP Scrape Functions
Get data on match-ups between Trump and Democrats.

See the file `all_polls_second_choice.csv` for raw second choice percentages.

## Structure
- `_tables` has CSV files.
- `_data` has RDS files (`obj <- readRDS("file")`)
- `_code` has R scripts: run in order unless you have a specific need, but don't run the Unique IDs on tables that already have UIDs.

## Potential future improvements
- Procedurally retrieve table URLs given a list of states
- Retrieve more poll types
