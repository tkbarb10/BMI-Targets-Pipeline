# Ingest NHANES raw data from website

ingest.nhanes.data <- list(
  tar_target(
    table.manifest,
    nhanesManifest(which = 'public'),
    format = 'parquet'
  ),
  tar_target(
    grouped.tables,
    GroupedTables(table.manifest)
  ),
  tar_target( # adjust this to take the above instead
    data.manifest,
    nhanes(
      nh_table = table_names,
      includelabels = T,
      translated = F
      ),
    pattern = map(table_name = table.manifest$Table)
  )
)
