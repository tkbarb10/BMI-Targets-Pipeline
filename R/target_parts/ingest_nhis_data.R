# Ingest and filter NHIS data then combine and save to disk--------------------------------------------------------

ingest_nhis_data <- list(
  tar_target(
    survey_years,
    c(2000:2018)
  ),
  tar_target(
    nhis_dataframes,
    readRDS(sprintf("data/raw_data/NHIS_data/NHIS_%s.rds", survey_years)),
    pattern = map(survey_years)
  ),
  tar_target(
    variables_to_use,
    source("R/ingest_data/variables_to_use.R")$value
  ),
  tar_target(
    filtered_nhis_dataframes,
    filter_nhis(nhis_dataframes, variables_to_use),
    pattern = map(nhis_dataframes)
  ),
  tar_target(
    combined_nhis,
    write_nhis(filtered_nhis_dataframes)
  )
)