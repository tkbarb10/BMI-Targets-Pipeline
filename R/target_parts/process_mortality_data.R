# Ingest mortality data, combine, filter by confirmed deceased ----------------------


process_mortality_data <- list(
  tar_target(
    mortality_years,
    2000:2018
  ),
  tar_target(
    mortality_dataframes,
    mortality_df(mortality_years),
    pattern = map(mortality_years),
    format = 'parquet'
  ),
  tar_target(
    combined_mort,
    bind_rows(mortality_dataframes),
    format = 'parquet'
  ),
  tar_target(
    filtered_mort,
    filter_mortality_data(combined_mort),
    format = 'parquet'
  )
)