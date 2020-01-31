# RCP Scrape Functions
Get data on match-ups between Trump and Democrats.

[See this site for neatly organized second choices by candidate](https://morningconsult.com/2020-democratic-primary/)

See the file `all_polls_second_choice.csv` for raw second choice percentages.

## Structure
------
`_tables` has CSV files.
`_data` has RDS files (`obj <- readRDS("file")`)
`_code` has R scripts.

## Potential future improvements
------
- Procedurally retrieve table URLs given a list of states
- Retrieve more poll types
