# Link mortality and nhis -------------------------------------------------


link_mort_data <- list(
  tar_target(
    linked_nhis,
    inner_join(combined_nhis, filtered_mort, by = join_by(UUID == PUBLICID)),
    format = 'parquet'
  )
)