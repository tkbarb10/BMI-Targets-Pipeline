# Ingest NHANES raw data from website

ingest.nhanes.data <- list(
  tar_target(
    table.manifest,
    nhanesManifest(which = 'public')
  ),
  tar_target(
    data.manifest,
    nhanes(
      nh_table = table_names,
      includelabels = T,
      translated = F
      ),
    pattern = map(table_name = table.manifest$Table)
  )
)
